import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../util/tailwind_colors.dart';
import '../widgets/color_picker.dart';
import '../widgets/dialog_screen_base.dart';

class CRUDGroupPage extends StatefulWidget {
  final GroupData? previousGroup;
  final int userId;

  const CRUDGroupPage({
    required this.userId,
    this.previousGroup,
    Key? key,
  }) : super(key: key);

  @override
  _CRUDGroupPageState createState() => _CRUDGroupPageState();
}

class _CRUDGroupPageState extends State<CRUDGroupPage> {
  final _formKey = GlobalKey<FormState>();

  late String colorName = widget.previousGroup?.colorName ??
      tailwindColorsNames[Random().nextInt(tailwindColorsNames.length)];

  late final TextEditingController nameEditingController =
      TextEditingController(text: widget.previousGroup?.name);

  late final TextEditingController targetEditingController =
      TextEditingController(
          text: widget.previousGroup?.targetPercent.toInt().toString());

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

    print("target is ${widget.previousGroup?.targetPercent}");

    return Form(
      key: _formKey,
      child: DialogScreenBase(
        appBarTitle: widget.previousGroup == null
            ? AppLocalizations.of(context).addAGroup
            : AppLocalizations.of(context).editGroup,
        backgroundDialogColor: backgroundDialogColor,
        colorName: colorName,
        children: [
          TextFormField(
            controller: nameEditingController,
            onFieldSubmitted: onSubmit,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).mainDialogValidator;
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
              color: primaryColorWeaker.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(20),
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
                        style: Theme.of(context)
                            .textTheme
                            .overline!
                            .copyWith(color: primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "How much percentage you want this to be.",
                        style: Theme.of(context).textTheme.caption,
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
                          labelText:
                              AppLocalizations.of(context).dialogAssetTarget,
                          filled: true,
                          suffixText: ".00 %",
                          labelStyle: TextStyle(color: primaryColorWeaker),
                          // border is used when there is an error
                          border: getInputDecorationBorder(primaryColorWeaker),
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
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              onPrimary: backgroundDialogColor,
            ),
            label: Text(AppLocalizations.of(context).dialogSave),
            icon: const Icon(Icons.check_rounded),
            onPressed: onSubmit,
          ),
          if (widget.previousGroup != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(primary: primaryColor),
              label: Text(AppLocalizations.of(context).dialogDelete),
              icon: const Icon(Icons.delete_outline_outlined),
              onPressed: onDelete,
            ),
          ],
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(primary: primaryColor),
            label: Text(AppLocalizations.of(context).dialogCancel),
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void onSubmit([String? value]) {
    if (_formKey.currentState!.validate()) {
      context.read<DataCubit>().db;

      if (widget.previousGroup == null) {
        BlocProvider.of<DataCubit>(context)
            .db
            .createGroup(widget.userId, nameEditingController.text, colorName);
      } else {
        context.read<DataCubit>().db.editGroup(
              widget.previousGroup!.copyWith(
                name: nameEditingController.text,
                colorName: colorName,
                targetPercent:
                    double.tryParse(targetEditingController.text) ?? 0,
              ),
            );
      }

      Navigator.of(context).pop();
    }
  }

  void onDelete() {
    context.read<DataCubit>().db.deleteGroup(widget.previousGroup!.id);
    Navigator.of(context).pop();
  }
}
