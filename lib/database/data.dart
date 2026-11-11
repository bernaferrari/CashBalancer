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
  required final double totalValue,
  required final List<ItemData> allItems,
  required final Map<int, List<ItemData>> walletsItems,
  required final Map<int, WalletData> walletsMap,
  required final SettingsData settings,
});

class const SettingsData({
  required final bool relativeTarget,
  required final String currencySymbol,
  required final int sortBy,
  final int themeMode = 0,
});
