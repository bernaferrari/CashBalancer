import 'dart:math' as math;

import '../database/data.dart';
import '../database/database.dart';

List<double> retrieveSpacedList(List<Item> data, double maxSize) {
  if (data.isEmpty || maxSize <= 0 || !maxSize.isFinite) {
    return List.filled(data.length, 0.0);
  }

  // data.length == 2 => 2
  // data.length == 3 => 4
  // therefore, (data.length - 1) * 2
  final double maxWH = math.max(0.0, maxSize - (data.length - 1) * 2);

  final double totalValue = data
      .map((d) => d.totalValue)
      .fold(0.0, (previous, current) => previous + current.abs());

  if (totalValue <= 0) {
    return List.filled(data.length, 0.0);
  }

  return data
      .map((d) => math.max(0.0, maxWH * (d.totalValue.abs() / totalValue)))
      .toList();
}
