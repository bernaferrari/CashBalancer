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
    final wallet = groupMap[element.key];
    if (wallet == null || element.value.isEmpty) continue;

    final List<double> arr =
        element.value.map((e) => e.quantity * e.price).toList();

    final quartile33 = q33(arr);
    final quartile66 = q66(arr);
    final palette = _getColor(wallet.colorName);

    for (final item in element.value) {
      final itemValue = item.quantity * item.price;
      if (itemValue >= quartile66) {
        colors[item.id] = palette[500]!;
      } else if (itemValue >= quartile33) {
        colors[item.id] = palette[300]!;
      } else {
        colors[item.id] = palette[200]!;
      }
    }
  }

  return colors;
}

Map<int, Color> _getColor(String colorType) {
  return tailwindColors[colorType] ?? tailwindColors['gray']!;
}
