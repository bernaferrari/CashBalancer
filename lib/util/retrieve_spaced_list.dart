import '../database/database.dart';

List<double> retrieveSpacedList(List<FullData> data, double maxSize) {
  // data.length == 2 => 2
  // data.length == 3 => 4
  // therefore, (data.length - 1) * 2
  final double maxWH = maxSize - (data.length - 1) * 2;

  final double totalValue = data
      .map((d) => d.item.price * d.item.quantity)
      .fold(0.0, (previous, current) => previous + current);

  return data
      .map((d) => maxWH * (d.item.price * d.item.quantity) / totalValue)
      .toList();
}
