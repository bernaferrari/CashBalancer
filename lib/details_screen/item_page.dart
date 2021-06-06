import 'package:beamer/beamer.dart';
import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/tailwind_colors.dart';
import 'dialog_screen_base.dart';

class ItemDialogPage extends StatefulWidget {
  final Item? previousItem;
  final String colorName;
  final double totalValue;

  // Only used when previousItem != null.
  final int userId;
  final int groupId;

  const ItemDialogPage({
    required this.colorName,
    required this.totalValue,
    required this.groupId,
    required this.userId,
    this.previousItem,
  });

  @override
  _ItemDialogPageState createState() => _ItemDialogPageState();
}

class _ItemDialogPageState extends State<ItemDialogPage> {
  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousItem?.name);
  late final TextEditingController moneyEditingController =
      TextEditingController(
          text: widget.previousItem?.price.toInt().toString());

  late final TextEditingController targetEditingController =
      (widget.previousItem?.targetPercent != 0)
          ? TextEditingController(
              text: widget.previousItem?.targetPercent.toInt().toString())
          : TextEditingController();

  late String relativePercentage;

  // Reset focus to name's TextInput on save and add more.
  late final FocusNode nameFocusNode = FocusNode();

  // This is used for validation.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onChanged();
    super.initState();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameEditingController.dispose();
    moneyEditingController.dispose();
    targetEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).brightness == Brightness.dark
        ? tailwindColors[widget.colorName]![200]!
        : tailwindColors[widget.colorName]![800]!;

    final primaryColorWeaker = Theme.of(context).brightness == Brightness.dark
        ? tailwindColors[widget.colorName]![300]!
        : tailwindColors[widget.colorName]![700]!;

    final backgroundDialogColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color.alphaBlend(
                Colors.black.withOpacity(0.60),
                tailwindColors[widget.colorName]![900]!,
              )
            : tailwindColors[widget.colorName]![100]!;

    return Form(
      key: _formKey,
      child: DialogScreenBase(
        colorName: widget.colorName,
        backgroundDialogColor: backgroundDialogColor,
        appBarTitle: widget.previousItem == null
            ? AppLocalizations.of(context)!.addAsset
            : AppLocalizations.of(context)!.editAsset,
        appBarActions: [
          if (widget.previousItem != null)
            IconButton(
              onPressed: () {
                Beamer.of(context)
                    .beamToNamed('/moveItem/${widget.previousItem!.id}');
              },
              icon: Icon(Icons.low_priority),
              tooltip: "Move",
            ),
        ],
        children: [
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Row(
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
                        onFieldSubmitted: onSubmit,
                        autofocus: widget.previousItem == null ? true : false,
                        focusNode: nameFocusNode,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .mainDialogValidator;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          labelText:
                              AppLocalizations.of(context)!.dialogAssetName,
                          labelStyle: TextStyle(color: primaryColor),
                          // border is used when there is an error
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          // focusedBorder is used when focused
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          // enabledBorder is the default, first shown, border.
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "The asset’s name, such as savings or bitcoin.",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .mainDialogValidator;
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^-?[0-9]*')),
                        ],
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Value (\$)",
                          // prefixIcon: Icon(
                          //   Icons.money_rounded,
                          //   color: primaryColor,
                          // ),
                          prefixText: "\$",
                          suffixText: ".00",
                          labelStyle: TextStyle(color: primaryColor),
                          // border is used when there is an error
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          // focusedBorder is used when focused
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          // enabledBorder is the default, first shown, border.
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "The total amount you own.",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColorWeaker.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "OPTIONAL",
                          style: Theme.of(context).textTheme.overline,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "How much % you want ${nameEditingController.text} to be. Right now, $relativePercentage",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
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
                            //
                            // if (value == null || value.isEmpty) {
                            //   return AppLocalizations.of(context)!
                            //       .mainDialogValidator;
                            // }
                            return null;
                          },
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^-?[0-9]*')),
                          ],
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.dialogAssetTarget,
                            filled: true,
                            suffixText: ".00 %",
                            // prefixIcon: Icon(
                            //   Icons.price_change_rounded,
                            //   color: primaryColorWeaker,
                            // ),
                            labelStyle: TextStyle(color: primaryColorWeaker),
                            // border is used when there is an error
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: primaryColorWeaker,
                              ),
                            ),
                            // focusedBorder is used when focused
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: primaryColorWeaker,
                              ),
                            ),
                            // enabledBorder is the default, first shown, border.
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: primaryColorWeaker,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(height: 16),
          // Text(
          //   relativePercentage,
          //   style: Theme.of(context).textTheme.bodyText2,
          // ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              onPrimary: backgroundDialogColor,
            ),
            icon: Icon(Icons.check_rounded),
            label: Text(AppLocalizations.of(context)!.dialogSave),
            onPressed: onSubmit,
          ),
          SizedBox(height: 8),
          if (widget.previousItem == null)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(primary: primaryColor),
              icon: Icon(Icons.checklist_outlined),
              label: Text(AppLocalizations.of(context)!.dialogSaveAddMore),
              onPressed: onSaveAddMore,
            )
          else
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(primary: primaryColor),
              icon: Icon(Icons.delete_outline_outlined),
              label: Text(AppLocalizations.of(context)!.dialogDelete),
              onPressed: onDelete,
            ),
          SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(primary: primaryColorWeaker),
            icon: Icon(Icons.close_rounded),
            label: Text(AppLocalizations.of(context)!.dialogCancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  void onSubmit([String? value]) {
    if (_formKey.currentState!.validate()) {
      if (widget.previousItem == null) {
        context.read<DataCubit>().db.createItem(
              groupId: widget.groupId,
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

    late final String finalPercent;
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
      '\$${moneyEditingController.text} is going to be $finalPercent%';
    });
  }

  Future<void> onSaveAddMore([String? value]) async {
    if (_formKey.currentState!.validate()) {
      context.read<DataCubit>().db.createItem(
            groupId: widget.groupId,
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
