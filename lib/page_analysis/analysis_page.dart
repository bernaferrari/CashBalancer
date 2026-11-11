import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../page_home/details_page.dart';
import '../widgets/when_empty_card.dart';
import 'bar_chart_section.dart';

class const AnalysisPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(builder: (context, state) {
      if (state == null) {
        return const SizedBox();
      } else {
        return DetailsPageImpl(state);
      }
    });
  }
}

class const DetailsPageImpl(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.allItems,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          onPressed: () {
            Beamer.of(context).popToNamed('/');
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: (data.walletsMap.isEmpty || data.allItems.isEmpty)
          ? WhenEmptyCard(
              title: context.l10n.mainEmptyTitle,
              subtitle: context.l10n.mainEmptySubtitle,
              icon: Icons.account_balance_sharp,
            )
          : PortfolioSplitView(
              data: data,
              children: [
                BarChartSection(data),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Total: ${data.settings.currencySymbol} ${toCurrency(data.totalValue)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Divider(height: 40),
                ItemsList(data),
              ],
            ),
    );
  }
}

class const ItemsList(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ItemData> sortedItems = [...data.allItems];
    if (data.settings.sortBy == 0) {
      sortedItems.sort((a, b) => b.totalValue.compareTo(a.totalValue));
    } else {
      sortedItems.sort((a, b) => a.name.compareTo(b.name));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < sortedItems.length; i++) ...[
          if (data.walletsMap.containsKey(sortedItems[i].walletId))
            SizedBox(
              width: double.infinity,
              child: ItemCard(
                sortedItems[i],
                data.settings.relativeTarget
                    ? data.walletsMap[sortedItems[i].walletId]?.totalValue ?? 0
                    : data.totalValue,
                data.settings.currencySymbol,
                buyOnlyTotalValue: data.settings.buyOnly
                    ? data.buyOnlyTotalForItems(sortedItems[i].walletId)
                    : null,
              ),
            ),
          if (i < sortedItems.length - 1)
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary
                  .withValues(alpha: 0.10),
            ),
        ],
      ],
    );
  }
}
