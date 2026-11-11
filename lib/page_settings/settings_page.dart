import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/page_settings/sort_by_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../l10n/l10n.dart';
import '../widgets/dialog_screen_base.dart';
import 'currency_symbol_dialog.dart';

const _supportedLanguageNames = <String, String>{
  'en': 'English',
  'pt': 'Português',
  'es': 'Español',
  'fr': 'Français',
  'de': 'Deutsch',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'zh': '中文',
  'ru': 'Русский',
  'hi': 'हिन्दी',
  'tr': 'Türkçe',
};

class const SettingsPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeModes = [
      (0, Icons.brightness_auto_rounded, context.l10n.themeAuto),
      (1, Icons.light_mode_rounded, context.l10n.themeLight),
      (2, Icons.dark_mode_rounded, context.l10n.themeDark),
    ];

    return BlocBuilder<DataCubit, FullData?>(
      builder: (context, state) {
        if (state == null) {
          return const SizedBox();
        }

        final rxPrefs = RxSharedPreferences.getInstance();
        final currentLang = state.settings.languageCode;
        final currentLangLabel = (currentLang != null &&
                _supportedLanguageNames.containsKey(currentLang))
            ? _supportedLanguageNames[currentLang]!
            : context.l10n.themeAuto;

        return DialogScreenBase(
          colorName: 'stone',
          appBarTitle: context.l10n.settings,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.relativeTarget),
              subtitle: Text(
                context.l10n.targetSettings,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              value: state.settings.relativeTarget,
              onChanged: (value) async {
                await rxPrefs.setBool("relativeTarget", value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.buyOnlyRebalance),
              subtitle: Text(
                context.l10n.buyOnlyRebalanceSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              value: state.settings.buyOnly,
              onChanged: (value) async {
                await rxPrefs.setBool("buyOnly", value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                    child: Column(
                      spacing: 4,
                      children: [
                        Text(
                          context.l10n.currencySymbol,
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          state.settings.currencySymbol,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog<Object>(
                        context: context,
                        builder: (_) => CurrencySymbolDialog(
                          initialValue: state.settings.currencySymbol,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                    child: Column(
                      spacing: 4,
                      children: [
                        Text(
                          context.l10n.sortBy,
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          getSortByString(context, state.settings.sortBy),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog<Object>(
                        context: context,
                        builder: (_) =>
                            SortByDialog(initialValue: state.settings.sortBy),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                    child: Column(
                      spacing: 4,
                      children: [
                        Text(
                          context.l10n.language,
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currentLangLabel,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog<Object>(
                        context: context,
                        builder: (_) => _LanguageDialog(
                          currentLanguageCode: currentLang,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                for (final (modeId, icon, label) in themeModes)
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        backgroundColor: state.settings.themeMode == modeId
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.14)
                            : null,
                        foregroundColor: state.settings.themeMode == modeId
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      icon: Icon(icon, size: 16),
                      label: Text(
                        label,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () async {
                        await rxPrefs.setInt('themeMode', modeId);
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.copy_all_rounded, size: 18),
                    label: Text(
                      context.l10n.exportBackup,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () async {
                      final db = context.read<DataCubit>().db;
                      final jsonStr =
                          await db.exportPortfolioJson(state.userId);
                      await Clipboard.setData(ClipboardData(text: jsonStr));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${context.l10n.exportBackup} ✓'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.paste_rounded, size: 18),
                    label: Text(
                      context.l10n.importBackup,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () async {
                      final cubit = context.read<DataCubit>();
                      final clip =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (!context.mounted) return;
                      showDialog<Object>(
                        context: context,
                        builder: (_) => _ImportBackupDialog(
                          cubit: cubit,
                          userId: state.userId,
                          initialJson: clip?.text ?? '',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.designedDeveloped,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "@bernaferrari",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        );
      },
    );
  }
}

class const _LanguageDialog({
  required final String? currentLanguageCode,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rxPrefs = RxSharedPreferences.getInstance();
    final entries = [
      (null, context.l10n.themeAuto),
      for (final e in _supportedLanguageNames.entries) (e.key, e.value),
    ];

    return AlertDialog(
      title: Text(context.l10n.language),
      content: SizedBox(
        width: 280,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              for (final (code, label) in entries)
                () {
                  final isSelected = (code ?? '') == (currentLanguageCode ?? '');
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.14)
                            : null,
                      ),
                      onPressed: () async {
                        if (code == null) {
                          await rxPrefs.remove('languageCode');
                        } else {
                          await rxPrefs.setString('languageCode', code);
                        }
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: Text(label),
                    ),
                  );
                }(),
            ],
          ),
        ),
      ),
    );
  }
}

class const _ImportBackupDialog({
  required final DataCubit cubit,
  required final int userId,
  required final String initialJson,
}) extends StatefulWidget {
  @override
  State<_ImportBackupDialog> createState() => _ImportBackupDialogState();
}

class _ImportBackupDialogState extends State<_ImportBackupDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialJson);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.importBackup),
      content: SizedBox(
        width: 320,
        child: TextField(
          controller: _controller,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: '{"wallets": [...]}',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.dialogCancel),
        ),
        ElevatedButton(
          onPressed: () async {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            try {
              await widget.cubit.db.importPortfolioJson(widget.userId, text);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            } on Object {
              // Ignore malformed JSON.
            }
          },
          child: Text(context.l10n.dialogSave),
        ),
      ],
    );
  }
}
