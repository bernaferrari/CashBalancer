import '../widgets/delete_actions.dart';

import 'package:cash_balancer/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../util/wallet_colors.dart';
import '../util/error_handler.dart';
import '../widgets/color_picker.dart';
import '../widgets/dialog_screen_base.dart';
import '../widgets/target_percentage_card.dart';

class const CRUDWalletPage({
  required final int userId,
  final WalletData? previousWallet,
  super.key,
}) extends StatefulWidget {
  @override
  State<CRUDWalletPage> createState() => _CRUDWalletPageState();
}

class _CRUDWalletPageState extends State<CRUDWalletPage> {
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  late String colorName = widget.previousWallet != null
      ? WalletColor.fromName(widget.previousWallet!.colorName).name
      : WalletColor.random().name;

  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousWallet?.name);

  late final TextEditingController targetEditingController =
      TextEditingController(
        text:
            (widget.previousWallet != null &&
                widget.previousWallet!.targetPercent >= 0)
            ? (widget.previousWallet!.targetPercent ==
                      widget.previousWallet!.targetPercent.truncateToDouble()
                  ? widget.previousWallet!.targetPercent.toInt().toString()
                  : widget.previousWallet!.targetPercent.toString())
            : '',
      );

  @override
  void dispose() {
    nameEditingController.dispose();
    targetEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataState = context.watch<DataCubit>().state;
    final allocatedOtherPercent = dataState == null
        ? 0.0
        : dataState.walletsMap.values
              .where(
                (w) => w.id != widget.previousWallet?.id && w.targetPercent > 0,
              )
              .fold<double>(0, (sum, w) => sum + w.targetPercent);

    return Form(
      key: _formKey,
      child: DialogScreenBase(
        appBarTitle: widget.previousWallet == null
            ? context.l10n.addAWallet
            : context.l10n.editWallet,
        colorName: colorName,
        bottom: [
          ElevatedButton.icon(
            label: Text(context.l10n.dialogSave),
            icon: const Icon(Icons.check_rounded),
            onPressed: _saving ? null : onSubmit,
          ),
          if (widget.previousWallet != null)
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: context.ledger.sell),
              label: Text(context.l10n.dialogDelete),
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _saving ? null : onDelete,
            ),
        ],
        children: [
          TextFormField(
            controller: nameEditingController,
            onFieldSubmitted: onSubmit,
            autofocus: widget.previousWallet == null,
            textCapitalization: TextCapitalization.sentences,
            style: Theme.of(context).textTheme.titleMedium,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.mainDialogValidator;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: context.l10n.dialogAssetName,
              hintText: context.l10n.walletNameHint,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: walletSeed(colorName),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(height: 16),
          ColorPicker(colorName, (changed) {
            setState(() {
              colorName = changed;
            });
          }),
          const SizedBox(height: 20),
          TargetPercentageCard(
            controller: targetEditingController,
            color: walletSeed(colorName),
            onFieldSubmitted: onSubmit,
            onChanged: () => setState(() {}),
            allocatedOtherPercent: allocatedOtherPercent,
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit([String? value]) async {
    if (!_saving && _formKey.currentState!.validate()) {
      setState(() => _saving = true);
      final isCreating = widget.previousWallet == null;
      final trimmedName = nameEditingController.text.trim();

      final result = isCreating
          ? await safeDbOperation(
              () => context.read<DataCubit>().db.createGroup(
                id: widget.userId,
                name: trimmedName,
                colorName: colorName,
                targetPercent:
                    double.tryParse(targetEditingController.text) ?? -1,
              ),
              errorMessage: context.l10n.operationFailed,
            )
          : await safeDbOperation(
              () => context.read<DataCubit>().db.editWallet(
                widget.previousWallet!.copyWith(
                  name: trimmedName,
                  colorName: colorName,
                  targetPercent:
                      double.tryParse(targetEditingController.text) ?? -1,
                ),
              ),
              errorMessage: context.l10n.operationFailed,
            );

      if (mounted) {
        setState(() => _saving = false);
        result.when(
          success: (_) => Navigator.of(context).pop(),
          error: (error) => showErrorSnackbar(context, error),
        );
      }
    }
  }

  Future<void> onDelete() async {
    if (_saving) return;
    setState(() => _saving = true);
    final db = context.read<DataCubit>().db;
    final wallet = widget.previousWallet!;
    if (await confirmDelete(context, wallet.name) && mounted) {
      final deleted = await deleteAndClose(
        context,
        () => db.deleteWallet(wallet.id),
      );
      if (deleted) return;
    }
    if (mounted) setState(() => _saving = false);
  }
}
