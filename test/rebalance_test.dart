import 'package:cash_balancer/page_rebalance/rebalance_plan.dart';
import 'package:cash_balancer/util/numbers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('relative targets spend the deposit once, according to wallet gaps', () {
    final wallets = {
      1: (
        value: 500.0,
        weight: 25.0,
        holdings: [(id: 11, value: 500.0, target: 100.0)],
      ),
      2: (
        value: 500.0,
        weight: 75.0,
        holdings: [(id: 22, value: 500.0, target: 100.0)],
      ),
    };
    for (final buyOnly in [false, true]) {
      expect(allocateRelative(wallets, cash: 1000, buyOnly: buyOnly), {
        11: 0,
        22: 1000,
      });
    }
    expect(allocateRelative(wallets, cash: 0, buyOnly: false), {
      11: -250,
      22: 250,
    });
  });

  test('relative targets keep a wallet without asset targets in the portfolio base', () {
    final wallets = {
      1: (value: 500.0, weight: 25.0, holdings: <Holding>[]),
      2: (
        value: 500.0,
        weight: 75.0,
        holdings: [(id: 22, value: 500.0, target: 100.0)],
      ),
    };
    expect(allocateRelative(wallets, cash: 1000, buyOnly: true), {22: 1000});
    expect(allocateRelative(wallets, cash: 0, buyOnly: false), {22: 250});
  });

  test('buy-only caps each gap and leaves excess cash alone', () {
    const holdings = [(id: 1, value: 50.0, target: 10.0)];
    expect(allocate(holdings, total: 1000, cash: 500, buyOnly: true), {1: 100});
    expect(allocate(holdings, total: 1000, cash: 50, buyOnly: true), {1: 50});
    expect(allocate(holdings, total: 1000, cash: 0, buyOnly: true), {1: 0});
  });

  test('zero targets sell in sell mode, while unset targets are skipped', () {
    const holdings = [
      (id: 1, value: 100.0, target: 0.0),
      (id: 2, value: 100.0, target: -1.0),
    ];
    expect(allocate(holdings, total: 200, cash: 0, buyOnly: false), {1: -100});
    expect(allocate(holdings, total: 200, cash: 0, buyOnly: true), {1: 0});
    expect(minimumBuyOnlyCash(holdings, 200), isNull);
  });

  test('currency format handles scientific notation and locale separators', () {
    expect(formatMoney(1e-7, 'en', r'$'), r'$0.00');
    expect(formatMoney(-1e-7, 'en', r'$'), r'$0.00');
    expect(formatMoney(1e21, 'en', r'$'), r'$1,000,000,000,000,000,000,000.00');
    expect(formatMoney(1234.5, 'de', '€'), '1.234,50\u00a0€');
    expect(editableNumber(0.00002), '0.00002');
    expect(double.parse(editableNumber(5e-324)), 5e-324);
  });
}
