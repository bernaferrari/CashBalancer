import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../app/theme.dart';

/// A form screen: full-bleed on phones, a floating card on wider windows.
/// [bottom] stays pinned under the scrolling [children]. A [colorName] tints
/// the screen with that wallet's scheme; without one it stays neutral.
class const DialogScreenBase({
  super.key,
  required final List<Widget> children,
  final String? colorName,
  required final String appBarTitle,
  final List<Widget>? appBarActions,
  final List<Widget> bottom = const [],
}) extends StatelessWidget {
  static const double _wideBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;
    final theme = buildTheme(
      Theme.of(context).brightness,
      colorName: colorName,
    );
    final ledger = theme.extension<Ledger>()!;
    final surface = ledger.canvas;
    final backdrop = theme.colorScheme.surfaceContainer;

    final content = Column(
      mainAxisSize: wide ? MainAxisSize.min : MainAxisSize.max,
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          primary: !wide,
          title: Text(appBarTitle),
          actions: [...?appBarActions, const SizedBox(width: 4)],
        ),
        Flexible(
          fit: wide ? FlexFit.loose : FlexFit.tight,
          child: Material(
            type: MaterialType.transparency,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              shrinkWrap: wide,
              children: children,
            ),
          ),
        ),
        if (bottom.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, wide ? 20 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: bottom,
            ),
          ),
      ],
    );

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      data: theme,
      child: Scaffold(
        backgroundColor: wide ? backdrop : surface,
        body: SafeArea(
          top: !wide,
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
              child: !wide
                  ? content
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Container(
                          width: 460,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 48,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: content,
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
