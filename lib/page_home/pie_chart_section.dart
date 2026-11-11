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
    final nonZeroWallets = widget.data.walletsMap.values
        .where((groupData) => groupData.totalValue > 0)
        .toList();

    final touchedWallet =
        (_touchedIndex >= 0 && _touchedIndex < nonZeroWallets.length)
            ? nonZeroWallets[_touchedIndex]
            : null;

    return SizedBox(
      height: 200,
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
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: _showingSections(nonZeroWallets, widget.data.totalValue),
            ),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          ),
          IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: touchedWallet != null
                  ? SizedBox(
                      key: ValueKey(touchedWallet.id),
                      width: 92,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            touchedWallet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rubik(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color:
                                  tailwindColors[touchedWallet.colorName]![500],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.data.settings.currencySymbol}${toCurrency(touchedWallet.totalValue)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
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
          return PieChartSectionData(
            color: tailwindColors[groupData.colorName]![500]!,
            value: percent,
            title: '${percent.toStringAsFixed(0)}%',
            radius: isTouched ? 56 : 50,
            titleStyle: TextStyle(
              fontSize: isTouched ? 17 : 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        }(),
    ];
  }
}
