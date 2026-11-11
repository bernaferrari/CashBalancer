// don't import moor_web.dart or moor_flutter/moor_flutter.dart in shared code
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import '../util/get_color_by_quantile.dart';
import 'data.dart';

export 'database/shared.dart';

part 'database.g.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer()();

  TextColumn get name => text()();

  TextColumn get colorName => text()();

  RealColumn get targetPercent => real()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) {
        return m.createAll();
      },
      onUpgrade: (m, from, to) async {},
      beforeOpen: (details) async {
        if (details.wasCreated) {
          await into(users).insert(UsersCompanion.insert(name: 'Wallet #1'));
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

    final settingsData = Rx.combineLatest6<bool?, bool?, String?, int?, int?,
        String?, SettingsData>(
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
          languageCode:
              (languageCode != null && languageCode.isNotEmpty)
                  ? languageCode
                  : null,
        );
      },
    );

    return Rx.combineLatest4<List<User>, List<Wallet>, List<Item>, SettingsData,
            FullData>(
        select(users).watch(),
        walletsQuery.watch(),
        itemsQuery.watch(),
        settingsData, (usersList, walletsList, itemsList, settings) {
      final currentUser =
          usersList.where((u) => u.id == userId).firstOrNull;
      final List<Item> sortedItems = [...itemsList]..sort((a, b) {
          return b.totalValue.compareTo(a.totalValue);
        });
      final Map<int, List<Item>> groupedItems = groupByWalletId(sortedItems);

      final walletsMap = <int, WalletData>{};
      double totalValue = 0;
      for (final wallet in walletsList) {
        final walletValue = groupedItems[wallet.id]
                ?.fold<double>(0, (a, b) => a + b.totalValue) ??
            0;
        totalValue += walletValue;
        walletsMap[wallet.id] = WalletData(wallet, walletValue);
      }

      final Map<int, Color> colors =
          getColorByQuantile(groupedItems, walletsMap);

      final allItemData = sortedItems
          .where((d) => walletsMap.containsKey(d.walletId))
          .map((d) => ItemData(
                item: d,
                colorName: walletsMap[d.walletId]?.colorName ?? 'gray',
                color: colors[d.id] ?? const Color(0xFF9E9E9E),
              ))
          .toList();

      // Keep the Groups sorted, so the front can just display them.
      final List<WalletData> sortedWalletsList;
      if (settings.sortBy == 0) {
        sortedWalletsList = walletsMap.values.toList()
          ..sort((a, b) => b.totalValue.compareTo(a.totalValue));
      } else {
        sortedWalletsList = walletsMap.values.toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      }

      final LinkedHashMap<int, WalletData> sortedWalletsMap = LinkedHashMap();

      for (var group in sortedWalletsList) {
        sortedWalletsMap[group.id] = group;
      }

      final Map<int, List<ItemData>> groupedItemData =
          groupByWalletId(allItemData);

      return FullData(
        userId: userId,
        userName: currentUser?.name ?? 'Wallet #1',
        portfolios: usersList,
        totalValue: totalValue,
        allItems: allItemData,
        walletsItems: groupedItemData,
        walletsMap: sortedWalletsMap,
        settings: settings,
      );
    });
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
    return into(wallets).insert(WalletsCompanion.insert(
      userId: id,
      name: name,
      colorName: colorName,
      targetPercent: targetPercent,
    ));
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
  }) {
    final parsedQty = double.tryParse(quantity);
    return into(items).insert(ItemsCompanion.insert(
      walletId: walletId,
      userId: userId,
      name: name,
      quantity: (parsedQty != null && parsedQty > 0) ? parsedQty : 1,
      price: double.parse(value),
      targetPercent: double.tryParse(target) ?? -1,
    ));
  }

  Future<bool> updateItem({
    required Item item,
    required String name,
    required String price,
    required String target,
    String? quantity,
  }) {
    final parsedQty = quantity != null ? double.tryParse(quantity) : null;
    return update(items).replace(item.copyWith(
      name: name,
      quantity:
          (parsedQty != null && parsedQty > 0) ? parsedQty : item.quantity,
      price: double.parse(price),
      targetPercent: double.tryParse(target) ?? -1,
    ));
  }

  Future<bool> updateItemWallet({
    required Item item,
    required int walletId,
  }) {
    return update(items).replace(item.copyWith(walletId: walletId));
  }

  Future<int> deleteItem(Item item) {
    return (delete(items)..where((t) => t.id.equals(item.id))).go();
  }

  Future<void> deleteWallet(int walletId) async {
    await (delete(items)..where((t) => t.walletId.equals(walletId))).go();
    await (delete(wallets)..where((t) => t.id.equals(walletId))).go();
  }

  Future<int> deletePortfolio(int portfolioUserId) async {
    await (delete(items)..where((t) => t.userId.equals(portfolioUserId))).go();
    await (delete(wallets)..where((t) => t.userId.equals(portfolioUserId)))
        .go();
    await (delete(users)..where((t) => t.id.equals(portfolioUserId))).go();
    return getDefaultUser();
  }

  Future<int> getDefaultUser() async {
    final existingUsers = await select(users).get();
    if (existingUsers.isNotEmpty) {
      return existingUsers.first.id;
    }
    return into(users).insert(UsersCompanion.insert(name: 'Wallet #1'));
  }

  Future<Item?> getItemFromId(int id) async {
    return (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> seedSamplePortfolio(int userId) async {
    await transaction(() async {
      final stocksId = await createGroup(
        id: userId,
        name: 'Stocks',
        colorName: 'emerald',
        targetPercent: 60,
      );
      final cryptoId = await createGroup(
        id: userId,
        name: 'Crypto',
        colorName: 'amber',
        targetPercent: 25,
      );
      final cashId = await createGroup(
        id: userId,
        name: 'Cash',
        colorName: 'indigo',
        targetPercent: 15,
      );

      await createItem(
        walletId: stocksId,
        userId: userId,
        name: 'S&P 500 ETF',
        value: '4200',
        target: '40',
      );
      await createItem(
        walletId: stocksId,
        userId: userId,
        name: 'AAPL',
        value: '220',
        quantity: '8',
        target: '20',
      );
      await createItem(
        walletId: cryptoId,
        userId: userId,
        name: 'Bitcoin',
        value: '85000',
        quantity: '0.03',
        target: '18',
      );
      await createItem(
        walletId: cryptoId,
        userId: userId,
        name: 'Ethereum',
        value: '3000',
        quantity: '0.25',
        target: '7',
      );
      await createItem(
        walletId: cashId,
        userId: userId,
        name: 'High-Yield Savings',
        value: '1200',
        target: '15',
      );
    });
  }

  Future<String> exportPortfolioJson(int userId) async {
    final userWallets =
        await (select(wallets)..where((w) => w.userId.equals(userId))).get();
    final userItems =
        await (select(items)..where((i) => i.userId.equals(userId))).get();

    final payload = {
      'version': 1,
      'wallets': [
        for (final w in userWallets)
          {
            'name': w.name,
            'colorName': w.colorName,
            'targetPercent': w.targetPercent,
            'items': [
              for (final i in userItems.where((x) => x.walletId == w.id))
                {
                  'name': i.name,
                  'quantity': i.quantity,
                  'price': i.price,
                  'targetPercent': i.targetPercent,
                },
            ],
          },
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> importPortfolioJson(int userId, String jsonString) async {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final walletsJson = decoded['wallets'] as List<dynamic>? ?? const [];

    await transaction(() async {
      for (final rawWallet in walletsJson) {
        final wMap = rawWallet as Map<String, dynamic>;
        final walletId = await createGroup(
          id: userId,
          name: (wMap['name'] as String?) ?? 'Wallet',
          colorName: (wMap['colorName'] as String?) ?? 'emerald',
          targetPercent: (wMap['targetPercent'] as num?)?.toDouble() ?? -1,
        );
        final itemsJson = wMap['items'] as List<dynamic>? ?? const [];
        for (final rawItem in itemsJson) {
          final iMap = rawItem as Map<String, dynamic>;
          await into(items).insert(
            ItemsCompanion.insert(
              walletId: walletId,
              userId: userId,
              name: (iMap['name'] as String?) ?? 'Asset',
              quantity: (iMap['quantity'] as num?)?.toDouble() ?? 1,
              price: (iMap['price'] as num?)?.toDouble() ?? 0,
              targetPercent: (iMap['targetPercent'] as num?)?.toDouble() ?? -1,
            ),
          );
        }
      }
    });
  }
}
