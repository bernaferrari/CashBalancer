import 'package:beamer/beamer.dart';
import 'package:cash_balancer/page_home/pie_chart_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../util/retrieve_spaced_list.dart';
import '../util/tailwind_colors.dart';
import '../widgets/circle_percentage_painter.dart';
import '../widgets/when_empty_card.dart';

class const HomePage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(builder: (context, state) {
      if (state == null) {
        return const SizedBox();
      } else {
        return HomePageImpl(state);
      }
    });
  }
}

class const HomePageImpl(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.appTitle,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
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
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: data.walletsMap.isEmpty
          ? WhenEmptyCard(
              title: context.l10n.mainEmptyTitle,
              subtitle: context.l10n.mainEmptySubtitle,
              icon: Icons.account_balance_sharp,
            )
          : PortfolioSplitView(
              data: data,
              children: [
                if (data.allItems.isNotEmpty && data.totalValue > 0) ...[
                  TextButton(
                    onPressed: () {
                      Beamer.of(context).beamToNamed("/analysis");
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        PieChartSection(data),
                        Text(
                          "Total: ${data.settings.currencySymbol} ${toCurrency(data.totalValue)}",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 40),
                ],
                Column(
                  spacing: 20,
                  children: [
                    for (final group in data.walletsMap.values)
                      GroupCard(
                        itemsList: data.walletsItems[group.id],
                        group: group,
                        allTotalValue: data.totalValue,
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
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
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

class const VerticalProgressBar({
  required final FullData data,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<ItemData> nonZeroItems =
            data.allItems.where((element) => element.price > 0).toList();

        final List<double> spacedList =
            retrieveSpacedList(nonZeroItems, constraints.maxHeight);

        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            for (int i = 0; i < nonZeroItems.length; i++)
              () {
                final item = nonZeroItems[i];
                final percent = data.totalValue > 0
                    ? (item.price / data.totalValue * 100).toStringAsFixed(1)
                    : '0';
                return Tooltip(
                  key: ValueKey(item.id),
                  message:
                      '${item.name} • ${data.settings.currencySymbol} ${toCurrency(item.price)} ($percent%)',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    height: spacedList[i],
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.color,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        fixedSize: Size(100, spacedList[i]),
                        shape: const RoundedRectangleBorder(),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          Beamer.of(context).beamToNamed('/editItem/${item.id}'),
                      child: const SizedBox.expand(),
                    ),
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
  required final SettingsData settings,
}) extends StatelessWidget {
  // Make it reusable.
  Widget customContainer({
    required Widget child,
    required Color color,
    required BuildContext context,
  }) =>
      Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: color.withValues(alpha: 0.20)),
          color: Theme.of(context).brightness == Brightness.dark
              ? color.withValues(alpha: 0.10)
              : color.withValues(alpha: 0.05),
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final Map<int, Color> localTailwindColor = tailwindColors[group.colorName]!;
    final color = localTailwindColor[500]!;

    if (itemsList == null) {
      return customContainer(
        context: context,
        color: color,
        child: WalletCard(
          title: group.name,
          subtitle: context.l10n.pressToAdd,
          widget: Row(
            spacing: 8,
            children: [
              EditWallet(color: color, groupId: group.id),
              AddItem(color: color, groupId: group.id),
            ],
          ),
        ),
      );
    } else {
      final double totalLocalPercent =
          allTotalValue > 0 ? (group.totalValue / allTotalValue) * 100 : 0;

      return customContainer(
        context: context,
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WalletCard(
              title: group.name,
              subtitle:
                  "Total: ${settings.currencySymbol} ${toCurrency(group.totalValue)}",
              widget: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  EditWallet(color: color, groupId: group.id),
                  AddItem(color: color, groupId: group.id),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < itemsList!.length; i++) ...[
              SizedBox(
                width: double.infinity,
                child: ItemCard(
                  itemsList![i],
                  settings.relativeTarget ? group.totalValue : allTotalValue,
                  settings.currencySymbol,
                ),
              ),
              if (i < itemsList!.length - 1)
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withValues(alpha: 0.10),
                ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(child: SizedBox.shrink()),
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          children: [
                            Center(
                              child: CircularProgress(
                                totalLocalPercent: totalLocalPercent,
                                color: localTailwindColor[500]!,
                                hasText: false,
                              ),
                            ),
                            Center(
                              child: CircularProgress(
                                totalLocalPercent: group.targetPercent,
                                color: localTailwindColor[200]!,
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        fixedSize: const Size(64, 40),
      ),
      child: const Icon(Icons.add_rounded),
      onPressed: () => Beamer.of(context).beamToNamed('/addItem/$groupId'),
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
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        fixedSize: const Size(40, 40),
      ),
      child: const Icon(Icons.edit_rounded),
      onPressed: () => Beamer.of(context).beamToNamed("/editWallet/$groupId"),
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
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.15),
            ),
            child: hasText
                ? Center(
                    child: Text(
                      "${animatedPercent.toStringAsFixed(0)}%",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(fontSize: 8),
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
  final Widget? widget,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        ?widget,
      ],
    );
  }
}

extension Percent on double {
  String toPercent() => isFinite ? (this * 100).toStringAsFixed(0) : '0';
}

class const ItemCard(
  final ItemData item,
  final double totalValue,
  final String currencySymbol, {
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double ratio = totalValue > 0 ? item.price / totalValue : 0;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10.0),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? item.color.withValues(alpha: 0.05)
            : item.color.withValues(alpha: 0.25),
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
            margin: const EdgeInsets.only(right: 8),
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
                        style: GoogleFonts.firaSans(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.targetPercent != -1)
                      PercentArrow(
                        itemValue: item.price,
                        totalValue: totalValue,
                        targetPercent: item.targetPercent,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                UpDownDiffText(
                  currencySymbol: currencySymbol,
                  itemValue: item.price,
                  targetPercent: item.targetPercent,
                  totalValue: totalValue,
                  leftWidget: Expanded(
                    child: Text(
                      "$currencySymbol ${toCurrency(item.price)} (${ratio.toPercent()}%)",
                      style: GoogleFonts.firaSans(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
          "${ratio.toPercent()}%",
          style: GoogleFonts.firaSans(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.50),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.50),
          ),
        ),
        Text(
          "${targetPercent.toStringAsFixed(0)}%",
          style: GoogleFonts.firaSans(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFeatures: const [
              FontFeature.enable('calc'),
            ],
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
  final Widget? leftWidget,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final greenColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff77d874)
        : const Color(0xff2A8B27);

    final redColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xffff5a74)
        : const Color(0xffCC0020);

    final double currentRatio = totalValue > 0 ? itemValue / totalValue : 0;
    final double targetRatio = targetPercent / 100;
    final bool isUnderOrEqual = targetRatio >= currentRatio;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ?leftWidget,
        if (targetPercent != -1)
          Text(
            "${isUnderOrEqual ? "↑" : "↓"} $currencySymbol ${toCurrency(totalValue * targetRatio - itemValue)} (${(targetRatio - currentRatio).toPercent()}%)",
            style: GoogleFonts.firaSans(
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

String toCurrency(double value) => toCurrencyString(value.toString());
