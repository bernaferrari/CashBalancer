import 'dart:math' as math;
import 'dart:ui';

import 'database.dart';

class ItemData({
  required Item item,
  required final String colorName,
  required final Color color,
}) extends Item {
  this
      : super(
          id: item.id,
          walletId: item.walletId,
          userId: item.userId,
          name: item.name,
          quantity: item.quantity,
          price: item.price,
          targetPercent: item.targetPercent,
        );
}

class WalletData(
  Wallet wallet,
  final double totalValue,
) extends Wallet {
  this
      : super(
          id: wallet.id,
          userId: wallet.userId,
          name: wallet.name,
          colorName: wallet.colorName,
          targetPercent: wallet.targetPercent,
        );
}

class const FullData({
  required final int userId,
  final String userName = 'Wallet #1',
  final List<User> portfolios = const [],
  required final double totalValue,
  required final List<ItemData> allItems,
  required final Map<int, List<ItemData>> walletsItems,
  required final Map<int, WalletData> walletsMap,
  required final SettingsData settings,
}) {
  /// Minimum portfolio total required to reach wallet targets without selling.
  double get buyOnlyTotalForWallets {
    double requiredTotal = totalValue;
    for (final wallet in walletsMap.values) {
      if (wallet.targetPercent > 0) {
        requiredTotal = math.max(
          requiredTotal,
          wallet.totalValue / (wallet.targetPercent / 100),
        );
      }
    }
    return requiredTotal;
  }

  /// Minimum total required to reach item targets without selling.
  double buyOnlyTotalForItems([int? walletId]) {
    if (settings.relativeTarget && walletId != null) {
      final baseTotal = walletsMap[walletId]?.totalValue ?? 0;
      final items = walletsItems[walletId] ?? const [];
      double requiredTotal = baseTotal;
      for (final item in items) {
        if (item.targetPercent > 0) {
          requiredTotal = math.max(
            requiredTotal,
            item.price / (item.targetPercent / 100),
          );
        }
      }
      return requiredTotal;
    }

    double requiredTotal = totalValue;
    for (final item in allItems) {
      if (item.targetPercent > 0) {
        requiredTotal = math.max(
          requiredTotal,
          item.price / (item.targetPercent / 100),
        );
      }
    }
    return requiredTotal;
  }
}

class const SettingsData({
  required final bool relativeTarget,
  final bool buyOnly = false,
  required final String currencySymbol,
  required final int sortBy,
  final int themeMode = 0,
});
