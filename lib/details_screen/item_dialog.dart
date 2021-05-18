import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/tailwind_colors.dart';

class ItemPage extends StatelessWidget {
  final int itemId;

  const ItemPage({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<DataBloc>().db.getItemFromId(itemId),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Text("HAS DATA ${snapshot.data}");
          } else {
            return Text("Loading");
          }
        });
  }
}

class ItemDialog extends StatefulWidget {
  final Function(String, String, String) onSavePressed;
  final VoidCallback? onDeletePressed;
  final Item? previousItem;
  final String colorName;
  final double totalValue;

  // Only used when previousItem != null.
  final DataBloc? bloc;
  final int? userId;
  final int? groupId;

  const ItemDialog({
    required this.colorName,
    required this.onSavePressed,
    required this.totalValue,
    this.bloc,
    this.groupId,
    this.userId,
    this.onDeletePressed,
    this.previousItem,
  });

  @override
  _DetailsGroupDialogState createState() => _DetailsGroupDialogState();
}

class _DetailsGroupDialogState extends State<ItemDialog> {
  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousItem?.name);
  late final TextEditingController moneyEditingController =
      TextEditingController(text: widget.previousItem?.price.toString());

  late final TextEditingController targetEditingController;
  final _formKey = GlobalKey<FormState>();
  late String relativePercentage;

  @override
  void initState() {
    if (widget.previousItem?.targetPercent == 0) {
      targetEditingController = TextEditingController();
    } else if (widget.previousItem?.targetPercent != null) {
      targetEditingController = TextEditingController(
          text: widget.previousItem?.targetPercent.toString());
    } else {
      targetEditingController = TextEditingController();
    }
    onChanged();
    super.initState();
  }

  @override
  void dispose() {
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

    return AlertDialog(
      title: Text(
        widget.previousItem == null
            ? AppLocalizations.of(context)!.addAsset
            : AppLocalizations.of(context)!.editAsset,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color.alphaBlend(
              Colors.black.withOpacity(0.60),
              tailwindColors[widget.colorName]![900]!,
            )
          : tailwindColors[widget.colorName]![100],
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: nameEditingController,
                onFieldSubmitted: onSubmit,
                autofocus: widget.previousItem == null ? true : false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.mainDialogValidator;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  labelText: AppLocalizations.of(context)!.mainDialogLabel,
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
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                        FilteringTextInputFormatter.digitsOnly
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
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
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
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: "Target (%)",
                        suffixText: ".00 %",
                        // prefixIcon: Icon(
                        //   Icons.price_change_rounded,
                        //   color: primaryColorWeaker,
                        // ),
                        labelStyle: TextStyle(color: primaryColorWeaker),
                        // border is used when there is an error
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColorWeaker),
                        ),
                        // focusedBorder is used when focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColorWeaker),
                        ),
                        // enabledBorder is the default, first shown, border.
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColorWeaker),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                relativePercentage,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: primaryColor),
                  icon: Icon(Icons.check_rounded),
                  label: Text(AppLocalizations.of(context)!.dialogSave),
                  onPressed: onSubmit,
                ),
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
            ],
          ),
        ),
      ),
    );
  }

  void onSubmit([String? value]) {
    if (_formKey.currentState!.validate()) {
      widget.bloc!.db.createItem(
        groupId: widget.groupId!,
        userId: widget.userId!,
        name: nameEditingController.text,
        value: moneyEditingController.text,
        target: targetEditingController.text,
      );
      widget.onSavePressed(nameEditingController.text,
          moneyEditingController.text, targetEditingController.text);
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

  void onSaveAddMore([String? value]) {
    if (_formKey.currentState!.validate()) {
      widget.bloc!.db.createItem(
        groupId: widget.groupId!,
        userId: widget.userId!,
        name: nameEditingController.text,
        value: moneyEditingController.text,
        target: targetEditingController.text,
      );

      _formKey.currentState?.reset();
      nameEditingController.text = '';
      moneyEditingController.text = '';
      targetEditingController.text = '';
    }
  }

  void onDelete() {
    widget.onDeletePressed?.call();
    Navigator.of(context).pop();
  }
}
