import 'package:cash_balancer/blocs/data_bloc.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/l10n/l10n.dart';
import 'package:cash_balancer/settings/sort_by_dialog.dart';
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
            const SizedBox(height: 24),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).relativeTarget),
              subtitle: const Text(
                "Sum up to 100% in each section, instead of considering all sections.",
              ),
              value: state.settings.relativeTarget,
              onChanged: (value) {
                rxPrefs.setBool("relativeTarget", value);
              },
            ),
            const Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context).currencySymbol),
              subtitle: Text(state.settings.currencySymbol),
              onTap: () {
                showDialog<Object>(
                  context: context,
                  builder: (_) => CurrencySymbolDialog(
                      initialValue: state.settings.currencySymbol),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(AppLocalizations.of(context).sortBy),
              subtitle: Text(getSortByString(context, state.settings.sortBy)),
              onTap: () {
                showDialog<Object>(
                  context: context,
                  builder: (_) =>
                      SortByDialog(initialValue: state.settings.sortBy),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
