import '../widgets/quick_price.dart';
import '../util/numbers.dart';

import 'package:beamer/beamer.dart';
import 'package:cash_balancer/page_home/pie_chart_section.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../util/retrieve_spaced_list.dart';
import '../util/tailwind_colors.dart';
import '../widgets/circle_percentage_painter.dart';
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

class const HomePageImpl(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: context.l10n.portfolios,
          onPressed: () {
            showDialog<Object>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<DataCubit>(),
                child: const PortfoliosDialog(),
              ),
            );
          },
          icon: Icon(
            Icons.bookmarks_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.userName.isEmpty
                  ? context.l10n.defaultPortfolio
                  : data.userName,
            ),
            Text(
              money(context, data.settings.currencySymbol, data.totalValue),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          if (data.allItems.isNotEmpty)
            IconButton(
              tooltip: context.l10n.rebalanceCalculator,
              onPressed: () => Beamer.of(context).beamToNamed('/rebalance'),
              icon: Icon(
                Icons.calculate_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          IconButton(
            tooltip: context.l10n.settings,
            onPressed: () => Beamer.of(context).beamToNamed('/settings'),
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Beamer.of(context).beamToNamed("/addWallet/${data.userId}"),
        label: Text(
          context.l10n.addWallet,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
      ),
      body: data.walletsMap.isEmpty
          ? WhenEmptyCard(
              title: context.l10n.mainEmptyTitle,
              subtitle: context.l10n.mainEmptySubtitle,
              icon: Icons.account_balance_sharp,
              action: OutlinedButton.icon(
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text(context.l10n.loadSamplePortfolio),
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
            )
          : PortfolioSplitView(
              data: data,
              children: [
                if (data.hasIncompleteTargets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.l10n.targetTotalWarning,
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (data.allItems.isNotEmpty && data.totalValue > 0) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      PieChartSection(data),
                      Center(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            Beamer.of(context).beamToNamed("/analysis");
                          },
                          icon: const Icon(Icons.bar_chart_rounded, size: 16),
                          label: Text(
                            "${context.l10n.allItems} (${data.allItems.length})",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                ],
                Column(
                  spacing: 20,
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
              ],
            ),
    );
  }
}

class const PortfolioSplitView({
  super.key,
  required final FullData data,
  required final List<Widget> children,
}) extends StatelessWidget {
  static const double margin = 20.0;

  @override
  Widget build(BuildContext context) {
    final bool longWidth = MediaQuery.sizeOf(context).width > 400;

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
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: 0.10),
              ),
              child: VerticalProgressBar(data: data),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  right: margin,
                  top: margin,
                  // On Android the FAB may get on top of it.
                  bottom: 6 * margin,
                ),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const VerticalProgressBar({required final FullData data, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<ItemData> nonZeroItems = data.allItems
            .where((element) => element.totalValue > 0)
            .toList();

        final spacing = nonZeroItems.length > constraints.maxHeight / 2
            ? 0.0
            : 2.0;
        final spacedList = spacing > 0
            ? retrieveSpacedList(nonZeroItems, constraints.maxHeight)
            : nonZeroItems
                  .map(
                    (item) =>
                        constraints.maxHeight *
                        (item.totalValue / data.totalValue),
                  )
                  .toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          children: [
            for (int i = 0; i < nonZeroItems.length; i++)
              () {
                final item = nonZeroItems[i];
                final percent = data.totalValue > 0
                    ? (item.totalValue / data.totalValue).toPercent(
                        Localizations.localeOf(context).toString(),
                      )
                    : '0';
                return Tooltip(
                  key: ValueKey(item.id),
                  message:
                      '${item.name} • ${money(context, data.settings.currencySymbol, item.totalValue)} ($percent%)',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    height: spacedList[i],
                    color: item.color,
                  ),
                );
              }(),
          ],
        );
      },
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
  // Make it reusable.
  Widget customContainer({
    required Widget child,
    required TailwindPalette palette,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDark
              ? palette.s500.withValues(alpha: 0.28)
              : palette.s500.withValues(alpha: 0.30),
          width: 1.2,
        ),
        color: isDark
            ? palette.s950.withValues(alpha: 0.45)
            : palette.s50.withValues(alpha: 0.65),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = tailwindPalette(group.colorName);
    final color = palette.s500;
    final accentText = isDark ? palette.s300 : palette.s700;

    if (itemsList == null) {
      return customContainer(
        context: context,
        palette: palette,
        child: WalletCard(
          title: group.name,
          subtitle: context.l10n.pressToAdd,
          accentColor: color,
          widget: Row(
            spacing: 8,
            children: [
              EditWallet(color: accentText, groupId: group.id),
              AddItem(color: color, groupId: group.id),
            ],
          ),
        ),
      );
    } else {
      final double totalLocalPercent = allTotalValue > 0
          ? (group.totalValue / allTotalValue) * 100
          : 0;

      return customContainer(
        context: context,
        palette: palette,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WalletCard(
              title: group.name,
              subtitle:
                  "${context.l10n.total}: ${money(context, settings.currencySymbol, group.totalValue)}",
              accentColor: color,
              widget: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  EditWallet(color: accentText, groupId: group.id),
                  AddItem(color: color, groupId: group.id),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Column(
              spacing: 6,
              children: [
                for (int i = 0; i < itemsList!.length; i++)
                  SizedBox(
                    width: double.infinity,
                    child: ItemCard(
                      itemsList![i],
                      settings.relativeTarget
                          ? group.totalValue
                          : allTotalValue,
                      settings.currencySymbol,
                      buyOnlyTotalValue: buyOnlyItemsTotal,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (group.targetPercent != -1) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PercentArrow(
                        itemValue: group.totalValue,
                        totalValue: allTotalValue,
                        targetPercent: group.targetPercent,
                      ),
                      const SizedBox(height: 4),
                      UpDownDiffText(
                        currencySymbol: settings.currencySymbol,
                        itemValue: group.totalValue,
                        targetPercent: group.targetPercent,
                        totalValue: allTotalValue,
                        buyOnlyTotalValue: buyOnlyWalletTotal,
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      children: [
                        Center(
                          child: CircularProgress(
                            totalLocalPercent: totalLocalPercent,
                            color: palette.s500,
                            hasText: false,
                          ),
                        ),
                        Center(
                          child: CircularProgress(
                            totalLocalPercent: group.targetPercent,
                            color: isDark ? palette.s300 : palette.s700,
                            size: 25,
                            hasText: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else
                  CircularProgress(
                    totalLocalPercent: totalLocalPercent,
                    color: color,
                  ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class const AddItem({
  super.key,
  required final Color color,
  required final int groupId,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.addAsset,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: color.highContrastOnColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size(52, 48),
        ),
        child: const Icon(Icons.add_rounded, size: 20),
        onPressed: () => Beamer.of(context).beamToNamed('/addItem/$groupId'),
      ),
    );
  }
}

class const EditWallet({
  super.key,
  required final Color color,
  required final int groupId,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.editWallet,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.35)),
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size(38, 38),
        ),
        child: const Icon(Icons.edit_rounded, size: 17),
        onPressed: () => Beamer.of(context).beamToNamed("/editWallet/$groupId"),
      ),
    );
  }
}

class const CircularProgress({
  super.key,
  required final double totalLocalPercent,
  required final Color color,
  final double size = 40,
  final bool hasText = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      // StrokeWidth is 3.
      padding: const EdgeInsets.all(3),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: totalLocalPercent),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (context, animatedPercent, _) {
          return CustomPaint(
            isComplex: false,
            painter: CirclePercentagePainter(
              percent: (animatedPercent / 100).clamp(0.0, 1.0),
              color: color,
              circleColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.onSurface
                  .withValues(alpha: 0.15),
            ),
            child: hasText
                ? Center(
                    child: Text(
                      "${animatedPercent.toStringAsFixed(0)}%",
                      style: Theme.of(context).textTheme.labelSmall!
                          .copyWith(fontSize: 12),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class const WalletCard({
  super.key,
  required final String title,
  required final String subtitle,
  required final Color accentColor,
  final Widget? widget,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            spacing: 10,
            children: [
              Container(
                width: 10,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ?widget,
      ],
    );
  }
}

class const ItemCard(
  final ItemData item,
  final double totalValue,
  final String currencySymbol, {
  final double? buyOnlyTotalValue,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double itemValue = item.totalValue;
    final double ratio = totalValue > 0 ? itemValue / totalValue : 0;
    final String qtyPrefix = item.quantity != 1
        ? '${formatQuantity(context, item.quantity)}× • '
        : '';

    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              backgroundColor: isDark
                  ? item.color.withValues(alpha: 0.12)
                  : item.color.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Beamer.of(context).beamToNamed('/editItem/${item.id}');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 4,
                  height: 38,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: item.color,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.targetPercent != -1)
                            PercentArrow(
                              itemValue: itemValue,
                              totalValue: totalValue,
                              targetPercent: item.targetPercent,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      UpDownDiffText(
                        currencySymbol: currencySymbol,
                        itemValue: itemValue,
                        targetPercent: item.targetPercent,
                        totalValue: totalValue,
                        buyOnlyTotalValue: buyOnlyTotalValue,
                        leftWidget: Expanded(
                          child: Text(
                            "$qtyPrefix${money(context, currencySymbol, itemValue)} (${ratio.toPercent(Localizations.localeOf(context).toString())}%)",
                            style: TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        QuickPriceButton(item),
      ],
    );
  }
}

class const PercentArrow({
  required final double itemValue,
  required final double totalValue,
  required final double targetPercent,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double ratio = totalValue > 0 ? itemValue / totalValue : 0;

    return Row(
      children: [
        Text(
          "${ratio.toPercent(Localizations.localeOf(context).toString())}%",
          style: TextStyle(
            fontFamily: 'IBM Plex Mono',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          "${formatPercent(targetPercent, Localizations.localeOf(context).toString())}%",
          style: TextStyle(
            fontFamily: 'IBM Plex Mono',
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class const UpDownDiffText({
  required final String currencySymbol,
  required final double itemValue,
  required final double targetPercent,
  required final double totalValue,
  final double? buyOnlyTotalValue,
  final Widget? leftWidget,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greenColor = isDark
        ? TailwindColor.green.palette.s400
        : TailwindColor.green.palette.s700;
    final redColor = isDark
        ? TailwindColor.rose.palette.s400
        : TailwindColor.red.palette.s600;

    final double currentRatio = totalValue > 0 ? itemValue / totalValue : 0;
    final double targetRatio = targetPercent / 100;

    if (buyOnlyTotalValue != null) {
      final double buyNeeded = (buyOnlyTotalValue! * targetRatio - itemValue)
          .clamp(0.0, double.infinity);
      final bool isHold = buyNeeded < 0.005;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ?leftWidget,
          if (targetPercent != -1)
            Text(
              isHold
                  ? "✓ ${context.l10n.hold} (${money(context, currencySymbol, 0)})"
                  : "↑ ${money(context, currencySymbol, buyNeeded)} (+${(targetRatio - currentRatio).abs().toPercent(Localizations.localeOf(context).toString())}%)",
              style: TextStyle(
                fontFamily: 'Fira Sans',
                color: isHold
                    ? Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: 0.55)
                    : greenColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      );
    }

    final bool isUnderOrEqual = targetRatio >= currentRatio;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ?leftWidget,
        if (targetPercent != -1)
          Text(
            "${isUnderOrEqual ? "↑" : "↓"} ${money(context, currencySymbol, totalValue * targetRatio - itemValue)} (${(targetRatio - currentRatio).toPercent(Localizations.localeOf(context).toString())}%)",
            style: TextStyle(
              fontFamily: 'Fira Sans',
              color: isUnderOrEqual ? greenColor : redColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
