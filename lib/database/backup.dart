Map<String, Object?> decodeBackupPortfolio(Object? raw) {
  final portfolio = _object(raw);
  final currency = portfolio['currencySymbol'];
  if (currency != null && (currency is! String || currency.trim().isEmpty)) {
    throw const FormatException();
  }
  return {
    'name': _string(portfolio, 'name', allowEmpty: true),
    'currencySymbol': currency,
    'wallets': _list(portfolio, 'wallets').map((raw) {
      final wallet = _object(raw);
      return {
        'name': _string(wallet, 'name'),
        'colorName': _string(wallet, 'colorName'),
        'targetPercent': _number(wallet, 'targetPercent', min: -1, max: 100),
        'items': _list(wallet, 'items').map((raw) {
          final item = _object(raw);
          final quantity = _number(item, 'quantity', min: 0);
          final price = _number(item, 'price', min: 0);
          if (!(quantity * price).isFinite) throw const FormatException();
          return {
            'name': _string(item, 'name'),
            'quantity': quantity,
            'price': price,
            'targetPercent': _number(item, 'targetPercent', min: -1, max: 100),
          };
        }).toList(),
      };
    }).toList(),
  };
}

Map<String, dynamic> _object(Object? raw) =>
    raw is Map<String, dynamic> ? raw : throw const FormatException();
List<dynamic> _list(Map<String, dynamic> data, String key) =>
    data[key] is List<dynamic>
    ? data[key] as List<dynamic>
    : throw const FormatException();
String _string(
  Map<String, dynamic> data,
  String key, {
  bool allowEmpty = false,
}) {
  final value = data[key];
  if (value is! String || (!allowEmpty && value.trim().isEmpty)) {
    throw const FormatException();
  }
  return value;
}

double _number(
  Map<String, dynamic> data,
  String key, {
  required double min,
  double? max,
}) {
  final value = data[key];
  if (value is! num ||
      !value.isFinite ||
      value < min ||
      (max != null && value > max)) {
    throw const FormatException();
  }
  return value.toDouble();
}
