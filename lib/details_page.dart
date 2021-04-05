import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';
import 'tailwind_colors.dart';
import 'util/quartile.dart';
import 'util/row_column_spacer.dart';
import 'widgets/circle_percentage_painter.dart';

extension Percent on double {
  String toPercent() => (this * 100).toStringAsFixed(0);
}

class DetailsPage extends StatelessWidget {
  final String name;
  final List<AssetData> data;

  const DetailsPage(this.name, this.data);

  @override
  Widget build(BuildContext context) {
    final List<AssetData> sortedData = [...data]..sort((a, b) {
        return (b.price * b.quantity).compareTo((a.price * a.quantity));
      });

    final Map<String, List<AssetData>> groupedData = groupBy(sortedData);

    final colors = getColorByQuantile(groupedData, sortedData);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(name),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: double.infinity,
            margin: EdgeInsets.all(20),
            width: 30,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: VerticalProgressBar(
              data: sortedData,
              colors: colors,
              isProportional: false,
            ),
          ),
          SingleChildScrollView(
            child: CardGroupDetails(sortedData, groupedData, colors),
          ),
        ],
      ),
    );
  }
}

Map<AssetData, Color> getColorByQuantile(
  Map<String, List<AssetData>> groupedData,
  List<AssetData> data,
) {
  final Map<AssetData, Color> colors = {};

  for (var element in groupedData.entries) {
    final List<double> arr =
        element.value.map((e) => e.quantity * e.price).toList();

    final quartile25 = q25(arr);
    final quartile50 = q50(arr);
    final quartile75 = q75(arr);

    for (int i = 0; i < data.length; i++) {
      final currentData = data[i];

      final colorType = assetKinds[currentData.kind]!.color;
      if (currentData.price <= quartile25) {
        colors[currentData] = getColor(colorType)[200]!;
      } else if (currentData.price <= quartile50) {
        colors[currentData] = getColor(colorType)[300]!;
      } else if (currentData.price <= quartile75) {
        colors[currentData] = getColor(colorType)[400]!;
      } else {
        colors[currentData] = getColor(colorType)[500]!;
      }
    }
  }

  return colors;
}

class VerticalProgressBar extends StatelessWidget {
  final List<AssetData> data;
  final Map<AssetData, Color> colors;
  final bool isProportional;

  const VerticalProgressBar({
    required this.data,
    required this.colors,
    required this.isProportional,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<double> spacedList =
            retrieveSpacedList(data, constraints.maxHeight);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: spaceColumn(
            2,
            [
              for (int i = 0; i < data.length; i++)
                Tooltip(
                  message: "${data[i].name}",
                  child: Container(
                    width: double.infinity,
                    height: spacedList[i],
                    color: colors[data[i]]!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Map<String, List<AssetData>> groupBy(List<AssetData> data) {
  final groupedList = <String, List<AssetData>>{};

  for (int i = 0; i < data.length; i++) {
    final groupPosition = groupedList[data[i].kind];
    if (groupPosition != null) {
      groupPosition.add(data[i]);
    } else {
      groupedList[data[i].kind] = [data[i]];
    }
  }

  return groupedList;
}

class CardGroupDetails extends StatelessWidget {
  final List<AssetData> flatData;
  final Map<String, List<AssetData>> groupedData;
  final Map<AssetData, Color> colors;

  const CardGroupDetails(this.flatData, this.groupedData, this.colors);

  @override
  Widget build(BuildContext context) {
    final double totalValue = flatData
        .map((d) => d.price * d.quantity)
        .fold(0.0, (previous, current) => previous + current);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: spaceColumn(
            20,
            groupedData.entries.map(
              (e) => IndividualItem(
                e.key,
                e.value
                  ..sort(
                    (a, b) =>
                        (b.price * a.quantity).compareTo(a.price * a.quantity),
                  ),
                totalValue,
                assetKinds[e.key]!.color,
                colors,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Map<int, Color> getColor(String colorType) {
  return tailwindColors[colorType]!;
}

class IndividualItem extends StatelessWidget {
  final String kind;
  final List<AssetData> data;
  final double totalValue;
  final String colorType;
  final Map<AssetData, Color> colors;

  const IndividualItem(
    this.kind,
    this.data,
    this.totalValue,
    this.colorType,
    this.colors,
  );

  @override
  Widget build(BuildContext context) {
    final double totalLocalPrice = data
        .map((e) => e.price * e.quantity)
        .fold(0.0, (previous, current) => previous + current);

    final double totalLocalPercent = 100.0 * totalLocalPrice / totalValue;

    final localTailwindColor = getColor(colorType);

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: localTailwindColor[500]!.withOpacity(0.20),
        ),
        color: localTailwindColor[500]!.withOpacity(0.10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: spaceColumn(
          0.0,
          [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kind, style: Theme.of(context).textTheme.headline5),
                      Text(
                        "Total: R\$$totalLocalPrice",
                        style: Theme.of(context).textTheme.overline,
                      ),
                    ],
                  ),
                  Container(
                    width: true ? 40 : 80,
                    height: true ? 40 : 80,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: CustomPaint(
                      isComplex: false,
                      painter: CirclePercentagePainter(
                        percent: totalLocalPercent / 100,
                        color: localTailwindColor[500]!,
                        circleColor: Colors.transparent,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.15),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${totalLocalPercent.toStringAsFixed(0)}%",
                              style: Theme.of(context).textTheme.overline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (int i = 0; i < data.length; i++) ...[
              SizedBox(
                width: double.infinity,
                child: CardButton(
                  data[i],
                  colors[data[i]]!,
                  totalValue,
                ),
              ),
              if (i < data.length - 1)
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.10),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final AssetData data;
  final Color color;
  final double totalValue;

  const CardButton(this.data, this.color, this.totalValue);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(10.0),
        backgroundColor: color.withOpacity(0.05),
      ),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: GoogleFonts.firaSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "R\$ ${data.price} (${(data.price / totalValue).toPercent()}%)",
                      style: GoogleFonts.firaSans(
                        color: Color(0xbfffffff),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (data.targetPercent > 0)
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      "${(data.price / totalValue).toPercent()}%",
                      style: GoogleFonts.firaSans(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.50),
                      ),
                    ),
                    Text(
                      "${data.targetPercent.toPercent()}%",
                      style: GoogleFonts.firaSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFeatures: [
                          FontFeature.enable('calc'),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "${data.targetPercent > data.price / totalValue ? "↑" : "↓"} R\$ ${(totalValue * data.targetPercent - data.price).toStringAsFixed(0)} (${(data.targetPercent - data.price / totalValue).toPercent()}%)",
                  style: GoogleFonts.firaSans(
                    color: data.targetPercent > data.price / totalValue
                        ? Color(0xff77d874)
                        : Color(0xffff5a74),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CardButton2 extends StatelessWidget {
  final AssetData data;
  final Color color;
  final double totalValue;

  const CardButton2(this.data, this.color, this.totalValue);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(10.0),
      ),
      onPressed: () {},
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
          ),
          SizedBox(width: 10),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  "R\$ ${data.price * data.quantity}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            "${(100 * data.price * data.quantity / totalValue).toStringAsFixed(2)} %",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
      // Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     // Text(
      //     //   "R\$ ${data.price * data.quantity}",
      //     //   style: Theme.of(context).textTheme.bodyText2,
      //     // ),
      //     SizedBox(width: 8),
      //     if (false)
      //       Stack(
      //         children: [
      //           Text(
      //             "// ${(data.price * data.quantity / totalValue * 100).toStringAsFixed(2)}%",
      //             style: Theme.of(context)
      //                 .textTheme
      //                 .bodyText2
      //                 ?.copyWith(color: Colors.white.withOpacity(0.6)),
      //           ),
      //           Opacity(
      //             opacity: 0,
      //             child: Text(
      //               "// 99.99%",
      //               style: Theme.of(context)
      //                   .textTheme
      //                   .bodyText2
      //                   ?.copyWith(color: Colors.white.withOpacity(0.6)),
      //             ),
      //           ),
      //         ],
      //       ),
      //   ],
      // ),
    );
  }
}

class MiniNameDetails extends StatelessWidget {
  final String title;
  final Color color;

  const MiniNameDetails(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color,
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
