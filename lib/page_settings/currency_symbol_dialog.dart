import 'package:cash_balancer/l10n/l10n.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:cash_balancer/widgets/dialog_screen_base.dart';
import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class CurrencySymbolDialog extends StatefulWidget {
  final String initialValue;

  const CurrencySymbolDialog({Key? key, required this.initialValue})
      : super(key: key);

  @override
  _CurrencySymbolDialogState createState() => _CurrencySymbolDialogState();
}

class _CurrencySymbolDialogState extends State<CurrencySymbolDialog> {
  late final TextEditingController currencyEditingController =
      TextEditingController(text: widget.initialValue);

  // This is used for validation.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    currencyEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = (Theme.of(context).brightness == Brightness.dark)
        ? tailwindColors['gray']![300]!
        : tailwindColors['gray']![800]!;
    final backgroundDialogColor = Theme.of(context).colorScheme.background;

    return AlertDialog(
      title: Text(AppLocalizations.of(context).currencySymbol),
      backgroundColor: backgroundDialogColor,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: currencyEditingController,
              onFieldSubmitted: onSubmit,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).pleaseEnterCurrency;
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: AppLocalizations.of(context).currencySymbol,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  onPrimary: backgroundDialogColor,
                ),
                label: Text(AppLocalizations.of(context).dialogSave),
                icon: const Icon(Icons.check_rounded),
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit([String? value]) async {
    if (_formKey.currentState!.validate()) {
      await RxSharedPreferences.getInstance()
          .setString('currencySymbol', currencyEditingController.text);
      Navigator.of(context).pop();
    }
  }
}
