import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/tailwind_colors.dart';

Color getScaffoldDialogBackgroundColor(BuildContext context, String colorName) {
  return Theme.of(context).brightness == Brightness.dark
      ? Color.alphaBlend(
          Colors.black.withOpacity(0.40),
          tailwindColors[colorName]![900]!,
        )
      : Color.alphaBlend(
          Colors.white.withOpacity(0.40),
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
          Colors.black.withOpacity(0.60),
          tailwindColors[colorName]![900]!,
        )
      : tailwindColors[colorName]![100]!;
}

InputBorder getInputDecorationBorder(Color primaryColorWeaker) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColorWeaker),
    );

class DialogScreenBase extends StatelessWidget {
  final String colorName;
  final List<Widget> children;
  final String appBarTitle;
  final List<Widget>? appBarActions;
  final Color? backgroundDialogColor;

  const DialogScreenBase({
    Key? key,
    required this.children,
    required this.colorName,
    required this.appBarTitle,
    this.backgroundDialogColor,
    this.appBarActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getScaffoldDialogBackgroundColor(context, colorName),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.escape): const PopIntent(),
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
                        (Theme.of(context).brightness == Brightness.dark
                            ? Color.alphaBlend(
                                Colors.black.withOpacity(0.60),
                                tailwindColors[colorName]![900]!,
                              )
                            : tailwindColors[colorName]![100]!),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBar(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        backwardsCompatibility: false,
                        title: Text(appBarTitle),
                        elevation: 0,
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

class PopIntent extends Intent {
  const PopIntent();
}
