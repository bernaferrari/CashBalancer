import 'dart:math';

import 'package:cash_balancer/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../utils/error_handler.dart';
import '../util/tailwind_colors.dart';
import '../widgets/color_picker.dart';
import '../widgets/dialog_screen_base.dart';

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

  late String colorName = widget.previousWallet?.colorName ??
      tailwindColorsNames[Random().nextInt(tailwindColorsNames.length)];

  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousWallet?.name);

  late final TextEditingController targetEditingController =
      TextEditingController(
    text: (widget.previousWallet != null &&
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

    return Form(
      key: _formKey,
      child: DialogScreenBase(
        appBarTitle: widget.previousWallet == null
            ? AppLocalizations.of(context).addAWallet
            : AppLocalizations.of(context).editWallet,
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
                return AppLocalizations.of(context).mainDialogValidator;
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: getInputFillColor(context),
              labelText: AppLocalizations.of(context).dialogAssetName,
              labelStyle: TextStyle(color: primaryColor),
              // border is used when there is an error
              border: getInputDecorationBorder(primaryColor),
              // focusedBorder is used when focused
              focusedBorder: getInputDecorationBorder(primaryColor),
              // enabledBorder is the default, first shown, border.
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
          Container(
            decoration: BoxDecoration(
              color: primaryColorWeaker.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.optional,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.howMuchTarget,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: targetEditingController,
                            onFieldSubmitted: onSubmit,
                            validator: (value) {
                              // Target is optional, so allow empty
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              final num = double.tryParse(value);
                              if (num == null) {
                                return context.l10n.invalidValue;
                              }
                              if (num < 0 || num > 100) {
                                return context.l10n.targetMustBeBetween;
                              }
                              return null;
                            },
                            textAlign: TextAlign.right,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (_) => setState(() {}),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              labelText: context.l10n.dialogAssetTarget,
                              filled: true,
                              fillColor: getInputFillColor(context),
                              suffixText:
                                  targetEditingController.text.contains('.')
                                      ? " %"
                                      : ".00 %",
                              labelStyle: TextStyle(color: primaryColorWeaker),
                              // border is used when there is an error
                              border:
                                  getInputDecorationBorder(primaryColorWeaker),
                              // focusedBorder is used when focused
                              focusedBorder:
                                  getInputDecorationBorder(primaryColorWeaker),
                              // enabledBorder is the default, first shown, border.
                              enabledBorder:
                                  getInputDecorationBorder(primaryColorWeaker),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final preset in const ['10', '25', '50', '100'])
                      ActionChip(
                        visualDensity: VisualDensity.compact,
                        label: Text('$preset%'),
                        backgroundColor:
                            targetEditingController.text.trim() == preset
                                ? primaryColor.withValues(alpha: 0.25)
                                : null,
                        onPressed: () {
                          setState(() {
                            targetEditingController.text = preset;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: backgroundDialogColor,
              backgroundColor: primaryColor,
            ),
            label: Text(AppLocalizations.of(context).dialogSave),
            icon: const Icon(Icons.check_rounded),
            onPressed: onSubmit,
          ),
          if (widget.previousWallet != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: primaryColor),
              label: Text(AppLocalizations.of(context).dialogDelete),
              icon: const Icon(Icons.delete_outline_outlined),
              onPressed: onDelete,
            ),
          ],
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            label: Text(AppLocalizations.of(context).dialogCancel),
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
              errorMessage: 'Failed to create wallet',
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
              errorMessage: 'Failed to update wallet',
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
    final result = await safeDbOperation(
      () => context.read<DataCubit>().db.deleteWallet(widget.previousWallet!.id),
      errorMessage: 'Failed to delete wallet',
    );

    if (mounted) {
      result.when(
        success: (_) => Navigator.of(context).pop(),
        error: (error) => showErrorSnackbar(context, error),
      );
    }
  }
}
