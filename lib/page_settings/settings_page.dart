import 'package:flutter/foundation.dart';

import 'dart:convert';

import 'package:file_selector/file_selector.dart' as picker;
import 'package:share_plus/share_plus.dart';

import '../util/error_handler.dart';

import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/page_settings/sort_by_dialog.dart';
import 'package:material_ui/material_ui.dart';
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
        final currentLangLabel =
            (currentLang != null &&
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
                          style: Theme.of(context).textTheme.bodySmall
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
                          portfolioId: state.userId,
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
                          style: Theme.of(context).textTheme.bodySmall
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
                          style: Theme.of(context).textTheme.bodySmall
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
                            _LanguageDialog(currentLanguageCode: currentLang),
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
                            ? Theme.of(context).colorScheme.primary
                                  .withValues(alpha: 0.14)
                            : null,
                        foregroundColor: state.settings.themeMode == modeId
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      icon: Icon(icon, size: 16),
                      label: Text(label, style: const TextStyle(fontSize: 12)),
                      onPressed: () async {
                        await rxPrefs.setInt('themeMode', modeId);
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.file_upload_outlined),
              label: Text(context.l10n.exportBackup),
              onPressed: () => _export(context),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.file_download_outlined),
              label: Text(context.l10n.importBackup),
              onPressed: () => _import(context, state.userId),
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

class const _LanguageDialog({required final String? currentLanguageCode})
    extends StatelessWidget {
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
                  final isSelected =
                      (code ?? '') == (currentLanguageCode ?? '');
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
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

Future<void> _export(BuildContext context) async {
  try {
    final backup = await context.read<DataCubit>().db.exportBackup();
    if (!context.mounted) return;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
      final target = await picker.getSaveLocation(
        suggestedName: 'cash-balancer-backup.json',
      );
      if (target != null) {
        await XFile.fromData(utf8.encode(backup)).saveTo(target.path);
      }
      return;
    }
    final box = context.findRenderObject()! as RenderBox;
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            Uint8List.fromList(utf8.encode(backup)),
            mimeType: 'application/json',
          ),
        ],
        fileNameOverrides: ['cash-balancer-backup.json'],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  } catch (_) {
    if (context.mounted) {
      showErrorSnackbar(context, context.l10n.operationFailed);
    }
  }
}

Future<void> _import(BuildContext context, int userId) async {
  final cubit = context.read<DataCubit>();
  final source = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.importBackup),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.pasteBackup),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.chooseBackupFile),
        ),
      ],
    ),
  );
  if (!context.mounted || source == null) return;
  try {
    final String? backup;
    if (source) {
      const group = picker.XTypeGroup(
        label: 'JSON',
        extensions: ['json'],
        mimeTypes: ['application/json'],
        uniformTypeIdentifiers: ['public.json'],
      );
      final file = await picker.openFile(acceptedTypeGroups: [group]);
      if (file == null) return;
      backup = await file.readAsString();
    } else {
      backup = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    }
    if (!context.mounted) return;
    if (backup == null || backup.trim().isEmpty) throw const FormatException();
    final replace = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.importBackup),
        content: Text(context.l10n.restoreExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.dialogCancel),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.replace),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.merge),
          ),
        ],
      ),
    );
    if (replace == null || !context.mounted) return;
    final id = await cubit.db.importPortfolioJson(
      userId,
      backup,
      replace: replace,
    );
    if (replace) await cubit.switchPortfolio(id);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.backupRestored)));
    }
  } on FormatException {
    if (context.mounted) showErrorSnackbar(context, context.l10n.invalidBackup);
  } catch (_) {
    if (context.mounted) {
      showErrorSnackbar(context, context.l10n.operationFailed);
    }
  }
}
