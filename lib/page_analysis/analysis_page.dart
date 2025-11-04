import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../page_home/details_page.dart';
import 'bar_chart_section.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

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

class DetailsPageImpl extends StatelessWidget {
  final FullData data;

  const DetailsPageImpl(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).allItems,
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
        centerTitle: true,
      ),
      body: (data.walletsMap.isEmpty == true)
          ? WhenEmptyCard(
              title: AppLocalizations.of(context).mainEmptyTitle,
              subtitle: AppLocalizations.of(context).mainEmptySubtitle,
              icon: Icons.account_balance_sharp,
            )
          : MainList(data: data),
    );
  }
}

class MainList extends StatelessWidget {
  final FullData data;

  const MainList({
    super.key,
    required this.data,
  });

  static const double margin = 20.0;

  @override
  Widget build(BuildContext context) {
    final double totalValue =
        data.allItems.fold(0, (a, b) => a + b.price * b.quantity);

    final bool longWidth = MediaQuery.of(context).size.width > 400;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: double.infinity,
              margin: const EdgeInsets.all(margin),
              width: longWidth ? 30 : 20,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10),
              ),
              child: VerticalProgressBar(data: data, totalValue: totalValue),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  right: margin,
                  top: margin,
                  // On Android the FAB may get on top of it.
                  bottom: 6 * margin,
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsList extends StatelessWidget {
  final FullData data;

  const ItemsList(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<ItemData> sortedItems;
    if (data.settings.sortBy == 0) {
      sortedItems = data.allItems..sort((a, b) => b.price.compareTo(a.price));
    } else {
      sortedItems = data.allItems..sort((a, b) => a.name.compareTo(b.name));
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
                data.walletsMap[sortedItems[i].walletId]?.colorName ?? 'gray',
                data.settings.currencySymbol,
              ),
            ),
          if (i < sortedItems.length - 1)
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.10),
            ),
        ],
      ],
    );
  }
}
