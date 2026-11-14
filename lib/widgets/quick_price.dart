import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/error_handler.dart';
import '../util/numbers.dart';
import 'dialog_screen_base.dart';

class const QuickPriceButton(final Item item, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.quickPrice,
    icon: const Icon(Icons.price_change_outlined),
    onPressed: () => showDialog<void>(
      context: context,
      builder: (_) => _QuickPriceDialog(item, context.read<DataCubit>().db),
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
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.item.name),
    content: Form(
      key: form,
      child: TextFormField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: const <TextInputFormatter>[
          DecimalTextInputFormatter(decimalRange: 324),
        ],
        decoration: InputDecoration(labelText: context.l10n.unitPrice),
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
