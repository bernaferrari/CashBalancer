import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatMoney(double value, String locale, String symbol) {
  final sanitized = value.abs() < 0.005 ? 0.0 : value;
  final formatter = NumberFormat.currency(
    locale: locale,
    symbol: symbol,
    decimalDigits: 2,
  );
  // intl internally converts doubles to integers. Format the digits directly
  // once the value exceeds the exact integer range shared by native and web.
  if (sanitized.isFinite && sanitized.abs() >= 1e15) {
    return _largeNumber(formatter, sanitized, fractionDigits: 2);
  }
  return formatter.format(sanitized);
}

String money(BuildContext context, String currency, double value) =>
    formatMoney(value, Localizations.localeOf(context).toString(), currency);

String formatPercent(double value, [String? locale]) =>
    NumberFormat('0.#', locale).format(value.isFinite ? value : 0);

extension Percent on double {
  String toPercent([String? locale]) => formatPercent(this * 100, locale);
}

String formatQuantity(BuildContext context, double value) {
  final locale = Localizations.localeOf(context).toString();
  final formatter = NumberFormat.decimalPatternDigits(
    locale: locale,
    decimalDigits: 12,
  )..minimumFractionDigits = 0;
  if (value.isFinite && value.abs() >= 1e15) {
    return _largeNumber(formatter, value);
  }
  return value != 0 && value.abs() < 1e-12
      ? NumberFormat('0.#####E0', locale).format(value)
      : formatter.format(value);
}

String _largeNumber(
  NumberFormat formatter,
  double value, {
  int fractionDigits = 0,
}) {
  final symbols = formatter.symbols;
  final zero = symbols.ZERO_DIGIT.codeUnitAt(0);
  final probe = formatter.format(123456789);
  final probeNumber = probe
      .substring(
        formatter.positivePrefix.length,
        probe.length - formatter.positiveSuffix.length,
      )
      .split(symbols.DECIMAL_SEP)
      .first;
  final groups = probeNumber.split(symbols.GROUP_SEP);
  final digits = editableNumber(value.abs()).split('.').first;
  final chunks = <String>[];
  if (groups.length < 2) {
    chunks.add(digits);
  } else {
    var end = digits.length;
    var width = groups.last.length;
    while (end > 0) {
      final start = (end - width).clamp(0, end);
      chunks.add(digits.substring(start, end));
      end = start;
      if (groups.length > 2) width = groups[groups.length - 2].length;
    }
  }
  final integer = chunks.reversed
      .map(
        (part) => String.fromCharCodes(
          part.codeUnits.map((digit) => digit - 48 + zero),
        ),
      )
      .join(symbols.GROUP_SEP);
  final fraction = fractionDigits == 0
      ? ''
      : symbols.DECIMAL_SEP + symbols.ZERO_DIGIT * fractionDigits;
  return value.isNegative
      ? '${formatter.negativePrefix}$integer$fraction${formatter.negativeSuffix}'
      : '${formatter.positivePrefix}$integer$fraction${formatter.positiveSuffix}';
}

/// Round-trip a stored number in a decimal-only editor.
String editableNumber(double? value) {
  if (value == null || value < 0 || !value.isFinite) return '';
  final parts = value.toString().split('e');
  final mantissa = parts.first;
  if (parts.length == 1) return mantissa.replaceFirst(RegExp(r'\.0$'), '');
  final digits = mantissa.replaceAll('.', '');
  final dot =
      (mantissa.contains('.') ? mantissa.indexOf('.') : mantissa.length) +
      int.parse(parts.last);
  if (dot <= 0) return '0.${'0' * -dot}$digits';
  if (dot >= digits.length) return '$digits${'0' * (dot - digits.length)}';
  return '${digits.substring(0, dot)}.${digits.substring(dot)}';
}
