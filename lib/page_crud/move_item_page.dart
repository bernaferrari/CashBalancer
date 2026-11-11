import 'package:beamer/beamer.dart';
import 'package:cash_balancer/l10n/l10n.dart';
import 'package:flutter/material.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';

class const MoveItemPage({
  required final DataCubit bloc,
  required final ItemData item,
  required final List<WalletData> wallets,
  super.key,
}) extends StatefulWidget {
  @override
  State<MoveItemPage> createState() => _MoveItemPageState();
}

class _MoveItemPageState extends State<MoveItemPage> {
  late int selectedGroupId =
      widget.wallets.any((w) => w.id == widget.item.walletId)
          ? widget.item.walletId
          : widget.wallets.first.id;

  late final String colorName = widget.item.colorName;

  @override
  Widget build(BuildContext context) {
    final primaryColor = getPrimaryColor(context, colorName);
    final primaryColorWeaker = getPrimaryColorWeaker(context, colorName);
    final backgroundDialogColor = getBackgroundDialogColor(context, colorName);

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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Future<void> onSubmit([String? value]) async {
    await widget.bloc.db.updateItemWallet(
      item: widget.item,
      walletId: selectedGroupId,
    );

    if (!mounted) return;
    Beamer.of(context).popToNamed('/');
  }
}
