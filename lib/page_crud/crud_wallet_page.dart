import '../widgets/delete_actions.dart';

import 'package:cash_balancer/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../util/tailwind_colors.dart';
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

  late String colorName = widget.previousWallet != null
      ? TailwindColor.fromName(widget.previousWallet!.colorName).name
      : TailwindColor.random().name;

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
    final primaryColor = getPrimaryColor(context, colorName);
    final primaryColorWeaker = getPrimaryColorWeaker(context, colorName);
    final backgroundDialogColor = getBackgroundDialogColor(context, colorName);
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
        backgroundDialogColor: backgroundDialogColor,
        colorName: colorName,
        children: [
          TextFormField(
            controller: nameEditingController,
            onFieldSubmitted: onSubmit,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.mainDialogValidator;
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: getInputFillColor(context),
              labelText: context.l10n.dialogAssetName,
              labelStyle: TextStyle(color: primaryColor),
              border: getInputDecorationBorder(primaryColor),
              focusedBorder: getInputDecorationBorder(primaryColor),
              enabledBorder: getInputDecorationBorder(primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ColorPicker(colorName, (changed) {
              setState(() {
                colorName = changed;
              });
            }),
          ),
          const SizedBox(height: 16),
          TargetPercentageCard(
            controller: targetEditingController,
            primaryColor: primaryColor,
            primaryColorWeaker: primaryColorWeaker,
            onFieldSubmitted: onSubmit,
            onChanged: () => setState(() {}),
            allocatedOtherPercent: allocatedOtherPercent,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: backgroundDialogColor,
              backgroundColor: primaryColor,
            ),
            label: Text(context.l10n.dialogSave),
            icon: const Icon(Icons.check_rounded),
            onPressed: onSubmit,
          ),
          if (widget.previousWallet != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: primaryColor),
              label: Text(context.l10n.dialogDelete),
              icon: const Icon(Icons.delete_outline_outlined),
              onPressed: onDelete,
            ),
          ],
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            label: Text(context.l10n.dialogCancel),
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit([String? value]) async {
    if (_formKey.currentState!.validate()) {
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
        result.when(
          success: (_) => Navigator.of(context).pop(),
          error: (error) => showErrorSnackbar(context, error),
        );
      }
    }
  }

  Future<void> onDelete() async {
    final db = context.read<DataCubit>().db;
    final wallet = widget.previousWallet!;
    if (!await confirmDelete(context, wallet.name) || !mounted) return;
    await deleteAndClose(context, () => db.deleteWallet(wallet.id));
  }
}
