import '../widgets/delete_actions.dart';
import '../util/numbers.dart';

import 'package:beamer/beamer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/error_handler.dart';
import '../widgets/dialog_screen_base.dart';
import '../widgets/target_percentage_card.dart';

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
  bool _saving = false;

  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousItem?.name);
  late final TextEditingController moneyEditingController =
      TextEditingController(text: editableNumber(widget.previousItem?.price));
  late final TextEditingController quantityEditingController =
      TextEditingController(
        text: editableNumber(widget.previousItem?.quantity ?? 1),
      );

  late final TextEditingController targetEditingController =
      TextEditingController(
        text: editableNumber(widget.previousItem?.targetPercent),
      );

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
    quantityEditingController.dispose();
    targetEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = getPrimaryColor(context, widget.colorName);
    final primaryColorWeaker = getPrimaryColorWeaker(context, widget.colorName);
    final backgroundDialogColor = getBackgroundDialogColor(
      context,
      widget.colorName,
    );

    final dataState = context.watch<DataCubit>().state;
    final siblingItems = dataState == null
        ? const <ItemData>[]
        : (dataState.settings.relativeTarget
              ? (dataState.walletsItems[widget.walletId] ?? const <ItemData>[])
              : dataState.allItems);
    final allocatedOtherPercent = siblingItems
        .where((i) => i.id != widget.previousItem?.id && i.targetPercent > 0)
        .fold<double>(0, (sum, i) => sum + i.targetPercent);

    return Form(
      key: _formKey,
      child: DialogScreenBase(
        colorName: widget.colorName,
        backgroundDialogColor: backgroundDialogColor,
        appBarTitle: widget.previousItem == null
            ? context.l10n.addAsset
            : context.l10n.editAsset,
        appBarActions: [
          if (widget.previousItem != null)
            IconButton(
              onPressed: () {
                Beamer.of(context)
                    .beamToNamed('/moveItem/${widget.previousItem!.id}');
              },
              icon: const Icon(Icons.low_priority),
              tooltip: context.l10n.move,
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
                      autofocus: widget.previousItem == null,
                      focusNode: nameFocusNode,
                      keyboardType: TextInputType.text,
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
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.theAssetsName,
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
                          return context.l10n.mainDialogValidator;
                        }
                        final num = double.tryParse(value);
                        if (num == null || !num.isFinite) {
                          return context.l10n.invalidValue;
                        }
                        if (num < 0) {
                          return context.l10n.valueMustBePositive;
                        }
                        return null;
                      },
                      inputFormatters: const <TextInputFormatter>[
                        DecimalTextInputFormatter(decimalRange: 324),
                      ],
                      textAlign: TextAlign.right,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: getInputFillColor(context),
                        labelText: context.l10n.unitPrice,
                        hintText: '0.00',
                        prefixText: widget.currency,
                        labelStyle: TextStyle(color: primaryColor),
                        border: getInputDecorationBorder(primaryColor),
                        focusedBorder: getInputDecorationBorder(primaryColor),
                        enabledBorder: getInputDecorationBorder(primaryColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.unitPriceHelper,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: quantityEditingController,
            onFieldSubmitted: onSubmit,
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final quantity = double.tryParse(value);
              return quantity != null &&
                      quantity.isFinite &&
                      quantity >= 0 &&
                      (quantity *
                              (double.tryParse(moneyEditingController.text) ??
                                  0))
                          .isFinite
                  ? null
                  : context.l10n.invalidValue;
            },
            textAlign: TextAlign.right,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: const <TextInputFormatter>[
              DecimalTextInputFormatter(decimalRange: 324),
            ],
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: getInputFillColor(context),
              labelText: context.l10n.quantity,
              hintText: '1',
              prefixText: '× ',
              labelStyle: TextStyle(color: primaryColorWeaker),
              border: getInputDecorationBorder(primaryColorWeaker),
              focusedBorder: getInputDecorationBorder(primaryColorWeaker),
              enabledBorder: getInputDecorationBorder(primaryColorWeaker),
            ),
          ),
          const SizedBox(height: 16),
          TargetPercentageCard(
            controller: targetEditingController,
            primaryColor: primaryColor,
            primaryColorWeaker: primaryColorWeaker,
            onFieldSubmitted: onSubmit,
            onChanged: () => setState(() {}),
            allocatedOtherPercent: allocatedOtherPercent,
            footer: Text(
              "${context.l10n.rightNow}, $relativePercentage",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: backgroundDialogColor,
              backgroundColor: primaryColor,
            ),
            icon: const Icon(Icons.check_rounded),
            label: Text(context.l10n.dialogSave),
            onPressed: _saving ? null : onSubmit,
          ),
          const SizedBox(height: 8),
          if (widget.previousItem == null)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: primaryColor),
              icon: const Icon(Icons.checklist_outlined),
              label: Text(context.l10n.dialogSaveAddMore),
              onPressed: _saving ? null : onSaveAddMore,
            )
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: primaryColor),
              icon: const Icon(Icons.delete_outline_outlined),
              label: Text(context.l10n.dialogDelete),
              onPressed: _saving ? null : onDelete,
            ),
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: primaryColorWeaker),
            icon: const Icon(Icons.close_rounded),
            label: Text(context.l10n.dialogCancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit([String? value]) async {
    if (!_saving && _formKey.currentState!.validate()) {
      setState(() => _saving = true);
      final isCreating = widget.previousItem == null;
      final trimmedName = nameEditingController.text.trim();

      final result = isCreating
          ? await safeDbOperation(
              () => context.read<DataCubit>().db.createItem(
                walletId: widget.walletId,
                userId: widget.userId,
                name: trimmedName,
                value: moneyEditingController.text,
                quantity: quantityEditingController.text,
                target: targetEditingController.text,
              ),
              errorMessage: context.l10n.operationFailed,
            )
          : await safeDbOperation(
              () => context.read<DataCubit>().db.updateItem(
                item: widget.previousItem!,
                name: trimmedName,
                price: moneyEditingController.text,
                quantity: quantityEditingController.text,
                target: targetEditingController.text,
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

  void onChanged([String? value]) {
    final unitPrice = double.tryParse(moneyEditingController.text) ?? 0;
    if (!mounted) return;
    final qty = double.tryParse(quantityEditingController.text) ?? 1;
    final moneyValue = unitPrice * qty;
    final data = context.read<DataCubit>().state;
    final currentTotal = data?.settings.relativeTarget == true
        ? data!.walletsMap[widget.walletId]?.totalValue ?? 0
        : data?.totalValue ?? widget.totalValue;

    final double newTotal = widget.previousItem == null
        ? currentTotal + moneyValue
        : currentTotal + moneyValue - widget.previousItem!.totalValue;

    final String finalPercent = newTotal <= 0
        ? '0'
        : formatPercent(
            moneyValue / newTotal * 100,
            Localizations.localeOf(context).toString(),
          );

    setState(() {
      relativePercentage =
          '${money(context, widget.currency, moneyValue)} ${context.l10n.isGoingToBe} $finalPercent%';
    });
  }

  Future<void> onSaveAddMore([String? value]) async {
    if (!_saving && _formKey.currentState!.validate()) {
      setState(() => _saving = true);
      final result = await safeDbOperation(
        () => context.read<DataCubit>().db.createItem(
          walletId: widget.walletId,
          userId: widget.userId,
          name: nameEditingController.text.trim(),
          value: moneyEditingController.text,
          quantity: quantityEditingController.text,
          target: targetEditingController.text,
        ),
        errorMessage: context.l10n.operationFailed,
      );

      if (mounted) {
        setState(() => _saving = false);
        result.when(
          success: (_) {
            nameFocusNode.requestFocus();
            _formKey.currentState?.reset();
            nameEditingController.text = '';
            moneyEditingController.text = '';
            quantityEditingController.text = '1';
            targetEditingController.text = '';
            onChanged();
          },
          error: (error) => showErrorSnackbar(context, error),
        );
      }
    }
  }

  Future<void> onDelete() async {
    final db = context.read<DataCubit>().db;
    if (_saving) return;
    setState(() => _saving = true);
    final deleted = await deleteAndClose(
      context,
      () => db.deleteItem(widget.previousItem!),
    );
    if (mounted && !deleted) setState(() => _saving = false);
  }
}
