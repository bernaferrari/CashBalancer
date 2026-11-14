import '../util/numbers.dart';
import '../l10n/l10n.dart';

import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';

class const PieChartSection(final FullData data, {super.key})
    extends StatefulWidget {
  @override
  State<PieChartSection> createState() => _PieChartSectionState();
}

class _PieChartSectionState extends State<PieChartSection> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nonZeroWallets = widget.data.walletsMap.values
        .where((groupData) => groupData.totalValue > 0)
        .toList();

    final touchedWallet =
        (_touchedIndex >= 0 && _touchedIndex < nonZeroWallets.length)
        ? nonZeroWallets[_touchedIndex]
        : null;
    final touchedPalette = touchedWallet != null
        ? tailwindPalette(touchedWallet.colorName)
        : null;

    return SizedBox(
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 56,
              sections: _showingSections(
                nonZeroWallets,
                widget.data.totalValue,
              ),
            ),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          ),
          IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: touchedWallet != null && touchedPalette != null
                  ? SizedBox(
                      key: ValueKey('touched-${touchedWallet.id}'),
                      width: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            touchedWallet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? touchedPalette.s300
                                  : touchedPalette.s700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            money(
                              context,
                              widget.data.settings.currencySymbol,
                              touchedWallet.totalValue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      key: const ValueKey('idle-total'),
                      width: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.total,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            money(
                              context,
                              widget.data.settings.currencySymbol,
                              widget.data.totalValue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
    List<WalletData> nonZeroWallets,
    double totalValue,
  ) {
    if (totalValue <= 0) return const [];

    return [
      for (int i = 0; i < nonZeroWallets.length; i++)
        () {
          final groupData = nonZeroWallets[i];
          final isTouched = i == _touchedIndex;
          final double percent = groupData.totalValue / totalValue * 100;
          final sliceColor = tailwindPalette(groupData.colorName).s500;
          return PieChartSectionData(
            color: sliceColor,
            value: percent,
            title:
                '${formatPercent(percent.roundToDouble(), Localizations.localeOf(context).toString())}%',
            radius: isTouched ? 54 : 48,
            titleStyle: TextStyle(
              fontFamily: 'Rubik',
              fontSize: isTouched ? 15 : 13,
              fontWeight: FontWeight.w700,
              color: sliceColor.highContrastOnColor,
            ),
          );
        }(),
    ];
  }
}
