import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/error_handler.dart';
import '../util/numbers.dart';
import 'decimal_text_input_formatter.dart';

class const QuickPriceButton(final ItemData item, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: item.isBalance
        ? context.l10n.updateBalance
        : context.l10n.quickPrice,
    color: context.ledger.muted,
    icon: const Icon(Icons.sell_outlined, size: 19),
    onPressed: () => showDialog<void>(
      context: context,
      builder: (_) => Theme(
        data: buildTheme(
          Theme.of(context).brightness,
          colorName: item.colorName,
        ),
        child: _QuickPriceDialog(item, context.read<DataCubit>().db),
      ),
    ),
  );
}

class const _QuickPriceDialog(final Item item, final Database db)
    extends StatefulWidget {
  @override
  State<_QuickPriceDialog> createState() => _QuickPriceDialogState();
}

class _QuickPriceDialogState extends State<_QuickPriceDialog> {
  late final controller = TextEditingController(
    text: editableNumber(widget.item.price),
  );
  final form = GlobalKey<FormState>();
  bool saving = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (saving || !form.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      await widget.db.updatePrice(
        widget.item.id,
        double.parse(controller.text),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => saving = false);
      showErrorSnackbar(context, context.l10n.operationFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(controller.text);
    final total = price == null ? null : price * widget.item.quantity;
    final currency =
        context.read<DataCubit>().state?.settings.currencySymbol ?? '\$';
    return AlertDialog(
      title: Text(widget.item.name),
      content: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: controller,
              autofocus: true,
              textAlign: TextAlign.right,
              style: figures(20, weight: FontWeight.w600),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: <TextInputFormatter>[
                DecimalTextInputFormatter.localized(context, decimalRange: 324),
              ],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: widget.item.isBalance
                    ? context.l10n.balance
                    : context.l10n.unitPrice,
                prefixText: '$currency ',
              ),
              validator: (value) {
                final price = double.tryParse(value ?? '');
                return price == null ||
                        !price.isFinite ||
                        price < 0 ||
                        !(price * widget.item.quantity).isFinite
                    ? context.l10n.invalidValue
                    : null;
              },
              onFieldSubmitted: (_) => save(),
            ),
            if (!widget.item.isBalance && total != null && total.isFinite) ...[
              const SizedBox(height: 12),
              Text(
                '${formatQuantity(context, widget.item.quantity)} × '
                '${money(context, currency, price!)} = '
                '${money(context, currency, total)}',
                textAlign: TextAlign.right,
                style: figures(12.5, color: context.ledger.muted),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: Text(context.l10n.dialogCancel),
        ),
        FilledButton(
          onPressed: saving ? null : save,
          child: Text(context.l10n.dialogSave),
        ),
      ],
    );
  }
}
