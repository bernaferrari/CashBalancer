import 'dart:ui';

import '../database/database.dart';
import 'quartile.dart';
import 'tailwind_colors.dart';

Map<Item, Color> getColorByQuantile(
  Map<int, List<Item>> itemsMap,
  Map<int, Group> groupMap,
  List<Item> data,
) {
  final colors = <Item, Color>{};

  for (final element in itemsMap.entries) {
    final List<double> arr =
        element.value.map((e) => e.quantity * e.price).toList();

    final quartile25 = q25(arr);
    final quartile50 = q50(arr);
    final quartile75 = q75(arr);

    for (final currentData in data) {
      final colorType = groupMap[currentData.groupId]!.color;
      if (currentData.price <= quartile25) {
        colors[currentData] = _getColor(colorType)[200]!;
      } else if (currentData.price <= quartile50) {
        colors[currentData] = _getColor(colorType)[300]!;
      } else if (currentData.price <= quartile75) {
        colors[currentData] = _getColor(colorType)[400]!;
      } else {
        colors[currentData] = _getColor(colorType)[500]!;
      }
    }
  }

  return colors;
}

Map<int, Color> _getColor(String colorType) {
  return tailwindColors[colorType]!;
}
