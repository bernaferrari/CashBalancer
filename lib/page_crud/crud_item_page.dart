import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../utils/error_handler.dart';
import '../widgets/dialog_screen_base.dart';

class const CRUDItemPage({
  required final String colorName,
  required final double totalValue,
  required final int walletId,
  required final int userId,
  required final String currency,
  final Item? previousItem,
  super.key,
}) extends StatefulWidget {
  @override
  State<CRUDItemPage> createState() => _CRUDItemPageState();
}

class _CRUDItemPageState extends State<CRUDItemPage> {
  static String _formatInitialNumber(double? value) {
    if (value == null || value < 0) return '';
    return value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousItem?.name);
  late final TextEditingController moneyEditingController =
      TextEditingController(
          text: _formatInitialNumber(widget.previousItem?.price));

  late final TextEditingController targetEditingController =
      TextEditingController(
          text: _formatInitialNumber(widget.previousItem?.targetPercent));

  String relativePercentage = '';

  // Reset focus to name's TextInput on save and add more.
  late final FocusNode nameFocusNode = FocusNode();
  late final FocusNode valueFocusNode = FocusNode();

  // This is used for validation.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      onChanged();
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    valueFocusNode.dispose();
    nameEditingController.dispose();
    moneyEditingController.dispose();
    targetEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = getPrimaryColor(context, widget.colorName);
    final primaryColorWeaker = getPrimaryColorWeaker(context, widget.colorName);
    final backgroundDialogColor =
        getBackgroundDialogColor(context, widget.colorName);

    return Form(
      key: _formKey,
      child: DialogScreenBase(
        colorName: widget.colorName,
        backgroundDialogColor: backgroundDialogColor,
        appBarTitle: widget.previousItem == null
            ? AppLocalizations.of(context).addAsset
            : AppLocalizations.of(context).editAsset,
        appBarActions: [
          if (widget.previousItem != null)
            IconButton(
              onPressed: () {
                Beamer.of(context)
                    .beamToNamed('/moveItem/${widget.previousItem!.id}');
              },
              icon: const Icon(Icons.low_priority),
              tooltip: AppLocalizations.of(context).move,
            ),
        ],
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameEditingController,
                      onFieldSubmitted: (value) {
                        valueFocusNode.requestFocus();
                      },
                      autofocus: widget.previousItem == null ? true : false,
                      focusNode: nameFocusNode,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)
                              .mainDialogValidator;
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
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).theAssetsName,
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
                      controller: moneyEditingController,
                      onFieldSubmitted: onSubmit,
                      onChanged: onChanged,
                      autofocus: widget.previousItem != null,
                      focusNode: valueFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)
                              .mainDialogValidator;
                        }
                        final num = double.tryParse(value);
                        if (num == null) {
                          return AppLocalizations.of(context).invalidValue;
                        }
                        if (num < 0) {
                          return AppLocalizations.of(context).valueMustBePositive;
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      textAlign: TextAlign.right,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: getInputFillColor(context),
                        labelText: AppLocalizations.of(context).value,
                        prefixText: widget.currency,
                        suffixText: moneyEditingController.text.contains('.')
                            ? null
                            : ".00",
                        labelStyle: TextStyle(color: primaryColor),
                        // border is used when there is an error
                        border: getInputDecorationBorder(primaryColor),
                        // focusedBorder is used when focused
                        focusedBorder: getInputDecorationBorder(primaryColor),
                        // enabledBorder is the default, first shown, border.
                        enabledBorder: getInputDecorationBorder(primaryColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).totalAmount,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: primaryColorWeaker.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
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
                            AppLocalizations.of(context).optional,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context).howMuchTarget,
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
                                return AppLocalizations.of(context).invalidValue;
                              }
                              if (num < 0 || num > 100) {
                                return AppLocalizations.of(context)
                                    .targetMustBeBetween;
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
                              labelText: AppLocalizations.of(context)
                                  .dialogAssetTarget,
                              filled: true,
                              fillColor: getInputFillColor(context),
                              suffixText:
                                  targetEditingController.text.contains('.')
                                      ? " %"
                                      : ".00 %",
                              labelStyle: TextStyle(color: primaryColorWeaker),
                              border:
                                  getInputDecorationBorder(primaryColorWeaker),
                              focusedBorder:
                                  getInputDecorationBorder(primaryColorWeaker),
                              enabledBorder:
                                  getInputDecorationBorder(primaryColorWeaker),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "${AppLocalizations.of(context).rightNow}, $relativePercentage",
                  style: Theme.of(context).textTheme.bodySmall,
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
            icon: const Icon(Icons.check_rounded),
            label: Text(AppLocalizations.of(context).dialogSave),
            onPressed: onSubmit,
          ),
          const SizedBox(height: 8),
          if (widget.previousItem == null)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: primaryColor),
              icon: const Icon(Icons.checklist_outlined),
              label: Text(AppLocalizations.of(context).dialogSaveAddMore),
              onPressed: onSaveAddMore,
            )
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: primaryColor),
              icon: const Icon(Icons.delete_outline_outlined),
              label: Text(AppLocalizations.of(context).dialogDelete),
              onPressed: onDelete,
            ),
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: primaryColorWeaker),
            icon: const Icon(Icons.close_rounded),
            label: Text(AppLocalizations.of(context).dialogCancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit([String? value]) async {
    if (_formKey.currentState!.validate()) {
      final isCreating = widget.previousItem == null;
      final trimmedName = nameEditingController.text.trim();

      final result = isCreating
          ? await safeDbOperation(
              () => context.read<DataCubit>().db.createItem(
                    walletId: widget.walletId,
                    userId: widget.userId,
                    name: trimmedName,
                    value: moneyEditingController.text,
                    target: targetEditingController.text,
                  ),
              errorMessage: 'Failed to create item',
            )
          : await safeDbOperation(
              () => context.read<DataCubit>().db.updateItem(
                    item: widget.previousItem!,
                    name: trimmedName,
                    price: moneyEditingController.text,
                    target: targetEditingController.text,
                  ),
              errorMessage: 'Failed to update item',
            );

      if (mounted) {
        result.when(
          success: (_) => Navigator.of(context).pop(),
          error: (error) => showErrorSnackbar(context, error),
        );
      }
    }
  }

  void onChanged([String? value]) {
    final moneyValue = double.tryParse(moneyEditingController.text) ?? 0;
    final currentTotal =
        context.read<DataCubit>().state?.totalValue ?? widget.totalValue;

    final double newTotal = widget.previousItem == null
        ? currentTotal + moneyValue
        : currentTotal + moneyValue - widget.previousItem!.price;

    final String finalPercent = newTotal <= 0
        ? '0'
        : (moneyValue / newTotal * 100).toStringAsFixed(2);

    setState(() {
      relativePercentage =
          '${widget.currency}${toCurrencyString(moneyEditingController.text)} ${AppLocalizations.of(context).isGoingToBe} $finalPercent%';
    });
  }

  Future<void> onSaveAddMore([String? value]) async {
    if (_formKey.currentState!.validate()) {
      final result = await safeDbOperation(
        () => context.read<DataCubit>().db.createItem(
              walletId: widget.walletId,
              userId: widget.userId,
              name: nameEditingController.text.trim(),
              value: moneyEditingController.text,
              target: targetEditingController.text,
            ),
        errorMessage: 'Failed to create item',
      );

      if (mounted) {
        result.when(
          success: (_) {
            nameFocusNode.requestFocus();
            _formKey.currentState?.reset();
            nameEditingController.text = '';
            moneyEditingController.text = '';
            targetEditingController.text = '';
            onChanged();
          },
          error: (error) => showErrorSnackbar(context, error),
        );
      }
    }
  }

  Future<void> onDelete() async {
    final result = await safeDbOperation(
      () => context.read<DataCubit>().db.deleteItem(widget.previousItem!),
      errorMessage: 'Failed to delete item',
    );

    if (mounted) {
      result.when(
        success: (_) => Navigator.of(context).pop(),
        error: (error) => showErrorSnackbar(context, error),
      );
    }
  }
}
