import 'dart:math' as math;

import '../widgets/quick_price.dart';
import '../util/numbers.dart';

import 'package:beamer/beamer.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/theme.dart';
import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../util/wallet_colors.dart';
import '../widgets/ledger.dart';
import '../widgets/when_empty_card.dart';
import 'portfolios_dialog.dart';

class const HomePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(
      builder: (context, state) {
        if (state == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return HomePageImpl(state);
        }
      },
    );
  }
}

/// How much to buy (positive) or sell (negative) to land on [targetPercent],
/// or null when there is no target.
double? targetDelta({
  required double value,
  required double total,
  required double targetPercent,
  double? buyOnlyTotal,
}) {
  if (targetPercent < 0) return null;
  if (buyOnlyTotal != null) {
    return (buyOnlyTotal * targetPercent / 100 - value).clamp(
      0.0,
      double.infinity,
    );
  }
  return total * targetPercent / 100 - value;
}

class const HomePageImpl(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = data.userName.isEmpty
        ? context.l10n.defaultPortfolio
        : data.userName;
    final edge = PortfolioSplitView.contentEdge(
      MediaQuery.sizeOf(context).width,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: edge - 12,
        title: Tooltip(
          message: context.l10n.portfolios,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
            ),
            onPressed: () => showPortfolios(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Icon(
                  Icons.expand_more_rounded,
                  size: 22,
                  color: context.ledger.muted,
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.settings,
            onPressed: () => Beamer.of(context).beamToNamed('/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
          SizedBox(width: edge - 13),
        ],
      ),
      floatingActionButton: data.walletsMap.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () =>
                  Beamer.of(context).beamToNamed("/addWallet/${data.userId}"),
              label: Text(context.l10n.addWallet),
              icon: const Icon(Icons.add_rounded),
            ),
      body: data.walletsMap.isEmpty
          ? WhenEmptyCard(
              title: context.l10n.mainEmptyTitle,
              subtitle: context.l10n.mainEmptySubtitle,
              action: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () =>
                        Beamer.of(context)
                            .beamToNamed("/addWallet/${data.userId}"),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: Text(context.l10n.addWallet),
                  ),
                  SamplePortfolioTile(
                    onPressed: () {
                      context.read<DataCubit>().db.seedSamplePortfolio(
                        data.userId,
                        stocks: context.l10n.sampleStocks,
                        crypto: context.l10n.sampleCrypto,
                        cash: context.l10n.sampleCash,
                        savings: context.l10n.sampleSavings,
                        relative: data.settings.relativeTarget,
                      );
                    },
                  ),
                ],
              ),
            )
          : PortfolioSplitView(
              header: HomeHero(data),
              listHeader: WalletsHeader(data),
              children: [
                for (final group in data.walletsMap.values)
                  GroupCard(
                    itemsList: data.walletsItems[group.id],
                    group: group,
                    allTotalValue: data.totalValue,
                    buyOnlyWalletTotal: data.settings.buyOnly
                        ? data.buyOnlyTotalForWallets
                        : null,
                    buyOnlyItemsTotal: data.settings.buyOnly
                        ? data.buyOnlyTotalForItems(group.id)
                        : null,
                    settings: data.settings,
                  ),
              ],
            ),
    );
  }
}

/// The portfolio at a glance: the total, where it is and where it should be.
class const HomeHero(final FullData data, {super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final total = data.totalValue;
    final wallets = data.walletsMap.values.toList();
    final locale = Localizations.localeOf(context).toString();
    final hasTargets = wallets.any((w) => w.targetPercent > 0);
    final hasItems = data.allItems.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            context.l10n.total.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: l.muted),
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          container: true,
          headingLevel: 1,
          child: HeroAmount(
            money(context, data.settings.currencySymbol, total),
          ),
        ),
        if (total > 0) ...[
          const SizedBox(height: 22),
          AllocationBars([
            (
              context.l10n.now,
              [
                for (final w in wallets)
                  (
                    id: w.id,
                    color: walletSeed(w.colorName),
                    value: w.totalValue / total * 100,
                  ),
              ],
            ),
            if (hasTargets)
              (
                context.l10n.dialogAssetTarget,
                [
                  for (final w in wallets)
                    (
                      id: w.id,
                      color: walletSeed(w.colorName),
                      value: w.targetPercent.clamp(0.0, 100.0),
                    ),
                ],
              ),
          ]),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              for (final w in wallets)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: walletSeed(w.colorName),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      w.name,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      (w.totalValue / total).toPercent(locale),
                      style: figures(12, color: l.muted),
                    ),
                  ],
                ),
            ],
          ),
        ],
        if (hasItems) ...[
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () => Beamer.of(context).beamToNamed('/rebalance'),
            icon: const Icon(Icons.balance_rounded, size: 19),
            label: Text(context.l10n.rebalanceCalculator),
          ),
        ],
      ],
    );
  }
}

/// "Wallets", with a shortcut to every asset in one list.
class const WalletsHeader(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final count = data.allItems.length;
    return SectionLabel(
      context.l10n.walletsLabel,
      trailing: count == 0
          ? null
          : TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                foregroundColor: l.ink,
                textStyle: Theme.of(context).textTheme.titleSmall,
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
              onPressed: () => Beamer.of(context).beamToNamed('/analysis'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.allItems),
                  const SizedBox(width: 6),
                  Text('$count', style: figures(12.5, color: l.muted)),
                  Icon(Icons.chevron_right_rounded, size: 18, color: l.muted),
                ],
              ),
            ),
    );
  }
}

/// One column on phones; on wide windows the [header] gets its own column.
class const PortfolioSplitView({
  super.key,
  required final Widget header,
  required final List<Widget> children,
  final Widget? listHeader,
}) extends StatelessWidget {
  static const double _margin = 20;
  static const double _wide = 920;

  /// Where the content starts horizontally, so chrome above it can line up.
  static double contentEdge(double width) => width >= _wide
      ? math.max(0, (width - 1080) / 2) + 32
      : math.max(0, (width - 600) / 2) + _margin;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= _wide) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 380,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(32, 28, 16, 32),
                  children: [header],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 32, 120),
                  children: [
                    ?listHeader,
                    for (final child in children)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: child,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(_margin, 8, _margin, 120),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 28),
              child: header,
            ),
            ?listHeader,
            for (final child in children)
              Padding(padding: const EdgeInsets.only(bottom: 14), child: child),
          ],
        ),
      ),
    );
  }
}

class const GroupCard({
  super.key,
  required final List<ItemData>? itemsList,
  required final WalletData group,
  required final double allTotalValue,
  final double? buyOnlyWalletTotal,
  final double? buyOnlyItemsTotal,
  required final SettingsData settings,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final color = WalletColor.fromName(group.colorName);
    final share = allTotalValue > 0 ? group.totalValue / allTotalValue : 0.0;
    final hasTarget = group.targetPercent >= 0;
    final delta = targetDelta(
      value: group.totalValue,
      total: allTotalValue,
      targetPercent: group.targetPercent,
      buyOnlyTotal: buyOnlyWalletTotal,
    );
    final items = itemsList ?? const <ItemData>[];

    return SegmentedColumn(
      children: [
        Semantics(
          container: true,
          button: true,
          label: context.l10n.editWallet,
          child: InkWell(
            onTap: () =>
                Beamer.of(context).beamToNamed('/editWallet/${group.id}'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      AssetMark(
                        color: color.seed,
                        sell: delta != null && delta <= -0.005,
                        width: 4,
                        height: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                group.name.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: display(
                                  17,
                                  weight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: l.faint,
                            ),
                          ],
                        ),
                      ),
                      AddItem(color: color, groupId: group.id),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        money(
                          context,
                          settings.currencySymbol,
                          group.totalValue,
                        ),
                        style: figures(
                          14,
                          weight: FontWeight.w600,
                          color: l.ink,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ShareText(
                          share: share,
                          targetPercent: hasTarget ? group.targetPercent : null,
                        ),
                      ),
                      if (delta != null && items.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: DeltaText(
                            delta: delta,
                            currency: settings.currencySymbol,
                          ),
                        ),
                    ],
                  ),
                  if (items.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: TargetMeter(
                        current: share,
                        target: hasTarget ? group.targetPercent / 100 : null,
                        color: color.seed,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Text(
              context.l10n.pressToAdd,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: l.muted),
            ),
          )
        else
          for (final item in items)
            ItemCard(
              item,
              settings.relativeTarget ? group.totalValue : allTotalValue,
              settings.currencySymbol,
              buyOnlyTotalValue: buyOnlyItemsTotal,
            ),
      ],
    );
  }
}

class const AddItem({
  super.key,
  required final WalletColor color,
  required final int groupId,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = color.scheme(Theme.of(context).brightness);
    return IconButton.filled(
      tooltip: context.l10n.addAsset,
      style: IconButton.styleFrom(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        fixedSize: const Size(38, 38),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.add_rounded, size: 22),
      onPressed: () => Beamer.of(context).beamToNamed('/addItem/$groupId'),
    );
  }
}

/// One holding as a ledger line: name and allocation on the left, value and
/// what to buy or sell on the right.
class const ItemCard(
  final ItemData item,
  final double totalValue,
  final String currencySymbol, {
  final double? buyOnlyTotalValue,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final double itemValue = item.totalValue;
    final double ratio = totalValue > 0 ? itemValue / totalValue : 0;
    final delta = targetDelta(
      value: itemValue,
      total: totalValue,
      targetPercent: item.targetPercent,
      buyOnlyTotal: buyOnlyTotalValue,
    );

    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(18, 12, 4, 12),
              shape: const RoundedRectangleBorder(),
              alignment: Alignment.centerLeft,
            ),
            onPressed: () =>
                Beamer.of(context).beamToNamed('/editItem/${item.id}'),
            child: Row(
              children: [
                AssetMark(
                  color: item.colorIn(context),
                  sell: delta != null && delta <= -0.005,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: l.ink),
                            ),
                          ),
                          if (!item.isBalance) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${formatQuantity(context, item.quantity)}×',
                              style: figures(12, color: l.faint),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      ShareText(
                        share: ratio,
                        targetPercent: item.targetPercent >= 0
                            ? item.targetPercent
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      money(context, currencySymbol, itemValue),
                      style: figures(
                        14.5,
                        weight: FontWeight.w600,
                        color: l.ink,
                      ),
                    ),
                    if (delta != null) ...[
                      const SizedBox(height: 3),
                      DeltaText(
                        delta: delta,
                        currency: currencySymbol,
                        size: 12.5,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: QuickPriceButton(item),
        ),
      ],
    );
  }
}
