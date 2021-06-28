import 'package:beamer/beamer.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final FullData data;

  const CustomPieChart(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            if (pieTouchResponse.touchInput is PointerExitEvent ||
                pieTouchResponse.touchInput is PointerUpEvent) {
              final touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;

              if (touchedIndex > -1) {
                final groupId = data.groupsMap.keys.toList()[touchedIndex];
                Beamer.of(context).beamToNamed("/editGroup/$groupId");
              }
            }
          }),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: showingSections(data),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(FullData data) {
    return data.groupsMap.values.map((groupData) {
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

    // return List.generate(4, (i) {
    //   final isTouched = i == touchedIndex;
    //   final fontSize = isTouched ? 20.0 : 16.0;
    //   final radius = isTouched ? 55.0 : 50.0;
    //   switch (i) {
    //     case 0:
    //       return PieChartSectionData(
    //         color: const Color(0xff0293ee),
    //         value: 40,
    //         title: '40%',
    //         radius: radius,
    //         titleStyle: TextStyle(
    //           fontSize: fontSize,
    //           fontWeight: FontWeight.bold,
    //           color: const Color(0xffffffff),
    //         ),
    //       );
    //     case 1:
    //       return PieChartSectionData(
    //         color: const Color(0xfff8b250),
    //         value: 30,
    //         title: '30%',
    //         radius: radius,
    //         titleStyle: TextStyle(
    //             fontSize: fontSize,
    //             fontWeight: FontWeight.bold,
    //             color: const Color(0xffffffff)),
    //       );
    //     case 2:
    //       return PieChartSectionData(
    //         color: const Color(0xff845bef),
    //         value: 15,
    //         title: '15%',
    //         radius: radius,
    //         titleStyle: TextStyle(
    //             fontSize: fontSize,
    //             fontWeight: FontWeight.bold,
    //             color: const Color(0xffffffff)),
    //       );
    //     case 3:
    //       return PieChartSectionData(
    //         color: const Color(0xff13d38e),
    //         value: 15,
    //         title: '15%',
    //         radius: radius,
    //         titleStyle: TextStyle(
    //             fontSize: fontSize,
    //             fontWeight: FontWeight.bold,
    //             color: const Color(0xffffffff)),
    //       );
    //     default:
    //       throw Error();
    //   }
    // });
  }
}
