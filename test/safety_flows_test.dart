import 'package:cash_balancer/database/database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Database db;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = Database(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  test('v1 portfolios retain their rows on schema upgrade', () async {
    await db.close();
    db = Database(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute('''
        CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL);
        CREATE TABLE wallets (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL, name TEXT NOT NULL, color_name TEXT NOT NULL, target_percent REAL NOT NULL);
        CREATE TABLE items (id INTEGER PRIMARY KEY AUTOINCREMENT, wallet_id INTEGER NOT NULL, user_id INTEGER NOT NULL, name TEXT NOT NULL, quantity REAL NOT NULL, price REAL NOT NULL, target_percent REAL NOT NULL);
        INSERT INTO users (id, name) VALUES (12, 'Retirement');
        INSERT INTO wallets VALUES (1, 12, 'Savings', 'sky', 100);
        INSERT INTO items VALUES (1, 1, 12, 'Cash', 1, 1200, 100);
        PRAGMA user_version = 1;
      ''');
        },
      ),
    );
    final user = await db.select(db.users).getSingle();
    expect(user.id, 12);
    expect(user.name, 'Retirement');
    expect(user.currencySymbol, isNull);
    expect(user.backupId, hasLength(32));
    final item = (await db.getItemFromId(1))!;
    expect(item.isBalance, isTrue);
    expect(item.backupId, hasLength(32));
  });

  test(
    'applying buys changes quantity and leaves tiny unit prices alone',
    () async {
      final user = await db.getDefaultUser();
      final wallet = await db.createGroup(
        id: user,
        name: 'Assets',
        colorName: 'sky',
        targetPercent: 100,
      );
      final id = await db.createItem(
        walletId: wallet,
        userId: user,
        name: 'AAPL',
        value: '220',
        quantity: '8',
        target: '100',
      );
      final tiny = await db.createItem(
        walletId: wallet,
        userId: user,
        name: 'Tiny',
        value: '0.00002',
        quantity: '0',
        target: '',
      );
      final oneShare = await db.createItem(
        walletId: wallet,
        userId: user,
        name: 'One share',
        value: '220',
        target: '',
      );
      final savings = await db.createItem(
        walletId: wallet,
        userId: user,
        name: 'Savings',
        isBalance: true,
        value: '1200',
        quantity: '',
        target: '',
      );
      expect((await db.getItemFromId(savings))!.quantity, 1);
      final rows = await db.select(db.items).get();
      await db.applyTrades(rows, {
        id: 200,
        tiny: 40,
        savings: 300,
        oneShare: 110,
      });
      final updated = (await db.getItemFromId(id))!;
      expect(updated.quantity, closeTo(8 + 200 / 220, 0.0000001));
      expect(updated.price, 220);
      final shareUpdated = (await db.getItemFromId(oneShare))!;
      expect(shareUpdated.quantity, 1.5);
      expect(shareUpdated.price, 220);
      final savingsUpdated = (await db.getItemFromId(savings))!;
      expect(savingsUpdated.quantity, 1);
      expect(savingsUpdated.price, 1500);
      final tinyUpdated = (await db.getItemFromId(tiny))!;
      expect(tinyUpdated.price, 0.00002);
      expect(tinyUpdated.quantity, closeTo(2000000, 0.001));
      await expectLater(
        db.applyTrades(rows.reversed, {id: 10, tiny: 10}),
        throwsStateError,
      );
    },
  );

  test(
    'portfolio deletion can restore its original IDs and currency',
    () async {
      final user = await db.getDefaultUser();
      await db.seedSamplePortfolio(user);
      await db.setPortfolioCurrency(user, '€');
      final before = await db.exportPortfolioJson(user);
      final result = await db.deletePortfolio(user);
      expect(await db.select(db.items).get(), isEmpty);
      expect(result.nextId, isNot(user));
      await result.undo();
      expect(await db.exportPortfolioJson(user), before);
      expect(
        (await db.select(db.users).get())
            .firstWhere((u) => u.id == user)
            .currencySymbol,
        '€',
      );
    },
  );

  test(
    'backup merge is repeatable and a malformed replace leaves data intact',
    () async {
      final user = await db.getDefaultUser();
      await db.seedSamplePortfolio(user);
      await db.setPortfolioCurrency(user, '€');
      final second = await db.createUser('Second');
      await db.setPortfolioCurrency(second, '¥');
      final backup = await db.exportBackup();
      await db.importPortfolioJson(user, backup);
      await db.importPortfolioJson(user, backup);
      expect(await db.exportBackup(), backup);
      await expectLater(
        db.importPortfolioJson(
          user,
          '{"version":2,"portfolios":[null]}',
          replace: true,
        ),
        throwsFormatException,
      );
      expect(await db.exportBackup(), backup);
      final restored = await db.importPortfolioJson(
        user,
        backup,
        replace: true,
      );
      expect(restored, isNot(user));
      expect(await db.exportBackup(), backup);
    },
  );
  test('merge preserves a renamed wallet and current asset prices', () async {
    final user = await db.getDefaultUser();
    await db.seedSamplePortfolio(user);
    final backup = await db.exportBackup();
    final wallet = (await db.select(db.wallets).get()).first;
    final asset = (await db.select(db.items).get()).first;
    await db.editWallet(wallet.copyWith(name: 'Renamed'));
    await db.updatePrice(asset.id, 42);
    final preview = await db.previewBackupMerge(user, backup);
    expect(preview, (added: 0, kept: 9));
    await db.importPortfolioJson(user, backup);
    expect(await db.select(db.wallets).get(), hasLength(3));
    expect(await db.select(db.items).get(), hasLength(5));
    expect((await db.getItemFromId(asset.id))!.price, 42);
  });

  test(
    'legacy merge matches existing wallet and asset names after a price edit',
    () async {
      final user = await db.getDefaultUser();
      await db.seedSamplePortfolio(user);
      final backup = await db.exportPortfolioJson(user);
      final asset = (await db.select(db.items).get()).first;
      await db.updatePrice(asset.id, 42);
      expect(await db.previewBackupMerge(user, backup), (added: 0, kept: 8));
      await db.importPortfolioJson(user, backup);
      expect(await db.select(db.wallets).get(), hasLength(3));
      expect(await db.select(db.items).get(), hasLength(5));
      expect((await db.getItemFromId(asset.id))!.price, 42);
    },
  );
}
