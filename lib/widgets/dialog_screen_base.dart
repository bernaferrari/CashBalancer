import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../util/tailwind_colors.dart';

Color getScaffoldDialogBackgroundColor(BuildContext context, String colorName) {
  final palette = tailwindPalette(colorName);
  return Theme.of(context).brightness == Brightness.dark
      ? Color.alphaBlend(
          palette.s950.withValues(alpha: 0.55),
          TailwindColor.zinc.palette.s950,
        )
      : Color.alphaBlend(
          palette.s100.withValues(alpha: 0.65),
          TailwindColor.slate.palette.s50,
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
          palette.s900.withValues(alpha: 0.28),
          TailwindColor.zinc.palette.s900,
        )
      : Color.alphaBlend(
          palette.s50.withValues(alpha: 0.85),
          Colors.white,
        );
}

Color getInputFillColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.black.withValues(alpha: 0.04);
}

InputBorder getInputDecorationBorder(Color primaryColorWeaker) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColorWeaker.withValues(alpha: 0.55)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = tailwindPalette(colorName);
    final primaryColor = getPrimaryColor(context, colorName);

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
                width: 416,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? palette.s700.withValues(alpha: 0.45)
                          : palette.s300.withValues(alpha: 0.85),
                      width: 1.5,
                    ),
                    color: backgroundDialogColor ??
                        getBackgroundDialogColor(context, colorName),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBar(
                        foregroundColor: primaryColor,
                        title: Text(
                          appBarTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: primaryColor),
                        ),
                        centerTitle: true,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        backgroundColor: isDark
                            ? palette.s900.withValues(alpha: 0.55)
                            : palette.s100.withValues(alpha: 0.90),
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
