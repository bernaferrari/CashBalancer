import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
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
    return BlocBuilder<DataCubit, FullData?>(builder: (context, state) {
      return DetailsPageImpl(state);
    });
  }
}

class DetailsPageImpl extends StatelessWidget {
  final FullData? data;

  const DetailsPageImpl(this.data);

  @override
  Widget build(BuildContext context) {
    print("data is $data");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () => Beamer.of(context).beamToNamed('/about'),
          //   icon: Icon(Icons.info_outline_rounded),
          // ),
          IconButton(
            onPressed: () => Beamer.of(context).beamToNamed('/settings'),
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog<Object>(
            context: context,
            builder: (_) => GroupDialog(
              onSavePressed: (text, colorName) {
                // Preserve the Bloc's context.
                BlocProvider.of<DataCubit>(context)
                    .db
                    .createGroup(text, colorName);
              },
            ),
          );
        },
        label: Text(
          AppLocalizations.of(context)!.addGroup,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: (data == null || data?.groupsMap.isEmpty == true)
          ? WhenEmptyCard(
        title: AppLocalizations.of(context)!.mainEmptyTitle,
        subtitle: AppLocalizations.of(context)!.mainEmptySubtitle,
        icon: Icons.account_balance_sharp,
      )
          : MainList(data: data!),
    );
  }
}

class MainList extends StatelessWidget {
  final FullData data;

  const MainList({
    Key? key,
    required this.data,
  }) : super(key: key);

  static const double margin = 20.0;

  @override
  Widget build(BuildContext context) {
    final double totalValue =
        data.allItems.fold(0, (a, b) => a + b.price * b.quantity);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: double.infinity,
              margin: EdgeInsets.all(margin),
              width: 20,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.10),
              ),
              child: VerticalProgressBar(
                data: data,
                totalValue: totalValue,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: margin,
                    top: margin,
                    bottom: margin,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: spaceColumn(
                      20,
                      data.groupsMap.entries.map(
                        (e) => GroupCard(
                          itemsList: data.groupedItems[e.key]
                            ?..sort(
                              (a, b) => (b.price * a.quantity)
                                  .compareTo(a.price * a.quantity),
                            ),
                          group: e.value,
                          userId: data.userId,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalProgressBar extends StatelessWidget {
  final FullData data;
  final double totalValue;

  const VerticalProgressBar({
    required this.data,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<double> spacedList =
            retrieveSpacedList(data.allItems, constraints.maxHeight);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: spaceColumn(
            2,
            [
              for (int i = 0; i < data.allItems.length; i++)
                Tooltip(
                  message: "${data.allItems[i].name}",
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: data.allItems[i].color,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      fixedSize: Size(100, spacedList[i]),
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      showDialog<Object>(
                        context: context,
                        builder: (_) => ItemDialog(
                          totalValue: totalValue,
                          bloc: context.read<DataCubit>(),
                          colorName: data
                              .groupsMap[data.allItems[i].groupId]!.colorName,
                          previousItem: data.allItems[i],
                          userId: data.allItems[i].id,
                          groupId: data.allItems[i].groupId,
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

Map<int, Color> getColor(String colorType) {
  return tailwindColors[colorType]!;
}

class GroupCard extends StatelessWidget {
  final List<ItemData>? itemsList;
  final GroupData group;
  final int userId;

  const GroupCard({
    Key? key,
    required this.itemsList,
    required this.group,
    required this.userId,
  }) : super(key: key);

  // Make it reusable.
  Widget customContainer({
    required Widget child,
    required Color color,
    required BuildContext context,
  }) =>
      Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: color.withOpacity(0.20)),
          color: Theme.of(context).brightness == Brightness.dark
              ? color.withOpacity(0.10)
              : color.withOpacity(0.05),
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final Map<int, Color> localTailwindColor = getColor(group.colorName);
    final color = localTailwindColor[500]!;

    if (itemsList == null) {
      return customContainer(
        context: context,
        color: color,
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
                colorName: group.colorName,
                totalValue: group.totalValue,
              ),
            ],
          ),
        ),
      );
    } else {
      final double totalLocalPrice = itemsList!
          .map((e) => e.price * e.quantity)
          .fold(0.0, (previous, current) => previous + current);

      final double totalLocalPercent =
          100.0 * totalLocalPrice / group.totalValue;

      return customContainer(
        context: context,
        color: color,
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
                  group.totalValue,
                  group.colorName,
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
                    colorName: group.colorName,
                    totalValue: group.totalValue,
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
  final double totalValue;

  const AddItem({
    Key? key,
    required this.color,
    required this.colorName,
    required this.userId,
    required this.groupId,
    required this.totalValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        fixedSize: Size(64, 40),
      ),
      child: Icon(Icons.add_rounded),
      onPressed: () {
        showDialog<Object>(
          context: context,
          builder: (_) => ItemDialog(
            colorName: colorName,
            totalValue: totalValue,
            bloc: context.read<DataCubit>(),
            groupId: groupId,
            userId: userId,
          ),
        );
      },
    );
  }
}

class EditGroup extends StatelessWidget {
  final Color color;
  final GroupData group;

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
        fixedSize: Size(40, 40),
      ),
      child: Icon(Icons.edit_rounded),
      onPressed: () {
        showDialog<Object>(
          context: context,
          builder: (_) => GroupDialog(
            previousGroup: group,
            onDeletePressed: () async =>
                await context.read<DataCubit>().db.deleteGroup(group.id),
            onSavePressed: (name, colorName) {
              // Preserve the Bloc's context.
              context.read<DataCubit>().db.editGroup(
                    group.copyWith(
                      name: name,
                      colorName: colorName,
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
  final ItemData item;
  final double totalValue;
  final String nameColor;

  const ItemCard(this.item, this.totalValue, this.nameColor);

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
            ? item.color.withOpacity(0.05)
            : item.color.withOpacity(0.25),
      ),
      onPressed: () {
        Beamer.of(context).beamToNamed('/editItem/${item.id}');

        // showDialog<Object>(
        //   context: context,
        //   builder: (_) => ItemDialog(
        //     bloc: context.read<DataCubit>(),
        //     totalValue: totalValue,
        //     colorName: nameColor,
        //     previousItem: item,
        //     userId: item.id,
        //     groupId: item.groupId,
        //   ),
        // );
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
                    color: item.color,
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
