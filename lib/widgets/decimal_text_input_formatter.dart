import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n.dart';
import '../util/error_handler.dart';

/// Keeps decimal edits in the plain number format used by the controllers.
/// A grouped paste follows the locale. Ungrouped edits accept either decimal
/// separator so users can type with their keyboard's available punctuation.
class DecimalTextInputFormatter extends TextInputFormatter {
  const new({this.decimalRange = 2, this.locale = 'en', this.onInvalidPaste});

  factory localized(BuildContext context, {int decimalRange = 2}) =>
      DecimalTextInputFormatter(
        decimalRange: decimalRange,
        locale: Localizations.localeOf(context).toString(),
        onInvalidPaste: () {
          if (context.mounted) {
            showErrorSnackbar(context, context.l10n.invalidValue);
          }
        },
      );

  final int decimalRange;
  final String locale;
  final VoidCallback? onInvalidPaste;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    final selection = oldValue.selection;
    final replacedLength = selection.isValid
        ? selection.end - selection.start
        : 0;
    final insertedLength =
        newValue.text.length - oldValue.text.length + replacedLength;
    final isBulkEdit = insertedLength > 1;
    final normalized = isBulkEdit
        ? _normalizeBulkEdit(oldValue, newValue.text, insertedLength)
        : newValue.text.replaceAll(',', '.');
    final pattern = RegExp('^\\d*\\.?\\d{0,$decimalRange}\$');
    if (!pattern.hasMatch(normalized)) {
      if (isBulkEdit) onInvalidPaste?.call();
      return oldValue;
    }

    final text = normalized == '.' ? '0.' : normalized;
    if (text == newValue.text) return newValue;
    final delta = text.length - newValue.text.length;
    int adjustedOffset(int offset) => (offset + delta).clamp(0, text.length);
    return newValue.copyWith(
      text: text,
      composing: TextRange.empty,
      selection: newValue.selection.isValid
          ? newValue.selection.copyWith(
              baseOffset: adjustedOffset(newValue.selection.baseOffset),
              extentOffset: adjustedOffset(newValue.selection.extentOffset),
            )
          : newValue.selection,
    );
  }

  String _normalizeBulkEdit(
    TextEditingValue oldValue,
    String text,
    int insertedLength,
  ) {
    final selection = oldValue.selection;
    if (!selection.isValid) return _normalizePaste(text);

    final prefix = oldValue.text.substring(0, selection.start);
    final suffix = oldValue.text.substring(selection.end);
    if (!text.startsWith(prefix) || !text.endsWith(suffix)) {
      return _normalizePaste(text);
    }
    final inserted = text.substring(
      prefix.length,
      prefix.length + insertedLength,
    );
    return prefix + _normalizePaste(inserted) + suffix;
  }

  String _normalizePaste(String text) {
    final symbols = NumberFormat.decimalPattern(locale).symbols;
    final separator = symbols.GROUP_SEP;
    var input = text.trim();
    if (separator.trim().isEmpty) {
      input = input.replaceAll(RegExp(r'[ \u00A0\u202F]'), separator);
    }
    final parts = input.split(symbols.DECIMAL_SEP);
    final groups = parts.first.split(separator);
    final grouping = symbols.DECIMAL_PATTERN.split('.').first.split(',');
    if (parts.length <= 2 &&
        groups.length > 1 &&
        grouping.length > 1 &&
        _hasValidGrouping(groups, grouping)) {
      return [groups.join(), ...parts.skip(1)].join('.');
    }
    return input.replaceAll(',', '.');
  }

  bool _hasValidGrouping(List<String> groups, List<String> grouping) {
    final digits = RegExp(r'^\d+$');
    final lastSize = grouping.last.length;
    final middleSize = grouping.length > 2
        ? grouping[grouping.length - 2].length
        : lastSize;
    return groups.every(digits.hasMatch) &&
        groups.first.length <= middleSize &&
        groups.last.length == lastSize &&
        groups
            .skip(1)
            .take(groups.length - 2)
            .every((group) => group.length == middleSize);
  }
}
