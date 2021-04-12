import 'dart:ui';

import '../database/database.dart';
import 'quartile.dart';
import 'tailwind_colors.dart';

Map<FullData, Color> getColorByQuantile(
  Map<int, List<FullData>> groupedData,
  List<FullData> data,
) {
  final colors = <FullData, Color>{};

  for (final element in groupedData.entries) {
    final List<double> arr =
        element.value.map((e) => e.item.quantity * e.item.price).toList();

    final quartile25 = q25(arr);
    final quartile50 = q50(arr);
    final quartile75 = q75(arr);

    for (final currentData in data) {
      final colorType = currentData.kind.color;
      if (currentData.item.price <= quartile25) {
        colors[currentData] = _getColor(colorType)[200]!;
      } else if (currentData.item.price <= quartile50) {
        colors[currentData] = _getColor(colorType)[300]!;
      } else if (currentData.item.price <= quartile75) {
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
