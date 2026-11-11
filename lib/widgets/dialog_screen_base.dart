import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/tailwind_colors.dart';

Color getScaffoldDialogBackgroundColor(BuildContext context, String colorName) {
  return Theme.of(context).brightness == Brightness.dark
      ? Color.alphaBlend(
          Colors.black.withValues(alpha: 0.40),
          tailwindColors[colorName]![900]!,
        )
      : Color.alphaBlend(
          Colors.white.withValues(alpha: 0.40),
          tailwindColors[colorName]![100]!,
        );
}

Color getPrimaryColor(BuildContext context, String colorName) {
  return Theme.of(context).brightness == Brightness.dark
      ? tailwindColors[colorName]![200]!
      : tailwindColors[colorName]![800]!;
}

Color getPrimaryColorWeaker(BuildContext context, String colorName) {
  return Theme.of(context).brightness == Brightness.dark
      ? tailwindColors[colorName]![300]!
      : tailwindColors[colorName]![700]!;
}

Color getBackgroundDialogColor(BuildContext context, String colorName) {
  return Theme.of(context).brightness == Brightness.dark
      ? Color.alphaBlend(
          Colors.black.withValues(alpha: 0.60),
          tailwindColors[colorName]![900]!,
        )
      : tailwindColors[colorName]![100]!;
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
                                ? tailwindColors[colorName]![900]!
                                : tailwindColors[colorName]![200],
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
