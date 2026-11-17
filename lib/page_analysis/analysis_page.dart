import '../util/numbers.dart';
import '../util/wallet_colors.dart';

import 'package:beamer/beamer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../page_home/details_page.dart';
import '../widgets/ledger.dart';
import '../widgets/when_empty_card.dart';

class const AnalysisPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(
      builder: (context, state) {
        if (state == null) {
          return const SizedBox();
        } else {
          return DetailsPageImpl(state);
        }
      },
    );
  }
}

class const DetailsPageImpl(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sortedItems = [...data.allItems];
    if (data.settings.sortBy == 0) {
      sortedItems.sort((a, b) => b.totalValue.compareTo(a.totalValue));
    } else {
      sortedItems.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }
    final items = [
      for (final item in sortedItems)
        if (data.walletsMap.containsKey(item.walletId)) item,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.allItems),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Beamer.of(context).popToNamed('/');
          },
        ),
      ),
      body: items.isEmpty
          ? WhenEmptyCard(
              title: context.l10n.mainEmptyTitle,
              subtitle: context.l10n.mainEmptySubtitle,
            )
          : PortfolioSplitView(
              header: _ItemsHero(data, items),
              children: [
                SegmentedColumn(
                  children: [for (final item in items) _ShareRow(data, item)],
                ),
              ],
            ),
    );
  }
}

class const _ItemsHero(final FullData data, final List<ItemData> items)
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final total = data.totalValue;
    final hasTargets = items.any((i) => i.targetPercent > 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.total.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: context.ledger.muted),
        ),
        const SizedBox(height: 6),
        HeroAmount(money(context, data.settings.currencySymbol, total)),
        if (total > 0) ...[
          const SizedBox(height: 22),
          AllocationBars([
            (
              context.l10n.now,
              [
                for (final i in items)
                  (
                    id: i.id,
                    color: i.colorIn(context),
                    value: i.totalValue / total * 100,
                  ),
              ],
            ),
            if (hasTargets && !data.settings.relativeTarget)
              (
                context.l10n.dialogAssetTarget,
                [
                  for (final i in items)
                    (
                      id: i.id,
                      color: i.colorIn(context),
                      value: i.targetPercent.clamp(0.0, 100.0),
                    ),
                ],
              ),
          ]),
        ],
      ],
    );
  }
}

/// One holding with its share of the portfolio drawn against its target.
class const _ShareRow(final FullData data, final ItemData item)
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final currency = data.settings.currencySymbol;
    final basis = data.settings.relativeTarget
        ? data.walletsMap[item.walletId]?.totalValue ?? 0
        : data.totalValue;
    final share = basis > 0 ? item.totalValue / basis : 0.0;
    final hasTarget = item.targetPercent >= 0;
    final delta = targetDelta(
      value: item.totalValue,
      total: basis,
      targetPercent: item.targetPercent,
      buyOnlyTotal: data.settings.buyOnly
          ? data.buyOnlyTotalForItems(item.walletId)
          : null,
    );

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
        shape: const RoundedRectangleBorder(),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () => Beamer.of(context).beamToNamed('/editItem/${item.id}'),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: l.ink),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      money(context, currency, item.totalValue),
                      style: figures(
                        14.5,
                        weight: FontWeight.w600,
                        color: l.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TargetMeter(
                  current: share,
                  target: hasTarget ? item.targetPercent / 100 : null,
                  color: item.colorIn(context),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ShareText(
                        share: share,
                        targetPercent: hasTarget ? item.targetPercent : null,
                      ),
                    ),
                    if (delta != null)
                      DeltaText(delta: delta, currency: currency, size: 12.5),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, size: 20, color: l.faint),
        ],
      ),
    );
  }
}
