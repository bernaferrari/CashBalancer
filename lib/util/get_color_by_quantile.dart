import 'dart:ui';

import '../database/data.dart';
import '../database/database.dart';
import 'quartile.dart';
import 'tailwind_colors.dart';

Map<int, Color> getColorByQuantile(
  Map<int, List<Item>> itemsMap,
  Map<int, WalletData> groupMap,
  List<Item> itemsList,
) {
  final colors = <int, Color>{};

  for (final element in itemsMap.entries) {
    final List<double> arr =
        element.value.map((e) => e.quantity * e.price).toList();

    // final quartile25 = q25(arr);
    // final quartile50 = q50(arr);
    // final quartile75 = q75(arr);
    final quartile33 = q33(arr);
    final quartile66 = q66(arr);

    for (final item in itemsList) {
      final colorName = groupMap[item.walletId]!.colorName;
      if (item.price >= quartile66) {
        colors[item.id] = _getColor(colorName)[500]!;
      } else if (item.price >= quartile33) {
        colors[item.id] = _getColor(colorName)[300]!;
      }
      // else if (item.price >= quartile25) {
      //   colors[item.id] = _getColor(colorName)[300]!;
      // }
      else {
        colors[item.id] = _getColor(colorName)[200]!;
      }
    }
  }

  return colors;
}

Map<int, Color> _getColor(String colorType) {
  return tailwindColors[colorType]!;
}
