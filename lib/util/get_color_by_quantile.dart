import 'dart:ui';

import '../database/data.dart';
import '../database/database.dart';
import 'quartile.dart';
import 'wallet_colors.dart';

Map<int, Color> getColorByQuantile(
  Map<int, List<Item>> itemsMap,
  Map<int, WalletData> groupMap,
) {
  final colors = <int, Color>{};

  for (final element in itemsMap.entries) {
    final wallet = groupMap[element.key];
    if (wallet == null || element.value.isEmpty) continue;

    final List<double> arr = element.value.map((e) => e.totalValue).toList();

    final quartile33 = q33(arr);
    final quartile66 = q66(arr);
    final color = WalletColor.fromName(wallet.colorName);

    for (final item in element.value) {
      final itemValue = item.totalValue;
      if (itemValue >= quartile66) {
        colors[item.id] = color.shade(-10);
      } else if (itemValue >= quartile33) {
        colors[item.id] = color.seed;
      } else {
        colors[item.id] = color.shade(12);
      }
    }
  }

  return colors;
}
