import 'package:flutter/foundation.dart';

import 'dart:convert';

import 'package:file_selector/file_selector.dart' as picker;
import 'package:share_plus/share_plus.dart';

import '../util/error_handler.dart';

import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../app/theme.dart';
import '../l10n/l10n.dart';
import '../widgets/dialog_screen_base.dart';
import '../widgets/expressive.dart';
import '../widgets/ledger.dart';
import 'currency_symbol_dialog.dart';
import 'backup_download.dart';

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

        final l = context.ledger;

        return DialogScreenBase(
          appBarTitle: context.l10n.settings,
          children: [
            SectionLabel(context.l10n.rebalanceCalculator),
            SegmentedColumn(
              children: [
                _SwitchRow(
                  title: context.l10n.relativeTarget,
                  subtitle: context.l10n.targetSettings,
                  value: state.settings.relativeTarget,
                  onChanged: (value) =>
                      rxPrefs.setBool("relativeTarget", value),
                ),
                _SwitchRow(
                  title: context.l10n.buyOnlyRebalance,
                  subtitle: context.l10n.buyOnlyRebalanceSubtitle,
                  value: state.settings.buyOnly,
                  onChanged: (value) => rxPrefs.setBool("buyOnly", value),
                ),
              ],
            ),
            const SizedBox(height: 26),
            SectionLabel(context.l10n.preferences),
            SegmentedColumn(
              children: [
                _SettingsRow(
                  title: context.l10n.currencySymbol,
                  value: state.settings.currencySymbol,
                  onTap: () {
                    showDialog<Object>(
                      context: context,
                      builder: (_) => CurrencySymbolDialog(
                        initialValue: state.settings.currencySymbol,
                        portfolioId: state.userId,
                      ),
                    );
                  },
                ),
                _SettingsRow(
                  title: context.l10n.language,
                  value: currentLangLabel,
                  onTap: () {
                    showDialog<Object>(
                      context: context,
                      builder: (_) =>
                          _LanguageDialog(currentLanguageCode: currentLang),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.sortBy,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      ConnectedButtonGroup<int>(
                        height: 38,
                        segments: [
                          for (final id in const [0, 1])
                            (id, getSortByString(context, id), null),
                        ],
                        selected: state.settings.sortBy,
                        onSelected: (value) => rxPrefs.setInt('sortBy', value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            SectionLabel(context.l10n.appearance),
            ConnectedButtonGroup<int>(
              expand: true,
              height: 48,
              segments: [
                for (final (modeId, icon, label) in themeModes)
                  (modeId, label, icon),
              ],
              selected: state.settings.themeMode,
              onSelected: (value) => rxPrefs.setInt('themeMode', value),
            ),
            const SizedBox(height: 26),
            SectionLabel(context.l10n.backup),
            SegmentedColumn(
              children: [
                _SettingsRow(
                  icon: Icons.ios_share_rounded,
                  title: context.l10n.exportBackup,
                  onTap: () => _export(context),
                ),
                _SettingsRow(
                  icon: Icons.settings_backup_restore_rounded,
                  title: context.l10n.importBackup,
                  onTap: () => _import(context, state.userId),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              context.l10n.designedDeveloped,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: l.muted),
            ),
            const SizedBox(height: 2),
            Text(
              "@bernaferrari",
              textAlign: TextAlign.center,
              style: figures(12, color: l.faint),
            ),
          ],
        );
      },
    );
  }
}

String getSortByString(BuildContext context, int value) => switch (value) {
  0 => context.l10n.sortBy0,
  1 => context.l10n.sortBy1,
  _ => '',
};

class const _SwitchRow({
  required final String title,
  required final String subtitle,
  required final bool value,
  required final ValueChanged<bool> onChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: const EdgeInsets.fromLTRB(18, 6, 14, 8),
    title: Text(title, style: Theme.of(context).textTheme.titleSmall),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: context.ledger.muted),
      ),
    ),
    value: value,
    onChanged: onChanged,
  );
}

class const _SettingsRow({
  required final String title,
  required final VoidCallback onTap,
  final String? value,
  final IconData? icon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
        shape: const RoundedRectangleBorder(),
        alignment: Alignment.centerLeft,
      ),
      onPressed: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: l.ink),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: l.ink),
            ),
          ),
          if (value != null) ...[
            Text(
              value!,
              style: figures(13.5, weight: FontWeight.w500, color: l.muted),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 20, color: l.faint),
          ],
        ],
      ),
    );
  }
}

class const _LanguageDialog({required final String? currentLanguageCode})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final rxPrefs = RxSharedPreferences.getInstance();
    final entries = [
      (null, context.l10n.themeAuto),
      for (final e in _supportedLanguageNames.entries) (e.key, e.value),
    ];

    return AlertDialog(
      title: Text(context.l10n.language),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: SegmentedColumn(
            colorOf: (i) => (entries[i].$1 ?? '') == (currentLanguageCode ?? '')
                ? l.sunken
                : null,
            children: [
              for (final (code, label) in entries)
                () {
                  final isSelected =
                      (code ?? '') == (currentLanguageCode ?? '');
                  return InkWell(
                    onTap: () async {
                      if (code == null) {
                        await rxPrefs.remove('languageCode');
                      } else {
                        await rxPrefs.setString('languageCode', code);
                      }
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 13, 16, 13),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_rounded, size: 20, color: l.ink),
                        ],
                      ),
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
    const filename = 'cash-balancer-backup.json';
    if (kIsWeb) {
      downloadBackup(backup, filename);
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      final target = await picker.getSaveLocation(suggestedName: filename);
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
        fileNameOverrides: [filename],
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
    final preview = await cubit.db.previewBackupMerge(userId, backup);
    if (!context.mounted) return;
    final replace = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.importBackup),
        scrollable: true,
        content: Text(
          '${context.l10n.restoreExplanation}\n\n'
          '${context.l10n.mergePreview(preview.added, preview.kept)}',
        ),
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
