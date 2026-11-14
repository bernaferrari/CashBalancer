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
  var restoring = false;
  messenger.showSnackBar(
    SnackBar(
      content: Text(strings.deleted),
      action: SnackBarAction(
        label: strings.undo,
        onPressed: () async {
          if (restoring) return;
          restoring = true;
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

final _deletingRoutes = Expando<bool>();

bool isDeletingRoute(ModalRoute<dynamic> route) =>
    _deletingRoutes[route] == true;

Future<bool> deleteAndClose(
  BuildContext context,
  Future<Future<void> Function()> Function() delete,
) async {
  final route = ModalRoute.of(context);
  if (route != null) _deletingRoutes[route] = true;
  try {
    final undo = await delete();
    if (!context.mounted) return true;
    showDeleted(context, undo);
    if (route?.isCurrent == true) Navigator.of(context).pop();
    return true;
  } catch (_) {
    if (route != null) _deletingRoutes[route] = null;
    if (context.mounted) {
      showErrorSnackbar(context, context.l10n.operationFailed);
    }
    return false;
  }
}
