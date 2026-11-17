import 'package:beamer/beamer.dart';
import 'package:cash_balancer/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../util/numbers.dart';
import '../util/wallet_colors.dart';
import '../widgets/dialog_screen_base.dart';
import '../widgets/ledger.dart';

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

  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final currency = widget.bloc.state?.settings.currencySymbol ?? r'$';
    final selected = widget.wallets.firstWhere((w) => w.id == selectedGroupId);
    return DialogScreenBase(
      appBarTitle: context.l10n.moveWallet(widget.item.name),
      colorName: selected.colorName,
      bottom: [
        ElevatedButton.icon(
          icon: const Icon(Icons.check_rounded),
          label: Text(context.l10n.dialogSave),
          onPressed: onSubmit,
        ),
      ],
      children: [
        LedgerCard(
          child: Column(
            children: [
              for (final (i, group) in widget.wallets.indexed)
                () {
                  final isSelected = selectedGroupId == group.id;
                  final isCurrent = widget.item.walletId == group.id;
                  final accent = walletSeed(group.colorName);
                  return Semantics(
                    selected: isSelected,
                    child: InkWell(
                      onTap: () => setState(() => selectedGroupId = group.id),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accent.withValues(alpha: 0.10)
                              : null,
                          border: i == 0
                              ? null
                              : Border(top: BorderSide(color: l.hairline)),
                        ),
                        child: Row(
                          spacing: 12,
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 3,
                                children: [
                                  Text(
                                    group.name.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: display(
                                      15,
                                      weight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  Text(
                                    [
                                      money(
                                        context,
                                        currency,
                                        group.totalValue,
                                      ),
                                      if (isCurrent) context.l10n.currentWallet,
                                    ].join('  ·  '),
                                    style: figures(12.5, color: l.muted),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 160),
                              child: Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                key: ValueKey(isSelected),
                                size: 22,
                                color: isSelected ? accent : l.faint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }(),
            ],
          ),
        ),
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
