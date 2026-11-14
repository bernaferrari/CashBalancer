// don't import moor_web.dart or moor_flutter/moor_flutter.dart in shared code
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import '../util/get_color_by_quantile.dart';
import 'data.dart';
import 'backup.dart';
import '../page_rebalance/rebalance_plan.dart';

export 'database/shared.dart';

part 'database.g.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get backupId => text().nullable().clientDefault(newBackupId)();

  IntColumn get userId => integer()();

  TextColumn get name => text()();

  TextColumn get colorName => text()();

  RealColumn get targetPercent => real()();
}

class Users extends Table {
  TextColumn get currencySymbol => text().nullable()();
  IntColumn get id => integer().autoIncrement()();

  TextColumn get backupId => text().nullable().clientDefault(newBackupId)();

  TextColumn get name => text()();
}

class Items extends Table {
  BoolColumn get isBalance => boolean().withDefault(const Constant(false))();
  IntColumn get id => integer().autoIncrement()();

  TextColumn get backupId => text().nullable().clientDefault(newBackupId)();

  IntColumn get walletId => integer()();

  IntColumn get userId => integer()();

  TextColumn get name => text()();

  RealColumn get quantity => real()();

  RealColumn get price => real()();

  RealColumn get targetPercent => real()();
}

@DriftDatabase(
  tables: [Users, Wallets, Items],
  queries: {
    'userExists': '''SELECT count(1) where exists (select * from users)''',
  },
)
class Database(super.e) extends _$Database {
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) {
        return m.createAll();
      },
      onUpgrade: (m, from, to) async {
        await transaction(() async {
          if (from < 2) await m.addColumn(users, users.currencySymbol);
          if (from < 3) {
            await m.addColumn(users, users.backupId);
            await m.addColumn(wallets, wallets.backupId);
            await m.addColumn(items, items.backupId);
            await m.addColumn(items, items.isBalance);
            // Keep the previous behavior for existing quantity-one entries.
            await customStatement(
              'UPDATE items SET is_balance = 1 WHERE quantity = 1',
            );
            for (final table in <TableInfo>[users, wallets, items]) {
              await customStatement(
                'UPDATE ${table.actualTableName} SET backup_id = lower(hex(randomblob(16)))',
              );
            }
          }
        });
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          await into(users).insert(UsersCompanion.insert(name: ''));
        }
      },
    );
  }

  // Users, Wallets : [Items]
  Stream<FullData> watchWallets(int userId) {
    final walletsQuery = select(wallets)
      ..where((item) => item.userId.equals(userId));

    final itemsQuery = select(items)
      ..where((item) => item.userId.equals(userId));

    final rxPrefs = RxSharedPreferences.getInstance();
    final relativeTargetStream = rxPrefs.getBoolStream('relativeTarget');
    final buyOnlyStream = rxPrefs.getBoolStream('buyOnly');
    final currencySymbolStream = rxPrefs.getStringStream('currencySymbol');
    final sortBy = rxPrefs.getIntStream('sortBy');
    final themeMode = rxPrefs.getIntStream('themeMode');
    final languageCodeStream = rxPrefs.getStringStream('languageCode');

    final settingsData =
        Rx.combineLatest6<
          bool?,
          bool?,
          String?,
          int?,
          int?,
          String?,
          SettingsData
        >(
          relativeTargetStream,
          buyOnlyStream,
          currencySymbolStream,
          sortBy,
          themeMode,
          languageCodeStream,
          (
            relativeTarget,
            buyOnly,
            currencySymbol,
            sortBy,
            themeMode,
            languageCode,
          ) {
            return SettingsData(
              relativeTarget: relativeTarget ?? false,
              buyOnly: buyOnly ?? false,
              currencySymbol: currencySymbol ?? "\$",
              sortBy: sortBy ?? 0,
              themeMode: themeMode ?? 0,
              languageCode: (languageCode != null && languageCode.isNotEmpty)
                  ? languageCode
                  : null,
            );
          },
        );

    return Rx.combineLatest4<
      List<User>,
      List<Wallet>,
      List<Item>,
      SettingsData,
      FullData
    >(
      select(users).watch(),
      walletsQuery.watch(),
      itemsQuery.watch(),
      settingsData,
      (usersList, walletsList, itemsList, settings) {
        final currentUser = usersList.where((u) => u.id == userId).firstOrNull;
        final List<Item> sortedItems = [...itemsList]
          ..sort((a, b) {
            return settings.sortBy == 0
                ? b.totalValue.compareTo(a.totalValue)
                : a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
        final Map<int, List<Item>> groupedItems = groupByWalletId(sortedItems);

        final walletsMap = <int, WalletData>{};
        double totalValue = 0;
        for (final wallet in walletsList) {
          final walletValue =
              groupedItems[wallet.id]?.fold<double>(
                0,
                (a, b) => a + b.totalValue,
              ) ??
              0;
          totalValue += walletValue;
          walletsMap[wallet.id] = WalletData(wallet, walletValue);
        }

        final Map<int, Color> colors = getColorByQuantile(
          groupedItems,
          walletsMap,
        );

        final allItemData = sortedItems
            .where((d) => walletsMap.containsKey(d.walletId))
            .map(
              (d) => ItemData(
                item: d,
                colorName: walletsMap[d.walletId]?.colorName ?? 'gray',
                color: colors[d.id] ?? const Color(0xFF9E9E9E),
              ),
            )
            .toList();

        // Keep the Groups sorted, so the front can just display them.
        final List<WalletData> sortedWalletsList;
        if (settings.sortBy == 0) {
          sortedWalletsList = walletsMap.values.toList()
            ..sort((a, b) => b.totalValue.compareTo(a.totalValue));
        } else {
          sortedWalletsList = walletsMap.values.toList()
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
        }

        final LinkedHashMap<int, WalletData> sortedWalletsMap = LinkedHashMap();

        for (var group in sortedWalletsList) {
          sortedWalletsMap[group.id] = group;
        }

        final Map<int, List<ItemData>> groupedItemData = groupByWalletId(
          allItemData,
        );

        return FullData(
          userId: userId,
          userName: currentUser?.name ?? '',
          portfolios: usersList,
          totalValue: totalValue,
          allItems: allItemData,
          walletsItems: groupedItemData,
          walletsMap: sortedWalletsMap,
          settings: settings.withCurrency(currentUser?.currencySymbol),
        );
      },
    );
  }

  Map<int, List<T>> groupByWalletId<T extends Item>(List<T> itemList) {
    final groupedList = <int, List<T>>{};
    for (final item in itemList) {
      (groupedList[item.walletId] ??= <T>[]).add(item);
    }
    return groupedList;
  }

  Future<int> createUser(String description) {
    return into(users).insert(UsersCompanion.insert(name: description));
  }

  Future<bool> editUser(User user) {
    return update(users).replace(user);
  }

  Future<int> createGroup({
    required int id,
    required String name,
    required String colorName,
    required double targetPercent,
  }) {
    return into(wallets).insert(
      WalletsCompanion.insert(
        userId: id,
        name: name,
        colorName: colorName,
        targetPercent: targetPercent,
      ),
    );
  }

  Future<bool> editWallet(Wallet group) {
    return update(wallets).replace(group);
  }

  Future<int> createItem({
    required int walletId,
    required int userId,
    required String name,
    required String value,
    required String target,
    String quantity = '1',
    bool isBalance = false,
  }) {
    final parsedQty = quantity.trim().isEmpty ? 1.0 : double.parse(quantity);
    return into(items).insert(
      ItemsCompanion.insert(
        walletId: walletId,
        userId: userId,
        name: name,
        quantity: isBalance ? 1 : parsedQty,
        isBalance: Value(isBalance),
        price: double.parse(value),
        targetPercent: double.tryParse(target) ?? -1,
      ),
    );
  }

  Future<bool> updateItem({
    required Item item,
    required String name,
    required String price,
    required String target,
    String? quantity,
    bool? isBalance,
  }) {
    final parsedQty = quantity == null
        ? item.quantity
        : quantity.trim().isEmpty
        ? 1.0
        : double.parse(quantity);
    return update(items).replace(
      item.copyWith(
        name: name,
        quantity: (isBalance ?? item.isBalance) ? 1 : parsedQty,
        isBalance: isBalance ?? item.isBalance,
        price: double.parse(price),
        targetPercent: double.tryParse(target) ?? -1,
      ),
    );
  }

  Future<void> applyTrades(Iterable<Item> holdings, Map<int, double> deltas) =>
      transaction(() async {
        for (final item in holdings) {
          final delta = deltas[item.id] ?? 0;
          if (delta.abs() < 0.005) continue;
          final amountOnly = item.isBalance;
          final price = amountOnly
              ? (item.totalValue + delta).clamp(0.0, double.infinity)
              : item.price;
          final quantity = amountOnly
              ? 1.0
              : quantityAfterTrade(item.price, item.totalValue, delta);
          final current = await getItemFromId(item.id);
          if (!price.isFinite ||
              quantity == null ||
              !quantity.isFinite ||
              current == null ||
              current.price != item.price ||
              current.quantity != item.quantity ||
              current.isBalance != item.isBalance ||
              current.walletId != item.walletId ||
              current.targetPercent != item.targetPercent) {
            throw StateError('Holdings changed or trade has no valid price');
          }
          await (update(items)..where((t) => t.id.equals(item.id))).write(
            ItemsCompanion(quantity: Value(quantity), price: Value(price)),
          );
        }
      });

  Future<void> updatePrice(int id, double price) async {
    final changed = await (update(items)..where((t) => t.id.equals(id))).write(
      ItemsCompanion(price: Value(price)),
    );
    if (changed != 1) throw StateError('Asset no longer exists');
  }

  Future<bool> updateItemWallet({required Item item, required int walletId}) {
    return update(items).replace(item.copyWith(walletId: walletId));
  }

  Future<void> Function() _restoreRows({
    User? portfolio,
    List<Wallet> walletRows = const [],
    List<Item> itemRows = const [],
  }) =>
      () => transaction(() async {
        if (portfolio != null) {
          final current = await (select(
            users,
          )..where((u) => u.id.equals(portfolio.id))).getSingleOrNull();
          if (current != portfolio) await into(users).insert(portfolio);
        }
        for (final wallet in walletRows) {
          final parent = await (select(
            users,
          )..where((u) => u.id.equals(wallet.userId))).getSingleOrNull();
          if (parent == null) throw StateError('Portfolio no longer exists');
          final current = await (select(
            wallets,
          )..where((w) => w.id.equals(wallet.id))).getSingleOrNull();
          if (current != wallet) await into(wallets).insert(wallet);
        }
        for (final item in itemRows) {
          final parent =
              await (select(wallets)..where(
                    (w) =>
                        w.id.equals(item.walletId) &
                        w.userId.equals(item.userId),
                  ))
                  .getSingleOrNull();
          if (parent == null) throw StateError('Wallet no longer exists');
          if (await getItemFromId(item.id) != item) {
            await into(items).insert(item);
          }
        }
      });

  Future<Future<void> Function()> deleteItem(Item item) =>
      transaction(() async {
        final current = await getItemFromId(item.id);
        if (current == null) throw StateError('Asset no longer exists');
        await (delete(items)..where((t) => t.id.equals(item.id))).go();
        return _restoreRows(itemRows: [current]);
      });

  Future<Future<void> Function()> deleteWallet(int walletId) =>
      transaction(() async {
        final wallet = await (select(
          wallets,
        )..where((t) => t.id.equals(walletId))).getSingle();
        final assets = await (select(
          items,
        )..where((t) => t.walletId.equals(walletId))).get();
        await (delete(items)..where((t) => t.walletId.equals(walletId))).go();
        await (delete(wallets)..where((t) => t.id.equals(walletId))).go();
        return _restoreRows(walletRows: [wallet], itemRows: assets);
      });

  Future<({int nextId, Future<void> Function() undo})> deletePortfolio(
    int id,
  ) => transaction(() async {
    final portfolio = await (select(
      users,
    )..where((t) => t.id.equals(id))).getSingle();
    final walletRows = await (select(
      wallets,
    )..where((t) => t.userId.equals(id))).get();
    final itemRows = await (select(
      items,
    )..where((t) => t.userId.equals(id))).get();
    await _clearPortfolio(id);
    await (delete(users)..where((t) => t.id.equals(id))).go();
    return (
      nextId: await getDefaultUser(),
      undo: _restoreRows(
        portfolio: portfolio,
        walletRows: walletRows,
        itemRows: itemRows,
      ),
    );
  });

  Future<void> _clearPortfolio(int id) async {
    await (delete(items)..where((t) => t.userId.equals(id))).go();
    await (delete(wallets)..where((t) => t.userId.equals(id))).go();
  }

  Future<void> setPortfolioCurrency(int id, String symbol) async {
    await (update(users)..where((t) => t.id.equals(id))).write(
      UsersCompanion(currencySymbol: Value(symbol)),
    );
  }

  Future<int> getDefaultUser() async {
    final existingUsers = await select(users).get();
    if (existingUsers.isNotEmpty) {
      return existingUsers.first.id;
    }
    return into(users).insert(UsersCompanion.insert(name: ''));
  }

  Future<Item?> getItemFromId(int id) async {
    return (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> seedSamplePortfolio(
    int userId, {
    String stocks = 'Stocks',
    String crypto = 'Crypto',
    String cash = 'Cash',
    String savings = 'High-yield savings',
    bool relative = false,
  }) async {
    await transaction(() async {
      if (await (select(wallets)..where((w) => w.userId.equals(userId)))
          .get()
          .then((rows) => rows.isNotEmpty)) {
        return;
      }
      final stocksId = await createGroup(
        id: userId,
        name: stocks,
        colorName: 'emerald',
        targetPercent: 60,
      );
      final cryptoId = await createGroup(
        id: userId,
        name: crypto,
        colorName: 'amber',
        targetPercent: 25,
      );
      final cashId = await createGroup(
        id: userId,
        name: cash,
        colorName: 'indigo',
        targetPercent: 15,
      );

      await createItem(
        walletId: stocksId,
        userId: userId,
        name: 'S&P 500 ETF',
        value: '4200',
        target: relative ? '60' : '40',
      );
      await createItem(
        walletId: stocksId,
        userId: userId,
        name: 'AAPL',
        value: '220',
        quantity: '8',
        target: relative ? '40' : '20',
      );
      await createItem(
        walletId: cryptoId,
        userId: userId,
        name: 'Bitcoin',
        value: '85000',
        quantity: '0.03',
        target: relative ? '72' : '18',
      );
      await createItem(
        walletId: cryptoId,
        userId: userId,
        name: 'Ethereum',
        value: '3000',
        quantity: '0.25',
        target: relative ? '28' : '7',
      );
      await createItem(
        walletId: cashId,
        userId: userId,
        name: savings,
        isBalance: true,
        value: '1200',
        target: relative ? '100' : '15',
      );
    });
  }

  Future<List<Map<String, Object?>>> _walletPayload(
    int userId, {
    bool includeIds = false,
  }) async {
    final userWallets = await (select(
      wallets,
    )..where((w) => w.userId.equals(userId))).get();
    final userItems = await (select(
      items,
    )..where((i) => i.userId.equals(userId))).get();
    return [
      for (final w in userWallets)
        {
          if (includeIds) 'id': w.backupId,
          'name': w.name,
          'colorName': w.colorName,
          'targetPercent': w.targetPercent,
          'items': [
            for (final i in userItems.where((x) => x.walletId == w.id))
              {
                if (includeIds) 'id': i.backupId,
                'isBalance': i.isBalance,
                'name': i.name,
                'quantity': i.quantity,
                'price': i.price,
                'targetPercent': i.targetPercent,
              },
          ],
        },
    ];
  }

  Future<String> exportPortfolioJson(int userId) => transaction(
    () async =>
        const JsonEncoder.withIndent('  ')
            .convert({'version': 1, 'wallets': await _walletPayload(userId)}),
  );

  Future<String> exportBackup() => transaction(() async {
    final currency =
        await RxSharedPreferences.getInstance().getString('currencySymbol') ??
        r'$';
    return const JsonEncoder.withIndent('  ').convert({
      'version': 3,
      'portfolios': [
        for (final portfolio in await select(users).get())
          {
            'id': portfolio.backupId,
            'name': portfolio.name,
            'currencySymbol': portfolio.currencySymbol ?? currency,
            'wallets': await _walletPayload(portfolio.id, includeIds: true),
          },
      ],
    });
  });

  Future<int> importPortfolioJson(
    int userId,
    String jsonString, {
    bool replace = false,
  }) async {
    final backup = decodeBackup(jsonString);
    return transaction(
      () async =>
          (await _restoreBackup(userId, backup, replace: replace)).firstId!,
    );
  }

  Future<({int added, int kept})> previewBackupMerge(
    int userId,
    String jsonString,
  ) async {
    final backup = decodeBackup(jsonString);
    final result = await transaction(
      () => _restoreBackup(userId, backup, preview: true),
    );
    return (added: result.added, kept: result.kept);
  }

  Future<({int? firstId, int added, int kept})> _restoreBackup(
    int userId,
    Backup backup, {
    bool preview = false,
    bool replace = false,
  }) async {
    if (replace && !backup.singlePortfolio) {
      await delete(items).go();
      await delete(wallets).go();
      await delete(users).go();
    }
    if (replace && backup.singlePortfolio) await _clearPortfolio(userId);

    final localUsers = await select(users).get();
    final localWallets = await select(wallets).get();
    final localItems = await select(items).get();
    final usedUsers = <int>{};
    final usedWallets = <int>{};
    final usedItems = <int>{};
    int? firstId;
    var added = 0;
    var kept = 0;

    for (final portfolio in backup.portfolios) {
      final user = backup.singlePortfolio
          ? localUsers.where((user) => user.id == userId).firstOrNull
          : matchBackupRow(
              localUsers,
              usedUsers,
              portfolio.id,
              portfolio.name,
              (user) => (user.id, user.backupId, user.name),
            );
      int? id = user?.id;
      if (id == null) {
        added++;
        if (!preview) {
          id = await into(users).insert(
            UsersCompanion.insert(
              name: portfolio.name,
              currencySymbol: Value(portfolio.currency),
              backupId: Value(portfolio.id ?? newBackupId()),
            ),
          );
        }
      } else if (!backup.singlePortfolio) {
        kept++;
      }
      firstId ??= id;

      for (final wallet in portfolio.wallets) {
        final localWallet = matchBackupRow(
          wallet.id == null
              ? localWallets.where((row) => row.userId == user?.id)
              : localWallets,
          usedWallets,
          wallet.id,
          wallet.name,
          (row) => (row.id, row.backupId, row.name),
        );
        int? walletId = localWallet?.id;
        if (walletId == null) {
          added++;
          if (!preview) {
            walletId = await into(wallets).insert(
              WalletsCompanion.insert(
                userId: id!,
                name: wallet.name,
                colorName: wallet.colorName,
                targetPercent: wallet.target,
                backupId: Value(wallet.id ?? newBackupId()),
              ),
            );
          }
        } else {
          kept++;
        }

        for (final item in wallet.items) {
          // An asset can move between wallets after the backup was created.
          final candidates = item.id == null
              ? localItems.where((row) => row.walletId == localWallet?.id)
              : localItems;
          final existing = matchBackupRow(
            candidates,
            usedItems,
            item.id,
            item.name,
            (row) => (row.id, row.backupId, row.name),
          );
          if (existing != null) {
            kept++;
            continue;
          }
          added++;
          if (!preview) {
            await into(items).insert(
              ItemsCompanion.insert(
                walletId: walletId!,
                userId: id!,
                name: item.name,
                quantity: item.quantity,
                price: item.price,
                targetPercent: item.target,
                isBalance: Value(item.isBalance),
                backupId: Value(item.id ?? newBackupId()),
              ),
            );
          }
        }
      }
    }
    return (firstId: firstId, added: added, kept: kept);
  }
}
