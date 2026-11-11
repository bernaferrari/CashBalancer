import 'package:beamer/beamer.dart';
import 'package:cash_balancer/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';

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
      appBarTitle: context.l10n.moveWallet(widget.item.name),
      colorName: colorName,
      children: [
        const SizedBox(height: 8),
        for (final group in widget.wallets)
          () {
            final isSelected = selectedGroupId == group.id;
            final palette = tailwindPalette(group.colorName);
            final groupAccent = palette.s500;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Theme.of(context).brightness == Brightness.dark
                          ? palette.s900
                          : palette.s100
                      : null,
                  side: BorderSide(
                    color: isSelected
                        ? groupAccent
                        : Theme.of(context).brightness == Brightness.dark
                            ? palette.s700
                            : palette.s200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedGroupId = group.id;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: groupAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        group.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: groupAccent,
                      ),
                  ],
                ),
              ),
            );
          }(),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: backgroundDialogColor,
            backgroundColor: primaryColor,
          ),
          icon: const Icon(Icons.check_rounded),
          label: Text(context.l10n.dialogSave),
          onPressed: onSubmit,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: primaryColorWeaker),
          icon: const Icon(Icons.close_rounded),
          label: Text(context.l10n.dialogCancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 8),
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
