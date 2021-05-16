import 'dart:math';

import 'package:cash_balancer/details_screen/pickers.dart';

import '../util/tailwind_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/l10n.dart';

class GroupDialog extends StatefulWidget {
  final Function(String, String)? onSavePressed;
  final String? initialTitle;
  final String? initialColorName;

  const GroupDialog({
    this.onSavePressed,
    this.initialTitle,
    this.initialColorName,
  });

  @override
  _GroupDialogState createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  late final TextEditingController textEditingController;
  final _formKey = GlobalKey<FormState>();
  late String colorName;

  @override
  void initState() {
    colorName = widget.initialColorName ??
        tailwindColorsNames[Random().nextInt(tailwindColorsNames.length)];

    textEditingController = TextEditingController(text: widget.initialTitle);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).brightness == Brightness.dark
        ? tailwindColors[colorName]![200]!
        : tailwindColors[colorName]![800]!;

    return AlertDialog(
      title: Text(
        widget.initialTitle == null
            ? AppLocalizations.of(context)!.addGroup
            : AppLocalizations.of(context)!.editGroup,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color.alphaBlend(
              Colors.black.withOpacity(0.60),
              tailwindColors[colorName]![900]!,
            )
          : tailwindColors[colorName]![100],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textEditingController,
              onFieldSubmitted: onSubmit,
              autofocus: true,
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
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: AnimatedColorPicker(colorName, (changed) {
                setState(() {
                  colorName = changed;
                });
              }),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                ),
                child: Text(
                  AppLocalizations.of(context)!.dialogSave,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: onSubmit,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                child: Text(
                  AppLocalizations.of(context)!.dialogCancel,
                  style: GoogleFonts.rubik(
                    color: primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit([String? value]) {
    if (_formKey.currentState!.validate()) {
      widget.onSavePressed?.call(textEditingController.text, colorName);
      Navigator.of(context).pop();
    }
  }
}
