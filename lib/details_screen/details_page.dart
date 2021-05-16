import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/database.dart';
import '../l10n/l10n.dart';
import '../users_screen/users_screen.dart';
import '../util/retrieve_spaced_list.dart';
import '../util/row_column_spacer.dart';
import '../util/tailwind_colors.dart';
import '../widgets/circle_percentage_painter.dart';
import 'group_dialog.dart';
import 'item_dialog.dart';

extension Percent on double {
  String toPercent() => (this * 100).toStringAsFixed(0);
}

class DetailsPage extends StatelessWidget {
  const DetailsPage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: BlocProvider.of<DataBloc>(context).db.getDefaultUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final int userId = snapshot.data!;

            return StreamBuilder<DataExtended>(
                stream:
                    BlocProvider.of<DataBloc>(context).db.watchGroups(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData || !snapshot.hasError) {
                    return DetailsPageImpl(snapshot.data, userId);
                  } else if (snapshot.hasError) {
                    throw Exception(snapshot.error);
                  } else {
                    return Center(child: Text("Loading..."));
                  }
                });
          } else if (snapshot.hasError) {
            throw Exception(snapshot.error);
          } else {
            return SizedBox();
          }
        });
  }
}

class DetailsPageImpl extends StatelessWidget {
  final DataExtended? data;
  final int userId;

  const DetailsPageImpl(this.data, this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Cash Balancer',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog<Object>(
            context: context,
            builder: (_) => GroupDialog(
              onSavePressed: (text, colorName) {
                // Preserve the Bloc's context.
                BlocProvider.of<DataBloc>(context)
                    .db
                    .createGroup(text, colorName);
              },
            ),
          );
        },
        label: Text(
          "Add Group",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: (data == null || data!.groupsMap.isEmpty == true)
          ? WhenEmptyCard(
              title: AppLocalizations.of(context)!.mainEmptyTitle,
              subtitle: AppLocalizations.of(context)!.mainEmptySubtitle,
              icon: Icons.account_balance_sharp,
            )
          : Row(
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.10),
                  ),
                  child: VerticalProgressBar(
                    data: data!,
                    isProportional: false,
                  ),
                ),
                SingleChildScrollView(child: CardGroupDetails(data!, userId)),
              ],
            ),
    );
  }
}

class VerticalProgressBar extends StatelessWidget {
  final DataExtended data;
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
            retrieveSpacedList(data.itemsList, constraints.maxHeight);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: spaceColumn(
            2,
            [
              for (int i = 0; i < data.itemsList.length; i++)
                Tooltip(
                  message: "${data.itemsList[i].name}",
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: data.colorsMap[data.itemsList[i]],
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      fixedSize: Size(100, spacedList[i]),
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      showDialog<Object>(
                        context: context,
                        builder: (_) => ItemDialog(
                          colorName:
                              data.groupsMap[data.itemsList[i].groupId]!.color,
                          previousItem: data.itemsList[i],
                          onSavePressed: (name, value, target) {
                            // Preserve the Bloc's context.
                            context.read<DataBloc>().db.updateItem(
                                data.itemsList[i], name, value, target);
                          },
                          onDeletePressed: () => context
                              .read<DataBloc>()
                              .db
                              .deleteItem(data.itemsList[i]),
                        ),
                      );
                    },
                    child: SizedBox.shrink(),
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
  final DataExtended data;
  final int userId;

  const CardGroupDetails(this.data, this.userId);

  @override
  Widget build(BuildContext context) {
    final double totalValue = data.itemsList
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
            data.groupsMap.entries.map(
              (e) => GroupCard(
                itemsList: data.itemsMap[e.key]
                  ?..sort(
                    (a, b) =>
                        (b.price * a.quantity).compareTo(a.price * a.quantity),
                  ),
                colorsMap: data.colorsMap,
                totalValue: totalValue,
                group: e.value,
                userId: userId,
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

class GroupCard extends StatelessWidget {
  final List<Item>? itemsList;
  final Map<Item, Color> colorsMap;
  final double totalValue;
  final Group group;
  final int userId;

  const GroupCard({
    Key? key,
    required this.itemsList,
    required this.colorsMap,
    required this.totalValue,
    required this.group,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<int, Color> localTailwindColor = getColor(group.color);
    final color = localTailwindColor[500]!;

    if (itemsList == null) {
      return Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: color.withOpacity(0.20)),
          color: color.withOpacity(0.10),
        ),
        child: GroupCardTitleBar(
          title: group.name,
          subtitle: "Press + to add.",
          widget: Row(
            children: [
              EditGroup(color: color, group: group),
              SizedBox(width: 8),
              AddItem(
                color: color,
                userId: userId,
                groupId: group.id,
                colorName: group.color,
              ),
            ],
          ),
        ),
      );
    } else {
      final double totalLocalPrice = itemsList!
          .map((e) => e.price * e.quantity)
          .fold(0.0, (previous, current) => previous + current);

      final double totalLocalPercent = 100.0 * totalLocalPrice / totalValue;

      return Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: color.withOpacity(0.20)),
          color: color.withOpacity(0.10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GroupCardTitleBar(
              title: group.name,
              subtitle: "Total: R\$ $totalLocalPrice",
              widget: CircularProgress(
                totalLocalPercent: totalLocalPercent,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            for (int i = 0; i < itemsList!.length; i++) ...[
              SizedBox(
                width: double.infinity,
                child: ItemCard(
                  itemsList![i],
                  colorsMap[itemsList![i]]!,
                  totalValue,
                  group.color,
                ),
              ),
              if (i < itemsList!.length - 1)
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
                ),
            ],
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EditGroup(color: color, group: group),
                  SizedBox(width: 8),
                  AddItem(
                    color: color,
                    userId: userId,
                    groupId: group.id,
                    colorName: group.color,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class AddItem extends StatelessWidget {
  final Color color;
  final String colorName;
  final int userId;
  final int groupId;

  const AddItem({
    Key? key,
    required this.color,
    required this.colorName,
    required this.userId,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: color),
      child: Icon(Icons.add_rounded),
      onPressed: () {
        showDialog<Object>(
          context: context,
          builder: (_) => ItemDialog(
            colorName: colorName,
            onSavePressed: (name, value, target) {
              // Preserve the Bloc's context.
              context.read<DataBloc>().db.createItem(
                    groupId: groupId,
                    userId: userId,
                    name: name,
                    value: value,
                    target: target,
                  );
            },
          ),
        );
      },
    );
  }
}

class EditGroup extends StatelessWidget {
  final Color color;
  final Group group;

  const EditGroup({
    Key? key,
    required this.color,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: color,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(36, 36),
      ),
      child: Icon(Icons.edit_rounded),
      onPressed: () {
        showDialog<Object>(
          context: context,
          builder: (_) => GroupDialog(
            initialColorName: group.color,
            initialTitle: group.name,
            onSavePressed: (name, colorName) {
              // Preserve the Bloc's context.
              context.read<DataBloc>().db.editGroup(
                    group.copyWith(
                      name: name,
                      color: colorName,
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}

class CircularProgress extends StatelessWidget {
  final double totalLocalPercent;
  final Color color;

  const CircularProgress({
    Key? key,
    required this.totalLocalPercent,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      // StrokeWidth is 3.
      padding: EdgeInsets.all(3),
      child: CustomPaint(
        isComplex: false,
        painter: CirclePercentagePainter(
          percent: totalLocalPercent / 100,
          color: color,
          circleColor: Colors.transparent,
          backgroundColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${totalLocalPercent.toStringAsFixed(0)}%",
                style: Theme.of(context).textTheme.overline!.copyWith(
                      fontSize: 8,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupCardTitleBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? widget;

  const GroupCardTitleBar({
    Key? key,
    required this.title,
    required this.subtitle,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headline5),
              Text(subtitle, style: Theme.of(context).textTheme.overline),
            ],
          ),
        ),
        if (widget != null) widget!,
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  final Color color;
  final double totalValue;
  final String nameColor;

  const ItemCard(this.item, this.color, this.totalValue, this.nameColor);

  @override
  Widget build(BuildContext context) {
    final greenColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xff77d874)
        : Color(0xff2A8B27);

    final redColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xffff5a74)
        : Color(0xffCC0020);

    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(10.0),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? color.withOpacity(0.05)
            : color.withOpacity(0.15),
      ),
      onPressed: () {
        showDialog<Object>(
          context: context,
          builder: (_) => ItemDialog(
            colorName: nameColor,
            previousItem: item,
            onSavePressed: (name, value, target) {
              // Preserve the Bloc's context.
              context.read<DataBloc>().db.updateItem(item, name, value, target);
            },
            onDeletePressed: () => context.read<DataBloc>().db.deleteItem(item),
          ),
        );
      },
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
                  item.name,
                  style: GoogleFonts.firaSans(
                    color: Theme.of(context).colorScheme.onSurface,
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
                      "R\$ ${item.price} (${(item.price / totalValue).toPercent()}%)",
                      style: GoogleFonts.firaSans(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (item.targetPercent > 0)
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      "${(item.price / totalValue).toPercent()}%",
                      style: GoogleFonts.firaSans(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.50),
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
                      "${item.targetPercent}%",
                      style: GoogleFonts.firaSans(
                        color: Theme.of(context).colorScheme.onSurface,
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
                  "${item.targetPercent / 100 > item.price / totalValue ? "↑" : "↓"} R\$ ${(totalValue * item.targetPercent / 100 - item.price).toStringAsFixed(0)} (${(item.targetPercent / 100 - item.price / totalValue).toPercent()}%)",
                  style: GoogleFonts.firaSans(
                    color: item.targetPercent / 100 > item.price / totalValue
                        ? greenColor
                        : redColor,
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
