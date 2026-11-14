import 'dart:ui';

import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/database/database.dart';
import 'package:cash_balancer/util/get_color_by_quantile.dart';
import 'package:cash_balancer/util/retrieve_spaced_list.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:cash_balancer/widgets/dialog_screen_base.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Database initialization and CRUD operations', () async {
    SharedPreferences.setMockInitialValues({});
    final db = Database(NativeDatabase.memory());
    addTearDown(db.close);

    // beforeOpen creates a default user on first open.
    expect((await db.userExists().getSingle()), 1);
    final userId = await db.getDefaultUser();
    expect(userId, greaterThan(0));

    // Create a wallet and items.
    await db.createGroup(
      id: userId,
      name: 'Stocks',
      colorName: 'emerald',
      targetPercent: 60,
    );
    final fullDataAfterWallet = await db.watchWallets(userId).first;
    expect(fullDataAfterWallet.walletsMap.length, 1);
    final wallet = fullDataAfterWallet.walletsMap.values.first;
    expect(wallet.name, 'Stocks');

    await db.createItem(
      walletId: wallet.id,
      userId: userId,
      name: 'AAPL',
      value: '1500',
      target: '50',
    );
    final fullDataAfterItem = await db.watchWallets(userId).first;
    expect(fullDataAfterItem.allItems.length, 1);
    expect(fullDataAfterItem.allItems.first.name, 'AAPL');
    expect(fullDataAfterItem.allItems.first.price, 1500);

    await db.deleteWallet(wallet.id);
    await db.delete(db.users).go();

    expect(await db.select(db.users).getSingleOrNull(), null);
    expect(await db.select(db.wallets).getSingleOrNull(), null);
    expect(await db.select(db.items).getSingleOrNull(), null);
    expect((await db.userExists().getSingle()), 0);

    // getDefaultUser safely recreates a user if none exists.
    final recreatedUserId = await db.getDefaultUser();
    expect(recreatedUserId, greaterThan(0));
  });

  test('getColorByQuantile assigns colors per wallet without overwriting', () {
    const w1 = Wallet(
      id: 1,
      name: 'Stocks',
      colorName: 'emerald',
      targetPercent: -1,
      userId: 1,
    );
    const w2 = Wallet(
      id: 2,
      name: 'Crypto',
      colorName: 'amber',
      targetPercent: -1,
      userId: 1,
    );
    final groupMap = <int, WalletData>{
      1: WalletData(w1, 400),
      2: WalletData(w2, 50),
    };
    const item1 = Item(
      id: 1,
      name: 'AAPL',
      quantity: 1,
      price: 100,
      targetPercent: -1,
      walletId: 1,
      userId: 1,
    );
    const item2 = Item(
      id: 2,
      name: 'MSFT',
      quantity: 1,
      price: 300,
      targetPercent: -1,
      walletId: 1,
      userId: 1,
    );
    const item3 = Item(
      id: 3,
      name: 'BTC',
      quantity: 1,
      price: 50,
      targetPercent: -1,
      walletId: 2,
      userId: 1,
    );
    final itemsMap = <int, List<Item>>{
      1: [item1, item2],
      2: [item3],
    };

    final colors = getColorByQuantile(itemsMap, groupMap);
    expect(colors.keys, containsAll([1, 2, 3]));
    expect(colors[1]?.colorSpace, ColorSpace.displayP3);
    expect(colors[2]?.colorSpace, ColorSpace.displayP3);
    expect(colors[3]?.colorSpace, ColorSpace.displayP3);
    // Wallet 1 items and Wallet 2 items use their respective wallet colors.
    expect(colors[1], isNot(equals(colors[3])));

    // Tailwind v3/v4 color names resolve via asNameMap.
    expect(TailwindColor.fromName('sky'), TailwindColor.sky);
    expect(TailwindColor.fromName('stone'), TailwindColor.stone);
    expect(TailwindColor.fromName('slate'), TailwindColor.slate);
  });

  test('retrieveSpacedList handles empty, zero-total, and normal lists', () {
    expect(retrieveSpacedList([], 200), isEmpty);

    const zeroItem = Item(
      id: 1,
      name: 'Zero',
      quantity: 1,
      price: 0,
      targetPercent: -1,
      walletId: 1,
      userId: 1,
    );
    final zeroResult = retrieveSpacedList([zeroItem], 200);
    expect(zeroResult, [0.0]);

    const i1 = Item(
      id: 1,
      name: 'I1',
      quantity: 1,
      price: 50,
      targetPercent: -1,
      walletId: 1,
      userId: 1,
    );
    const i2 = Item(
      id: 2,
      name: 'I2',
      quantity: 1,
      price: 50,
      targetPercent: -1,
      walletId: 1,
      userId: 1,
    );
    final spaced = retrieveSpacedList([i1, i2], 200);
    expect(spaced, [99.0, 99.0]);
  });

  test('DecimalTextInputFormatter supports dot and comma cents', () {
    const formatter = DecimalTextInputFormatter();
    const empty = TextEditingValue.empty;

    expect(
      formatter
          .formatEditUpdate(empty, const TextEditingValue(text: '1234.56'))
          .text,
      '1234.56',
    );
    expect(
      formatter
          .formatEditUpdate(empty, const TextEditingValue(text: '1234,56'))
          .text,
      '1234.56',
    );
    expect(
      formatter
          .formatEditUpdate(
            const TextEditingValue(text: '12.34'),
            const TextEditingValue(text: '12.345'),
          )
          .text,
      '12.34',
    );
  });

  test('Buy-only rebalancing calculates required total without selling', () {
    const w1 = Wallet(
      id: 1,
      userId: 1,
      name: 'Stocks',
      colorName: 'emerald',
      targetPercent: 60,
    );
    const w2 = Wallet(
      id: 2,
      userId: 1,
      name: 'Crypto',
      colorName: 'amber',
      targetPercent: 40,
    );
    final data = FullData(
      userId: 1,
      totalValue: 1000,
      allItems: [
        ItemData(
          item: const Item(
            id: 1,
            walletId: 1,
            userId: 1,
            name: 'BOVA11',
            quantity: 1,
            price: 400,
            targetPercent: 60,
          ),
          colorName: 'emerald',
          color: const Color(0xFF10B981),
        ),
        ItemData(
          item: const Item(
            id: 2,
            walletId: 2,
            userId: 1,
            name: 'BTC',
            quantity: 1,
            price: 600,
            targetPercent: 40,
          ),
          colorName: 'amber',
          color: const Color(0xFFF59E0B),
        ),
      ],
      walletsItems: const {},
      walletsMap: {1: WalletData(w1, 400), 2: WalletData(w2, 600)},
      settings: const SettingsData(
        relativeTarget: false,
        buyOnly: true,
        currencySymbol: '\$',
        sortBy: 0,
      ),
    );

    // BTC is $600 with a 40% target, so total portfolio must reach $1500
    // ($600 / 0.40) to avoid selling BTC, requiring $500 of BOVA11 ($900 total).
    expect(data.buyOnlyTotalForWallets, closeTo(1500, 0.01));
    expect(data.buyOnlyTotalForItems(), closeTo(1500, 0.01));
  });

  test(
    'Sample portfolio seeding, quantity × price, and JSON export/import',
    () async {
      SharedPreferences.setMockInitialValues({});
      final db = Database(NativeDatabase.memory());
      addTearDown(db.close);

      final userId = await db.getDefaultUser();
      await db.seedSamplePortfolio(userId);

      final seeded = await db.watchWallets(userId).first;
      expect(seeded.walletsMap.length, 3);
      expect(seeded.allItems.length, 5);
      expect(seeded.totalValue, closeTo(10460, 0.01));

      // Export and import into a second portfolio.
      final exportedJson = await db.exportPortfolioJson(userId);
      final secondUserId = await db.createUser('Imported');
      await db.importPortfolioJson(secondUserId, exportedJson);

      final imported = await db.watchWallets(secondUserId).first;
      expect(imported.walletsMap.length, 3);
      expect(imported.allItems.length, 5);
      expect(imported.totalValue, closeTo(10460, 0.01));
    },
  );
}
