import '../database/data.dart';
import '../database/database.dart';
import 'quartile.dart';

/// How far each item fades from its wallet's color: 0 for the wallet's
/// largest third, then 1 and 2. Fading happens at render time, toward the
/// background of whichever theme is showing.
Map<int, int> getShadeByQuantile(Map<int, List<Item>> itemsMap) {
  final shades = <int, int>{};
  for (final items in itemsMap.values) {
    if (items.isEmpty) continue;
    final values = items.map((e) => e.totalValue).toList();
    final upper = q66(values);
    final lower = q33(values);
    for (final item in items) {
      shades[item.id] = item.totalValue >= upper
          ? 0
          : item.totalValue >= lower
          ? 1
          : 2;
    }
  }
  return shades;
}
