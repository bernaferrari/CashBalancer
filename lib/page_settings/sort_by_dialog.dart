import 'package:cash_balancer/l10n/l10n.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class const SortByDialog({super.key, required final int initialValue})
    extends StatefulWidget {
  @override
  State<SortByDialog> createState() => _SortByDialogState();
}

class _SortByDialogState extends State<SortByDialog> {
  late int selectedSortId = widget.initialValue;
  static const sortByValues = [0, 1];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = TailwindColor.green.palette;
    final primaryColor = isDark ? palette.s300 : palette.s800;
    final backgroundDialogColor = Theme.of(context).colorScheme.surface;

    return AlertDialog(
      title: Text(context.l10n.sortBy),
      backgroundColor: backgroundDialogColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 16,
            children: [
              for (final sortId in sortByValues)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: selectedSortId == sortId
                          ? (isDark ? palette.s800 : palette.s200)
                          : null,
                      side: BorderSide(
                        color: isDark ? palette.s700 : palette.s200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      getSortByString(context, sortId),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedSortId = sortId;
                      });
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: backgroundDialogColor,
                backgroundColor: primaryColor,
              ),
              label: Text(context.l10n.dialogSave),
              icon: const Icon(Icons.check_rounded),
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit() async {
    await RxSharedPreferences.getInstance().setInt('sortBy', selectedSortId);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

String getSortByString(BuildContext context, int value) => switch (value) {
      0 => context.l10n.sortBy0,
      1 => context.l10n.sortBy1,
      _ => '',
    };
