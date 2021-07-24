import 'dart:ui';

import 'database.dart';

class ItemData extends Item {
  final String colorName;
  final Color color;

  ItemData({
    required Item item,
    required this.colorName,
    required this.color,
  }) : super(
          id: item.id,
          walletId: item.walletId,
          userId: item.userId,
          name: item.name,
          quantity: item.quantity,
          price: item.price,
          targetPercent: item.targetPercent,
        );
}

class WalletData extends Wallet {
  final double totalValue;

  WalletData(
    Wallet wallet,
    this.totalValue,
  ) : super(
          id: wallet.id,
          userId: wallet.userId,
          name: wallet.name,
          colorName: wallet.colorName,
          targetPercent: wallet.targetPercent,
        );
}

class FullData {
  const FullData({
    required this.userId,
    required this.totalValue,
    required this.allItems,
    required this.walletsItems,
    required this.walletsMap,
    required this.settings,
  });

  final int userId;
  final double totalValue;
  final SettingsData settings;

  // List of Items
  final List<ItemData> allItems;

  // walletID -> Items
  final Map<int, List<ItemData>> walletsItems;

  // walletID -> Groups
  final Map<int, WalletData> walletsMap;
}

class SettingsData {
  const SettingsData({
    required this.relativeTarget,
    required this.currencySymbol,
    required this.sortBy,
  });

  final bool relativeTarget;
  final String currencySymbol;
  final int sortBy;
}
