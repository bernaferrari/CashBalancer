import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/l10n.dart';

class HomeInputDialog extends StatefulWidget {
  final ValueChanged<String>? onSavePressed;
  final String? initialValue;

  const HomeInputDialog({this.onSavePressed, this.initialValue});

  @override
  _HomeInputDialogState createState() => _HomeInputDialogState();
}

class _HomeInputDialogState extends State<HomeInputDialog> {
  late final TextEditingController textEditingController =
      TextEditingController(text: widget.initialValue);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialValue == null
            ? AppLocalizations.of(context)!.addAGroup
            : AppLocalizations.of(context)!.editGroup,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textEditingController,
              onFieldSubmitted: onSubmit,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.mainDialogValidator;
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: AppLocalizations.of(context)!.mainDialogLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                  style: GoogleFonts.rubik(),
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
      widget.onSavePressed?.call(textEditingController.text);
      Navigator.of(context).pop();
    }
  }
}
