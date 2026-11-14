import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../util/error_handler.dart';

Future<bool> confirmDelete(BuildContext context, String name) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.dialogDelete),
        content: Text('$name\n\n${context.l10n.confirmDeleteContents}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.dialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.dialogDelete),
          ),
        ],
      ),
    ) ==
    true;

void showDeleted(BuildContext context, Future<void> Function() undo) {
  final messenger = ScaffoldMessenger.of(context);
  final strings = context.l10n;
  messenger.showSnackBar(
    SnackBar(
      content: Text(strings.deleted),
      action: SnackBarAction(
        label: strings.undo,
        onPressed: () async {
          try {
            await undo();
          } catch (_) {
            if (messenger.mounted) {
              messenger.showSnackBar(
                SnackBar(content: Text(strings.operationFailed)),
              );
            }
          }
        },
      ),
    ),
  );
}

Future<void> deleteAndClose(
  BuildContext context,
  Future<Future<void> Function()> Function() delete,
) async {
  try {
    final undo = await delete();
    if (!context.mounted) return;
    showDeleted(context, undo);
    Navigator.of(context).pop();
  } catch (_) {
    if (context.mounted) {
      showErrorSnackbar(context, context.l10n.operationFailed);
    }
  }
}
