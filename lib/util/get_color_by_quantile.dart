import 'dart:ui';

import '../database/database.dart';
import 'quartile.dart';
import 'tailwind_colors.dart';

Map<Item, Color> getColorByQuantile(
  Map<int, List<Item>> itemsMap,
  Map<int, Group> groupMap,
  List<Item> itemsList,
) {
  final colors = <Item, Color>{};

  for (final element in itemsMap.entries) {
    final List<double> arr =
        element.value.map((e) => e.quantity * e.price).toList();

    final quartile25 = q25(arr);
    final quartile50 = q50(arr);
    final quartile75 = q75(arr);

    for (final item in itemsList) {
      final colorName = groupMap[item.groupId]!.color;
      if (item.price <= quartile25) {
        colors[item] = _getColor(colorName)[200]!;
      } else if (item.price <= quartile50) {
        colors[item] = _getColor(colorName)[300]!;
      } else if (item.price <= quartile75) {
        colors[item] = _getColor(colorName)[400]!;
      } else {
        colors[item] = _getColor(colorName)[500]!;
      }
    }
  }

  return colors;
}

Map<int, Color> _getColor(String colorType) {
  return tailwindColors[colorType]!;
}
