import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/page_settings/sort_by_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../l10n/l10n.dart';
import '../widgets/dialog_screen_base.dart';
import 'currency_symbol_dialog.dart';

class const SettingsPage({super.key}) extends StatelessWidget {
  static const _themeModes = [
    (0, Icons.brightness_auto_rounded, 'Auto'),
    (1, Icons.light_mode_rounded, 'Light'),
    (2, Icons.dark_mode_rounded, 'Dark'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(
      builder: (context, state) {
        if (state == null) {
          return const SizedBox();
        }

        final rxPrefs = RxSharedPreferences.getInstance();

        return DialogScreenBase(
          colorName: 'warmGray',
          appBarTitle: context.l10n.settings,
          children: [
            SwitchListTile(
              title: Text(context.l10n.relativeTarget),
              subtitle: Text(
                context.l10n.targetSettings,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: state.settings.relativeTarget,
              onChanged: (value) async {
                await rxPrefs.setBool("relativeTarget", value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Column(
                      spacing: 4,
                      children: [
                        Text(
                          context.l10n.currencySymbol,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          state.settings.currencySymbol,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
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
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Column(
                      spacing: 4,
                      children: [
                        Text(
                          context.l10n.sortBy,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          getSortByString(context, state.settings.sortBy),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
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
              ],
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                for (final (modeId, icon, label) in _themeModes)
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
