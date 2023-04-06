import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../widgets/dialog_screen_base.dart';

class CRUDItemPage extends StatefulWidget {
  final Item? previousItem;
  final String colorName;
  final double totalValue;
  final String currency;

  // Only used when previousItem != null.
  final int userId;
  final int walletId;

  const CRUDItemPage({
    required this.colorName,
    required this.totalValue,
    required this.walletId,
    required this.userId,
    required this.currency,
    this.previousItem,
    Key? key,
  }) : super(key: key);

  @override
  State<CRUDItemPage> createState() => _CRUDItemPageState();
}

class _CRUDItemPageState extends State<CRUDItemPage> {
  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousItem?.name);
  late final TextEditingController moneyEditingController =
      TextEditingController(
          text: widget.previousItem?.price.toInt().toString());

  late final TextEditingController targetEditingController =
      (widget.previousItem?.targetPercent != -1)
          ? TextEditingController(
              text: widget.previousItem?.targetPercent.toInt().toString())
          : TextEditingController();

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
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)
                              .mainDialogValidator;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
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
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*')),
                      ],
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: AppLocalizations.of(context).value,
                        // prefixIcon: Icon(
                        //   Icons.money_rounded,
                        //   color: primaryColor,
                        // ),
                        prefixText: widget.currency,
                        suffixText: ".00",
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
              color: primaryColorWeaker.withOpacity(0.10),
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
                              // No validator for target.
                              return null;
                            },
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^-?[0-9]*')),
                            ],
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                  .dialogAssetTarget,
                              filled: true,
                              suffixText: ".00 %",
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

  void onSubmit([String? value]) {
    if (_formKey.currentState!.validate()) {
      if (widget.previousItem == null) {
        context.read<DataCubit>().db.createItem(
              walletId: widget.walletId,
              userId: widget.userId,
              name: nameEditingController.text,
              value: moneyEditingController.text,
              target: targetEditingController.text,
            );
      } else {
        context.read<DataCubit>().db.updateItem(
              item: widget.previousItem!,
              name: nameEditingController.text,
              price: moneyEditingController.text,
              target: targetEditingController.text,
            );
      }

      Navigator.of(context).pop();
    }
  }

  void onChanged([String? value]) {
    final moneyValue = double.tryParse(moneyEditingController.text) ?? 0;

    final String finalPercent;
    if (moneyValue == 0 && widget.totalValue == 0) {
      finalPercent = '0';
    } else if (widget.previousItem == null) {
      finalPercent = (moneyValue / (widget.totalValue + moneyValue) * 100)
          .toStringAsFixed(2);
    } else {
      // Remove the previous price before adding the updated one.
      finalPercent = (moneyValue /
              (widget.totalValue + moneyValue - widget.previousItem!.price) *
              100)
          .toStringAsFixed(2);
    }

    setState(() {
      relativePercentage =
          '\$${toCurrencyString(moneyEditingController.text)} ${AppLocalizations.of(context).isGoingToBe} $finalPercent%';
    });
  }

  Future<void> onSaveAddMore([String? value]) async {
    if (_formKey.currentState!.validate()) {
      context.read<DataCubit>().db.createItem(
            walletId: widget.walletId,
            userId: widget.userId,
            name: nameEditingController.text,
            value: moneyEditingController.text,
            target: targetEditingController.text,
          );

      nameFocusNode.requestFocus();
      _formKey.currentState?.reset();
      nameEditingController.text = '';
      moneyEditingController.text = '';
      targetEditingController.text = '';
    }
  }

  void onDelete() {
    context.read<DataCubit>().db.deleteItem(widget.previousItem!);
    Navigator.of(context).pop();
  }
}
