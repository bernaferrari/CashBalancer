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
          groupId: item.groupId,
          userId: item.userId,
          name: item.name,
          quantity: item.quantity,
          price: item.price,
          targetPercent: item.targetPercent,
        );
}

class GroupData extends Group {
  final double totalValue;

  GroupData(
    Group group,
    this.totalValue,
  ) : super(
          id: group.id,
          userId: group.userId,
          name: group.name,
          colorName: group.colorName,
          targetPercent: group.targetPercent,
        );
}

class FullData {
  const FullData({
    required this.userId,
    required this.totalValue,
    required this.allItems,
    required this.groupedItems,
    required this.groupsMap,
    required this.settings,
  });

  final int userId;
  final double totalValue;
  final SettingsData settings;

  // List of Items
  final List<ItemData> allItems;

  // groupID -> Items
  final Map<int, List<ItemData>> groupedItems;

  // groupID -> Groups
  final Map<int, GroupData> groupsMap;
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
