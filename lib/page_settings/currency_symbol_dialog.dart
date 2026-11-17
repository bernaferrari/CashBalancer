import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';

import '../l10n/l10n.dart';

class const CurrencySymbolDialog({
  super.key,
  required final String initialValue,
  required final int portfolioId,
}) extends StatefulWidget {
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
    return AlertDialog(
      title: Text(context.l10n.currencySymbol),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: currencyEditingController,
              onFieldSubmitted: onSubmit,
              onChanged: (_) => setState(() {}),
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              style: figures(20, weight: FontWeight.w600),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.pleaseEnterCurrency;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: context.l10n.currencySymbol,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final symbol in _commonCurrencies)
                  ChoiceChip(
                    showCheckmark: false,
                    label: Text(symbol),
                    selected: currencyEditingController.text.trim() == symbol,
                    onSelected: (_) {
                      setState(() {
                        currencyEditingController.text = symbol;
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.dialogCancel),
        ),
        FilledButton(onPressed: onSubmit, child: Text(context.l10n.dialogSave)),
      ],
    );
  }

  Future<void> onSubmit([String? value]) async {
    if (_formKey.currentState!.validate()) {
      await context.read<DataCubit>().db.setPortfolioCurrency(
        widget.portfolioId,
        currencyEditingController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
