import '../widgets/delete_actions.dart';
import '../util/numbers.dart';

import 'package:beamer/beamer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/error_handler.dart';
import '../util/wallet_colors.dart';
import '../widgets/dialog_screen_base.dart';
import '../widgets/ledger.dart';
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
  late bool _isBalance = widget.previousItem?.isBalance ?? false;

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

  double? currentPercent;

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
    final l = context.ledger;
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
              icon: const Icon(Icons.drive_file_move_outline),
              tooltip: context.l10n.move,
            ),
        ],
        bottom: [
          ElevatedButton.icon(
            icon: const Icon(Icons.check_rounded),
            label: Text(context.l10n.dialogSave),
            onPressed: _saving ? null : onSubmit,
          ),
          if (widget.previousItem == null)
            TextButton.icon(
              icon: const Icon(Icons.playlist_add_rounded),
              label: Text(context.l10n.dialogSaveAddMore),
              onPressed: _saving ? null : onSaveAddMore,
            )
          else
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: l.sell),
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(context.l10n.dialogDelete),
              onPressed: _saving ? null : onDelete,
            ),
        ],
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
            style: Theme.of(context).textTheme.titleMedium,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.mainDialogValidator;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: context.l10n.dialogAssetName,
              hintText: context.l10n.assetNameHint,
            ),
          ),
          const SizedBox(height: 14),
          _amountFields(context),
          const SizedBox(height: 16),
          LedgerCard(
            child: SwitchListTile(
              contentPadding: const EdgeInsets.fromLTRB(18, 6, 14, 8),
              title: Text(
                context.l10n.balanceOnly,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  context.l10n.balanceOnlySubtitle,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: l.muted),
                ),
              ),
              value: _isBalance,
              onChanged: (value) {
                setState(() => _isBalance = value);
                onChanged();
              },
            ),
          ),
          const SizedBox(height: 12),
          TargetPercentageCard(
            controller: targetEditingController,
            color: walletSeed(widget.colorName),
            onFieldSubmitted: onSubmit,
            onChanged: () => setState(() {}),
            allocatedOtherPercent: allocatedOtherPercent,
            currentPercent: currentPercent,
          ),
        ],
      ),
    );
  }

  Widget _amountFields(BuildContext context) {
    const gap = 10.0;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 260);
    final price = TextFormField(
      controller: moneyEditingController,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      autofocus: widget.previousItem != null,
      focusNode: valueFocusNode,
      style: figures(16, weight: FontWeight.w600),
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: _isBalance ? context.l10n.balance : context.l10n.unitPrice,
        hintText: '0.00',
        prefixText: '${widget.currency} ',
      ),
    );
    final quantity = ExcludeFocus(
      excluding: _isBalance,
      child: IgnorePointer(
        ignoring: _isBalance,
        child: ExcludeSemantics(
          excluding: _isBalance,
          child: TextFormField(
            controller: quantityEditingController,
            onFieldSubmitted: onSubmit,
            onChanged: onChanged,
            style: figures(16, weight: FontWeight.w600),
            validator: (value) {
              if (_isBalance || value == null || value.isEmpty) return null;
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
              labelText: context.l10n.quantity,
              hintText: '1',
              prefixText: '× ',
            ),
          ),
        ),
      ),
    );
    final subtotal = ExcludeSemantics(
      excluding: _isBalance,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: _subtotal(context),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final quantityWidth = (constraints.maxWidth - gap) / 2;
        return TweenAnimationBuilder<double>(
          tween: Tween(end: _isBalance ? 0 : 1),
          duration: duration,
          curve: Curves.easeInOutCubic,
          builder: (context, units, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: price),
                  if (units > 0) ...[
                    SizedBox(width: gap * units),
                    ClipRect(
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        widthFactor: units,
                        // Keep the field laid out at its resting width as it fades.
                        child: Opacity(
                          opacity: units,
                          child: SizedBox(
                            width: quantityWidth,
                            child: quantity,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (units > 0)
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: units,
                    child: Opacity(opacity: units, child: subtotal),
                  ),
                ),
            ],
          ),
        );
      },
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
                isBalance: _isBalance,
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
                isBalance: _isBalance,
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
    final qty = _isBalance
        ? 1.0
        : double.tryParse(quantityEditingController.text) ?? 1;
    final moneyValue = unitPrice * qty;
    final data = context.read<DataCubit>().state;
    final currentTotal = data?.settings.relativeTarget == true
        ? data!.walletsMap[widget.walletId]?.totalValue ?? 0
        : data?.totalValue ?? widget.totalValue;

    final double newTotal = widget.previousItem == null
        ? currentTotal + moneyValue
        : currentTotal + moneyValue - widget.previousItem!.totalValue;

    setState(() {
      currentPercent = newTotal <= 0 || moneyValue <= 0
          ? null
          : moneyValue / newTotal * 100;
    });
  }

  /// "8 × $220.00 = $1,760.00" once a price is in, or what the fields mean.
  Widget _subtotal(BuildContext context) {
    final l = context.ledger;
    final price = double.tryParse(moneyEditingController.text);
    final quantity = double.tryParse(quantityEditingController.text) ?? 1;
    final total = price == null ? null : price * quantity;
    if (price == null || total == null || !total.isFinite) {
      return Text(
        context.l10n.unitPriceHelper,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: l.muted),
      );
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                '${formatQuantity(context, quantity)} × '
                '${money(context, widget.currency, price)} = ',
          ),
          TextSpan(
            text: money(context, widget.currency, total),
            style: TextStyle(color: l.ink, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      style: figures(12.5, color: l.muted),
    );
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
          isBalance: _isBalance,
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
    final item = widget.previousItem!;
    final deleted = await deleteAndClose(
      context,
      item.name,
      () => db.deleteItem(item),
    );
    if (mounted && !deleted) setState(() => _saving = false);
  }
}
