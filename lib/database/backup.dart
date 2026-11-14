import 'dart:convert';
import 'dart:math';

typedef Backup = ({bool singlePortfolio, List<BackupPortfolio> portfolios});
typedef BackupPortfolio = ({
  String? id,
  String name,
  String? currency,
  List<BackupWallet> wallets,
});
typedef BackupWallet = ({
  String? id,
  String name,
  String colorName,
  double target,
  List<BackupItem> items,
});
typedef BackupItem = ({
  String? id,
  String name,
  double quantity,
  double price,
  double target,
  bool isBalance,
});

String newBackupId() {
  final random = Random.secure();
  return List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}

Backup decodeBackup(String json) {
  final root = _object(jsonDecode(json));
  final version = root['version'];
  final rawPortfolios = switch (version) {
    1 => [
      {'name': '', 'wallets': root['wallets']},
    ],
    2 || 3 => _list(root, 'portfolios'),
    _ => throw const FormatException(),
  };
  if (rawPortfolios.isEmpty) throw const FormatException();
  final ids = <String>{};
  String? id(Map<String, dynamic> row) {
    if (version != 3) return null;
    final value = _string(row, 'id');
    if (!RegExp(r'^[0-9a-f]{32}$').hasMatch(value) || !ids.add(value)) {
      throw const FormatException();
    }
    return value;
  }

  final portfolios = rawPortfolios.map((raw) {
    final portfolio = _object(raw);
    final currency = portfolio['currencySymbol'];
    if (currency != null && (currency is! String || currency.trim().isEmpty)) {
      throw const FormatException();
    }
    return (
      id: id(portfolio),
      name: _string(portfolio, 'name', allowEmpty: true),
      currency: currency as String?,
      wallets: _list(portfolio, 'wallets').map((raw) {
        final wallet = _object(raw);
        return (
          id: id(wallet),
          name: _string(wallet, 'name'),
          colorName: _string(wallet, 'colorName'),
          target: _target(wallet),
          items: _list(wallet, 'items').map((raw) {
            final item = _object(raw);
            final quantity = _number(item, 'quantity', min: 0);
            final price = _number(item, 'price', min: 0);
            final type = item['isBalance'];
            if (!(quantity * price).isFinite ||
                (type != null && type is! bool) ||
                (version == 3 && type == null) ||
                (type == true && quantity != 1)) {
              throw const FormatException();
            }
            return (
              id: id(item),
              name: _string(item, 'name'),
              quantity: quantity,
              price: price,
              target: _target(item),
              isBalance: (type as bool?) ?? quantity == 1,
            );
          }).toList(),
        );
      }).toList(),
    );
  }).toList();
  return (singlePortfolio: version == 1, portfolios: portfolios);
}

/// Older backups identify rows by name within their parent. Match each local
/// row once so repeated names in a backup retain their original multiplicity.
T? matchBackupRow<T>(
  Iterable<T> rows,
  Set<int> used,
  String? id,
  String name,
  (int, String?, String) Function(T) identity,
) {
  for (final row in rows) {
    final (localId, backupId, localName) = identity(row);
    if (!used.contains(localId) &&
        (id == null ? localName == name : backupId == id)) {
      used.add(localId);
      return row;
    }
  }
  return null;
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

double _target(Map<String, dynamic> data) =>
    _number(data, 'targetPercent', min: -1, max: 100);

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
