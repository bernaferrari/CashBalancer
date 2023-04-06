import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';

class MoveItemPage extends StatefulWidget {
  final ItemData item;
  final double totalValue;
  final DataCubit bloc;
  final List<WalletData> wallets;
  final int userId;

  const MoveItemPage(
      {required this.totalValue,
      required this.bloc,
      required this.userId,
      required this.item,
      required this.wallets,
      Key? key})
      : super(key: key);

  @override
  State<MoveItemPage> createState() => _MoveItemPageState();
}

class _MoveItemPageState extends State<MoveItemPage> {
  // late String relativePercentage;
  late int selectedGroupId = widget.wallets.first.id;

  late final String colorName = widget.item.colorName;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).brightness == Brightness.dark
        ? tailwindColors[colorName]![200]!
        : tailwindColors[colorName]![800]!;

    final primaryColorWeaker = Theme.of(context).brightness == Brightness.dark
        ? tailwindColors[colorName]![300]!
        : tailwindColors[colorName]![700]!;

    final backgroundDialogColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color.alphaBlend(
                Colors.black.withOpacity(0.60),
                tailwindColors[colorName]![900]!,
              )
            : tailwindColors[colorName]![100]!;

    return DialogScreenBase(
      backgroundDialogColor: backgroundDialogColor,
      appBarTitle: AppLocalizations.of(context).moveWallet(widget.item.name),
      colorName: colorName,
      children: [
        const SizedBox(height: 24),
        for (final group in widget.wallets)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: selectedGroupId == group.id
                    ? Theme.of(context).brightness == Brightness.dark
                        ? tailwindColors[group.colorName]![900]!
                        : tailwindColors[group.colorName]![100]!
                    : null,
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? tailwindColors[group.colorName]![700]!
                      : tailwindColors[group.colorName]![200]!,
                  width: 1,
                ),
              ),
              child: Text(
                group.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedGroupId = group.id;
                });
              },
            ),
          ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: backgroundDialogColor,
            backgroundColor: primaryColor,
          ),
          icon: const Icon(Icons.check_rounded),
          label: Text(AppLocalizations.of(context).dialogSave),
          onPressed: onSubmit,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: primaryColorWeaker),
          icon: const Icon(Icons.close_rounded),
          label: Text(AppLocalizations.of(context).dialogCancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void onSubmit([String? value]) {
    widget.bloc.db.updateItemWallet(
      item: widget.item,
      walletId: selectedGroupId,
    );

    Beamer.of(context).popToNamed('/');
  }
}
