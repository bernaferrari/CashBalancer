import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:cash_balancer/widgets/dialog_screen_base.dart';
import 'package:flutter/material.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../l10n/l10n.dart';

class const CurrencySymbolDialog({super.key, required final String initialValue})
    extends StatefulWidget {
  @override
  State<CurrencySymbolDialog> createState() => _CurrencySymbolDialogState();
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

  static const _commonCurrencies = ['\$', '€', '£', 'R\$', '¥', '₿'];

  @override
  Widget build(BuildContext context) {
    final palette = TailwindColor.zinc.palette;
    final primaryColor = (Theme.of(context).brightness == Brightness.dark)
        ? palette.s300
        : palette.s800;
    final backgroundDialogColor = Theme.of(context).colorScheme.surface;

    return AlertDialog(
      title: Text(context.l10n.currencySymbol),
      backgroundColor: backgroundDialogColor,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: currencyEditingController,
              onFieldSubmitted: onSubmit,
              onChanged: (_) => setState(() {}),
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.pleaseEnterCurrency;
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: getInputFillColor(context),
                labelText: context.l10n.currencySymbol,
                labelStyle: TextStyle(color: primaryColor),
                // border is used when there is an error
                border: getInputDecorationBorder(primaryColor),
                // focusedBorder is used when focused
                focusedBorder: getInputDecorationBorder(primaryColor),
                // enabledBorder is the default, first shown, border.
                enabledBorder: getInputDecorationBorder(primaryColor),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final symbol in _commonCurrencies)
                  ActionChip(
                    label: Text(symbol),
                    backgroundColor:
                        currencyEditingController.text.trim() == symbol
                            ? primaryColor.withValues(alpha: 0.20)
                            : null,
                    onPressed: () {
                      setState(() {
                        currencyEditingController.text = symbol;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: backgroundDialogColor,
                  backgroundColor: primaryColor,
                ),
                label: Text(context.l10n.dialogSave),
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
          .setString('currencySymbol', currencyEditingController.text.trim());
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
