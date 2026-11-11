import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/tailwind_colors.dart';

Color getScaffoldDialogBackgroundColor(BuildContext context, String colorName) {
  final palette = tailwindPalette(colorName);
  return Theme.of(context).brightness == Brightness.dark
      ? Color.alphaBlend(
          Colors.black.withValues(alpha: 0.40),
          palette.s900,
        )
      : Color.alphaBlend(
          Colors.white.withValues(alpha: 0.40),
          palette.s100,
        );
}

Color getPrimaryColor(BuildContext context, String colorName) {
  final palette = tailwindPalette(colorName);
  return Theme.of(context).brightness == Brightness.dark
      ? palette.s200
      : palette.s800;
}

Color getPrimaryColorWeaker(BuildContext context, String colorName) {
  final palette = tailwindPalette(colorName);
  return Theme.of(context).brightness == Brightness.dark
      ? palette.s300
      : palette.s700;
}

Color getBackgroundDialogColor(BuildContext context, String colorName) {
  final palette = tailwindPalette(colorName);
  return Theme.of(context).brightness == Brightness.dark
      ? Color.alphaBlend(
          Colors.black.withValues(alpha: 0.25),
          palette.s950,
        )
      : palette.s100;
}

Color getInputFillColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.black.withValues(alpha: 0.04);
}

InputBorder getInputDecorationBorder(Color primaryColorWeaker) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColorWeaker),
    );

/// Accepts digits and a single decimal separator (`.` or `,`), normalizing `,`
/// to `.` and allowing up to [decimalRange] fractional digits.
class const DecimalTextInputFormatter({final int decimalRange = 2})
    extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalized = newValue.text.replaceAll(',', '.');
    if (normalized.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final pattern = RegExp('^\\d*\\.?\\d{0,$decimalRange}\$');
    if (!pattern.hasMatch(normalized)) {
      return oldValue;
    }
    final text = normalized == '.' ? '0.' : normalized;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: newValue.selection.end.clamp(0, text.length),
      ),
    );
  }
}

class const DialogScreenBase({
  super.key,
  required final List<Widget> children,
  required final String colorName,
  required final String appBarTitle,
  final Color? backgroundDialogColor,
  final List<Widget>? appBarActions,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getScaffoldDialogBackgroundColor(context, colorName),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.escape): PopIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              PopIntent: CallbackAction<PopIntent>(
                onInvoke: (_) => Navigator.of(context).pop(),
              ),
            },
            child: Center(
              child: SizedBox(
                width: 400,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: backgroundDialogColor ??
                        getBackgroundDialogColor(context, colorName),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBar(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        title: Text(appBarTitle),
                        centerTitle: true,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? tailwindPalette(colorName).s900
                                : tailwindPalette(colorName).s200,
                        actions: appBarActions,
                      ),
                      Flexible(
                        child: ListView(
                          padding: const EdgeInsets.all(24),
                          shrinkWrap: true,
                          children: children,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const PopIntent() extends Intent;
