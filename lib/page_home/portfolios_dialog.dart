import '../widgets/delete_actions.dart';
import '../util/error_handler.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../util/tailwind_colors.dart';
import '../widgets/dialog_screen_base.dart';

class const PortfoliosDialog({super.key}) extends StatefulWidget {
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

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primaryColor = isDark
            ? TailwindColor.emerald.palette.s300
            : TailwindColor.emerald.palette.s800;
        final cubit = context.read<DataCubit>();

        return AlertDialog(
          scrollable: true,
          title: Text(context.l10n.portfolios),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                for (final portfolio in state.portfolios)
                  () {
                    final isCurrent = portfolio.id == state.userId;
                    final isEditing = _editingPortfolioId == portfolio.id;

                    if (isEditing) {
                      return Row(
                        spacing: 6,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _renameController,
                              autofocus: true,
                              onSubmitted: (_) => _saveRename(cubit, portfolio),
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: getInputFillColor(context),
                                border: getInputDecorationBorder(primaryColor),
                                focusedBorder: getInputDecorationBorder(
                                  primaryColor,
                                ),
                                enabledBorder: getInputDecorationBorder(
                                  primaryColor,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: context.l10n.dialogSave,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: primaryColor,
                            ),
                            onPressed: () => _saveRename(cubit, portfolio),
                          ),
                          IconButton(
                            tooltip: context.l10n.dialogCancel,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () =>
                                setState(() => _editingPortfolioId = null),
                          ),
                        ],
                      );
                    }

                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isCurrent
                            ? primaryColor.withValues(alpha: 0.15)
                            : null,
                        side: BorderSide(
                          color: isCurrent
                              ? primaryColor
                              : Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: 0.12),
                          width: isCurrent ? 1.5 : 1,
                        ),
                      ),
                      onPressed: () async {
                        await cubit.switchPortfolio(portfolio.id);
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            isCurrent
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            size: 18,
                            color: isCurrent
                                ? primaryColor
                                : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              portfolio.name.isEmpty
                                  ? context.l10n.defaultPortfolio
                                  : portfolio.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: context.l10n.edit,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () {
                              setState(() {
                                _editingPortfolioId = portfolio.id;
                                _renameController.text = portfolio.name.isEmpty
                                    ? context.l10n.defaultPortfolio
                                    : portfolio.name;
                              });
                            },
                          ),
                          if (state.portfolios.length > 1)
                            IconButton(
                              tooltip: context.l10n.dialogDelete,
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                              onPressed: () async {
                                final name = portfolio.name.isEmpty
                                    ? context.l10n.defaultPortfolio
                                    : portfolio.name;
                                if (!await confirmDelete(context, name) ||
                                    !context.mounted) {
                                  return;
                                }
                                try {
                                  final result = await cubit.db.deletePortfolio(
                                    portfolio.id,
                                  );
                                  if (isCurrent) {
                                    await cubit.switchPortfolio(result.nextId);
                                  }
                                  if (context.mounted) {
                                    showDeleted(context, result.undo);
                                    Navigator.of(context).pop();
                                  }
                                } catch (_) {
                                  if (context.mounted) {
                                    showErrorSnackbar(
                                      context,
                                      context.l10n.operationFailed,
                                    );
                                  }
                                }
                              },
                            ),
                        ],
                      ),
                    );
                  }(),
                const Divider(height: 16),
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
                          filled: true,
                          fillColor: getInputFillColor(context),
                          hintText: context.l10n.newPortfolio,
                          border: getInputDecorationBorder(primaryColor),
                          focusedBorder: getInputDecorationBorder(primaryColor),
                          enabledBorder: getInputDecorationBorder(primaryColor),
                        ),
                      ),
                    ),
                    IconButton.filled(
                      tooltip: context.l10n.newPortfolio,
                      style: IconButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Theme.of(context).colorScheme.surface,
                      ),
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () => _createPortfolio(cubit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
