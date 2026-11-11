import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/page_home/details_page.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              sections:
                  _showingSections(nonZeroWallets, widget.data.totalValue),
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
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? touchedPalette.s300
                                  : touchedPalette.s700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.data.settings.currencySymbol}${toCurrency(touchedWallet.totalValue)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 11,
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
                            'Total',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.data.settings.currencySymbol}${toCurrency(widget.data.totalValue)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 11,
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
            title: '${percent.toStringAsFixed(0)}%',
            radius: isTouched ? 54 : 48,
            titleStyle: GoogleFonts.rubik(
              fontSize: isTouched ? 15 : 13,
              fontWeight: FontWeight.w700,
              color: sliceColor.highContrastOnColor,
            ),
          );
        }(),
    ];
  }
}
