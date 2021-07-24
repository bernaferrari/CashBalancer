import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSection extends StatelessWidget {
  final FullData data;

  const PieChartSection(this.data, {Key? key}) : super(key: key);

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
    return data.walletsMap.values.map((groupData) {
      return PieChartSectionData(
        color: tailwindColors[groupData.colorName]![500]!,
        value: groupData.totalValue / data.totalValue * 100,
        title:
            '${(groupData.totalValue / data.totalValue * 100).toStringAsFixed(0)}%',
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
