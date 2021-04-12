import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/data_bloc.dart';
import 'database/database.dart';
import 'util/retrieve_spaced_list.dart';
import 'util/row_column_spacer.dart';
import 'util/tailwind_colors.dart';
import 'widgets/circle_percentage_painter.dart';
import 'widgets/input_dialog_group.dart';

extension Percent on double {
  String toPercent() => (this * 100).toStringAsFixed(0);
}

class DetailsPage extends StatelessWidget {
  final FullDataExtended data;
  final int id;

  const DetailsPage(this.id, this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Name'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog<dynamic>(
            context: context,
            builder: (_) => InputDialogGroup(
              onSavePressed: (text) {
                // Preserve the Bloc's context.
                BlocProvider.of<DataBloc>(context).db.createGroup(text);
              },
            ),
          );
        },
        label: Text("Add Group"),
        // TODO add Savings icon when available.
        icon: Icon(Icons.account_balance),
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
              data: data,
              isProportional: false,
            ),
          ),
          SingleChildScrollView(
            child: CardGroupDetails(data),
          ),
        ],
      ),
    );
  }
}

class VerticalProgressBar extends StatelessWidget {
  final FullDataExtended data;
  final bool isProportional;

  const VerticalProgressBar({
    required this.data,
    required this.isProportional,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<double> spacedList =
            retrieveSpacedList(data.fullData, constraints.maxHeight);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: spaceColumn(
            2,
            [
              for (int i = 0; i < data.fullData.length; i++)
                Tooltip(
                  message: "${data.fullData[i].item.name}",
                  child: Container(
                    width: double.infinity,
                    height: spacedList[i],
                    color: data.colors[i],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class CardGroupDetails extends StatelessWidget {
  final FullDataExtended data;

  const CardGroupDetails(this.data);

  @override
  Widget build(BuildContext context) {
    final double totalValue = data.fullData
        .map((d) => d.item.price * d.item.quantity)
        .fold(0.0, (previous, current) => previous + current);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: spaceColumn(
            20,
            data.groupedData.entries.map(
              (e) => IndividualItem(
                e.key,
                e.value
                  ..sort(
                    (a, b) => (b.item.price * a.item.quantity)
                        .compareTo(a.item.price * a.item.quantity),
                  ),
                totalValue,
                data.fullData[e.key].kind.color,
                data.colors,
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
  final int kind;
  final List<FullData> data;
  final double totalValue;
  final String colorType;
  final Map<FullData, Color> colors;

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
        .map((e) => e.item.price * e.item.quantity)
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
                      Text('kind',
                          style: Theme.of(context).textTheme.headline5),
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
  final FullData data;
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
                  data.item.name,
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
                      "R\$ ${data.item.price} (${(data.item.price / totalValue).toPercent()}%)",
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
          if (data.item.targetPercent > 0)
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      "${(data.item.price / totalValue).toPercent()}%",
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
                      "${data.item.targetPercent.toPercent()}%",
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
                  "${data.item.targetPercent > data.item.price / totalValue ? "↑" : "↓"} R\$ ${(totalValue * data.item.targetPercent - data.item.price).toStringAsFixed(0)} (${(data.item.targetPercent - data.item.price / totalValue).toPercent()}%)",
                  style: GoogleFonts.firaSans(
                    color:
                        data.item.targetPercent > data.item.price / totalValue
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

// class CardButton2 extends StatelessWidget {
//   final AssetData data;
//   final Color color;
//   final double totalValue;
//
//   const CardButton2(this.data, this.color, this.totalValue);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       style: TextButton.styleFrom(
//         padding: EdgeInsets.all(10.0),
//       ),
//       onPressed: () {},
//       child: Row(
//         children: [
//           Container(
//             width: 15,
//             height: 15,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: color,
//             ),
//           ),
//           SizedBox(width: 10),
//           Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data.name,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.subtitle2,
//                 ),
//                 Text(
//                   "R\$ ${data.price * data.quantity}",
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//               ],
//             ),
//           ),
//           Spacer(),
//           Text(
//             "${(100 * data.price * data.quantity / totalValue).toStringAsFixed(2)} %",
//             style: Theme.of(context).textTheme.bodyText2,
//           ),
//         ],
//       ),
//       // Row(
//       //   mainAxisSize: MainAxisSize.min,
//       //   children: [
//       //     // Text(
//       //     //   "R\$ ${data.price * data.quantity}",
//       //     //   style: Theme.of(context).textTheme.bodyText2,
//       //     // ),
//       //     SizedBox(width: 8),
//       //     if (false)
//       //       Stack(
//       //         children: [
//       //           Text(
//       //             "// ${(data.price * data.quantity / totalValue * 100).toStringAsFixed(2)}%",
//       //             style: Theme.of(context)
//       //                 .textTheme
//       //                 .bodyText2
//       //                 ?.copyWith(color: Colors.white.withOpacity(0.6)),
//       //           ),
//       //           Opacity(
//       //             opacity: 0,
//       //             child: Text(
//       //               "// 99.99%",
//       //               style: Theme.of(context)
//       //                   .textTheme
//       //                   .bodyText2
//       //                   ?.copyWith(color: Colors.white.withOpacity(0.6)),
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //   ],
//       // ),
//     );
//   }
// }

// class MiniNameDetails extends StatelessWidget {
//   final String title;
//   final Color color;
//
//   const MiniNameDetails(this.title, this.color);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 15,
//           height: 15,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: color,
//           ),
//         ),
//         SizedBox(width: 10),
//         Text(
//           title,
//           overflow: TextOverflow.ellipsis,
//           style: Theme.of(context).textTheme.bodyText2,
//         ),
//       ],
//     );
//   }
// }
