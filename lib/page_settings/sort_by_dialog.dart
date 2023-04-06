import 'package:cash_balancer/l10n/l10n.dart';
import 'package:cash_balancer/util/row_column_spacer.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class SortByDialog extends StatefulWidget {
  final int initialValue;

  const SortByDialog({Key? key, required this.initialValue}) : super(key: key);

  @override
  State<SortByDialog> createState() => _SortByDialogState();
}

class _SortByDialogState extends State<SortByDialog> {
  final String colorName = 'green';
  late int selectedSortId = widget.initialValue;
  static const sortByValues = [0, 1];

  @override
  Widget build(BuildContext context) {
    final primaryColor = (Theme.of(context).brightness == Brightness.dark)
        ? tailwindColors[colorName]![300]!
        : tailwindColors[colorName]![800]!;
    final backgroundDialogColor = Theme.of(context).colorScheme.background;

    return AlertDialog(
      title: Text(AppLocalizations.of(context).sortBy),
      backgroundColor: backgroundDialogColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: spaceRow(
              16,
              [
                for (final sortId in sortByValues)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selectedSortId == sortId
                            ? Theme.of(context).brightness == Brightness.dark
                                ? tailwindColors[colorName]![800]!
                                : tailwindColors[colorName]![200]!
                            : null,
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? tailwindColors[colorName]![700]!
                              : tailwindColors[colorName]![200]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        getSortByString(context, sortId),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
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
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: backgroundDialogColor,
                backgroundColor: primaryColor,
              ),
              label: Text(AppLocalizations.of(context).dialogSave),
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
    Navigator.of(context).pop();
  }
}

String getSortByString(BuildContext context, int value) {
  if (value == 0) {
    // Value
    return AppLocalizations.of(context).sortBy0;
  } else if (value == 1) {
    // Name
    return AppLocalizations.of(context).sortBy1;
  }

  return '';
}
