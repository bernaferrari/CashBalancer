import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/l10n/l10n.dart';
import 'package:cash_balancer/page_settings/sort_by_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../widgets/dialog_screen_base.dart';
import 'currency_symbol_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          appBarTitle: AppLocalizations.of(context).settings,
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context).relativeTarget),
              subtitle: Text(
                "Sum up to 100% in each section, instead of considering all sections.",
                style: Theme.of(context).textTheme.caption,
              ),
              value: state.settings.relativeTarget,
              onChanged: (value) async {
                await rxPrefs.setBool("relativeTarget", value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(5),
                      //   side: BorderSide(color: Colors.red, width: 2),
                      // ),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).currencySymbol,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.settings.currencySymbol,
                          style: Theme.of(context).textTheme.caption?.copyWith(
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
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).sortBy,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getSortByString(context, state.settings.sortBy),
                          style: Theme.of(context).textTheme.caption?.copyWith(
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
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).designedDeveloped,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            const SizedBox(height: 8),
            Text(
              "@bernaferrari",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        );
      },
    );
  }
}
