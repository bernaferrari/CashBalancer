import '../database/database.dart';

List<double> retrieveSpacedList(List<Item> data, double maxSize) {
  // data.length == 2 => 2
  // data.length == 3 => 4
  // therefore, (data.length - 1) * 2
  final double maxWH = maxSize - (data.length - 1) * 2;

  final double totalValue = data
      .map((d) => d.price * d.quantity)
      .fold(0.0, (previous, current) => previous + current);

  return data
      .map((d) => maxWH * (d.price * d.quantity) / totalValue)
      .toList();
}
