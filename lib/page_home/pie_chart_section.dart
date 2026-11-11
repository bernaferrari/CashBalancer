import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class const PieChartSection(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: showingSections(data),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(FullData data) {
    if (data.totalValue <= 0) return const [];

    return data.walletsMap.values
        .where((groupData) => groupData.totalValue > 0)
        .map((groupData) {
      final double percent = groupData.totalValue / data.totalValue * 100;
      return PieChartSectionData(
        color: tailwindColors[groupData.colorName]![500]!,
        value: percent,
        title: '${percent.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      );
    }).toList();
  }
}
