import 'dart:ui';

import 'package:cash_balancer/details_screen/pie_chart_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import 'details_page.dart';

extension Percent on double {
  String toPercent() => (this * 100).toStringAsFixed(0);
}

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

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

  const DetailsPageImpl(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'All Items',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: (data.groupsMap.isEmpty == true)
          ? WhenEmptyCard(
              title: AppLocalizations.of(context).mainEmptyTitle,
              subtitle: AppLocalizations.of(context).mainEmptySubtitle,
              icon: Icons.account_balance_sharp,
            )
          : MainList(data: data),
    );
  }
}

class WhenEmptyCard extends StatelessWidget {
  const WhenEmptyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainList extends StatelessWidget {
  final FullData data;

  const MainList({
    Key? key,
    required this.data,
  }) : super(key: key);

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
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.10),
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
                  BarChart(data),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Total: ${data.settings.currencySymbol} ${toCurrency(data.totalValue)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
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

  const ItemsList(this.data, {Key? key}) : super(key: key);

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
          SizedBox(
            width: double.infinity,
            child: ItemCard(
              sortedItems[i],
              data.settings.relativeTarget
                  ? data.groupsMap[sortedItems[i].groupId]!.totalValue
                  : data.totalValue,
              data.groupsMap[sortedItems[i].groupId]!.colorName,
              data.settings.currencySymbol,
            ),
          ),
          if (i < sortedItems.length - 1)
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
            ),
        ],
      ],
    );
  }
}
