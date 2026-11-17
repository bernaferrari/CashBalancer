import '../widgets/delete_actions.dart';
import '../util/error_handler.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../app/theme.dart';
import '../widgets/ledger.dart';

/// Phones get a bottom sheet within thumb reach; wide windows a dialog.
Future<void> showPortfolios(BuildContext context) {
  final cubit = context.read<DataCubit>();
  final asSheet = MediaQuery.sizeOf(context).width < 640;
  Widget content(BuildContext _) => BlocProvider.value(
    value: cubit,
    child: PortfoliosDialog(asSheet: asSheet),
  );
  if (!asSheet) return showDialog<void>(context: context, builder: content);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: content,
  );
}

class const PortfoliosDialog({super.key, final bool asSheet = false})
    extends StatefulWidget {
  @override
  State<PortfoliosDialog> createState() => _PortfoliosDialogState();
}

class _PortfoliosDialogState extends State<PortfoliosDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _renameController = TextEditingController();
  int? _editingPortfolioId;

  @override
  void dispose() {
    _nameController.dispose();
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(
      builder: (context, state) {
        if (state == null) return const SizedBox.shrink();

        final l = context.ledger;
        final cubit = context.read<DataCubit>();

        final body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedColumn(
              colorOf: (i) =>
                  state.portfolios[i].id == state.userId ? l.sunken : null,
              children: [
                for (final portfolio in state.portfolios)
                  _row(context, cubit, state, portfolio),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    onSubmitted: (_) => _createPortfolio(cubit),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: context.l10n.newPortfolio,
                    ),
                  ),
                ),
                IconButton.filled(
                  tooltip: context.l10n.newPortfolio,
                  style: IconButton.styleFrom(
                    backgroundColor: l.ink,
                    foregroundColor: l.canvas,
                    fixedSize: const Size(48, 48),
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => _createPortfolio(cubit),
                ),
              ],
            ),
          ],
        );
        final title = Text(
          context.l10n.portfolios,
          style: Theme.of(context).textTheme.headlineSmall,
        );
        if (widget.asSheet) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 16),
                    child: title,
                  ),
                  body,
                ],
              ),
            ),
          );
        }
        return AlertDialog(
          scrollable: true,
          title: title,
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 300, maxWidth: 360),
            child: body,
          ),
        );
      },
    );
  }

  Widget _row(
    BuildContext context,
    DataCubit cubit,
    FullData state,
    User portfolio,
  ) {
    final l = context.ledger;
    final isCurrent = portfolio.id == state.userId;
    final name = portfolio.name.isEmpty
        ? context.l10n.defaultPortfolio
        : portfolio.name;

    if (_editingPortfolioId == portfolio.id) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _renameController,
                autofocus: true,
                onSubmitted: (_) => _saveRename(cubit, portfolio),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(isDense: true),
              ),
            ),
            IconButton(
              tooltip: context.l10n.dialogSave,
              icon: const Icon(Icons.check_rounded, size: 20),
              onPressed: () => _saveRename(cubit, portfolio),
            ),
            IconButton(
              tooltip: context.l10n.dialogCancel,
              color: l.muted,
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () => setState(() => _editingPortfolioId = null),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () async {
        await cubit.switchPortfolio(portfolio.id);
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
        child: Row(
          children: [
            Icon(
              isCurrent ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 20,
              color: isCurrent ? l.ink : l.faint,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              tooltip: context.l10n.edit,
              color: l.muted,
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: () {
                setState(() {
                  _editingPortfolioId = portfolio.id;
                  _renameController.text = name;
                });
              },
            ),
            if (state.portfolios.length > 1)
              IconButton(
                tooltip: context.l10n.dialogDelete,
                color: l.muted,
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                onPressed: () async {
                  if (!await confirmDelete(context, name) || !context.mounted) {
                    return;
                  }
                  try {
                    final result = await cubit.db.deletePortfolio(portfolio.id);
                    if (isCurrent) {
                      await cubit.switchPortfolio(result.nextId);
                    }
                    if (context.mounted) {
                      showDeleted(context, name, result.undo);
                      Navigator.of(context).pop();
                    }
                  } catch (_) {
                    if (context.mounted) {
                      showErrorSnackbar(context, context.l10n.operationFailed);
                    }
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveRename(DataCubit cubit, User portfolio) async {
    final newName = _renameController.text.trim();
    if (newName.isNotEmpty) {
      await cubit.db.editUser(portfolio.copyWith(name: newName));
    }
    if (mounted) {
      setState(() => _editingPortfolioId = null);
    }
  }

  Future<void> _createPortfolio(DataCubit cubit) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final newId = await cubit.db.createUser(name);
    _nameController.clear();
    await cubit.switchPortfolio(newId);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
