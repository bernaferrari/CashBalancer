import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:cash_balancer/details_screen/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/data_bloc.dart';
import '../database/data.dart';
import '../l10n/l10n.dart';
import '../users_screen/users_screen.dart';
import '../util/retrieve_spaced_list.dart';
import '../util/row_column_spacer.dart';
import '../util/tailwind_colors.dart';
import '../widgets/circle_percentage_painter.dart';

extension Percent on double {
  String toPercent() => (this * 100).toStringAsFixed(0);
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, FullData?>(builder: (context, state) {
      if (state == null) {
        return const SizedBox();
      } else {
        return DetailsPageImpl(state);
      }
    });
  }
}

class DetailsPageImpl extends StatelessWidget {
  final FullData data;

  const DetailsPageImpl(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).appTitle,
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
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Beamer.of(context).beamToNamed("/addGroup/${data.userId}"),
        label: Text(
          AppLocalizations.of(context).addGroup,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: (data.groupsMap.isEmpty == true)
          ? WhenEmptyCard(
              title: AppLocalizations.of(context).mainEmptyTitle,
              subtitle: AppLocalizations.of(context).mainEmptySubtitle,
              icon: Icons.account_balance_sharp,
            )
          : MainList(data: data),
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

    final bool longWidth = MediaQuery.of(context).size.width > 400;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: double.infinity,
              margin: const EdgeInsets.all(margin),
              width: longWidth ? 30 : 20,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.10),
              ),
              child: VerticalProgressBar(data: data, totalValue: totalValue),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  right: margin,
                  top: margin,
                  // On Android the FAB may get on top of it.
                  bottom: 6 * margin,
                ),
                children: [
                  if (data.allItems.isNotEmpty) ...[
                    TextButton(
                      onPressed: () {
                        Beamer.of(context)
                            .beamToNamed("/overview/${data.userId}");
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomPieChart(data),
                          const SizedBox(height: 16),
                          Text(
                            "Total: ${data.settings.currencySymbol} ${toCurrency(data.totalValue)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 40),
                  ],
                  ...spaceColumn(
                    20,
                    data.groupsMap.values.map(
                      (group) => GroupCard(
                        itemsList: data.groupedItems[group.id],
                        group: group,
                        allTotalValue: data.totalValue,
                        userId: data.userId,
                        settings: data.settings,
                      ),
                    ),
                  ),
                ],
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final List<ItemData> nonZeroItems =
            data.allItems.where((element) => element.price != 0).toList();

        final List<double> spacedList =
            retrieveSpacedList(nonZeroItems, constraints.maxHeight);

        print("spacedList is $spacedList");
        print("constraints.maxHeight is ${constraints.maxHeight}");

        // return Column(
        //   children: [
        //     for (int i = 0; i < 5; i++)
        //       Container(
        //         color: Colors.red,
        //         width: 100,
        //         height: 8,
        //       ),
        //   ],
        // );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: spaceColumn(
            2,
            [
              for (int i = 0; i < nonZeroItems.length; i++)
                Tooltip(
                  message: nonZeroItems[i].name,
                  child: SizedBox(
                    height: spacedList[i],
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: nonZeroItems[i].color,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        fixedSize: Size(100, spacedList[i]),
                        shape: const RoundedRectangleBorder(),
                        elevation: 0,
                      ),
                      onPressed: () => Beamer.of(context)
                          .beamToNamed('/editItem/${nonZeroItems[i].id}'),
                      child: Container(),
                    ),
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
  final double allTotalValue;
  final SettingsData settings;

  const GroupCard({
    Key? key,
    required this.itemsList,
    required this.group,
    required this.userId,
    required this.allTotalValue,
    required this.settings,
  }) : super(key: key);

  // Make it reusable.
  Widget customContainer({
    required Widget child,
    required Color color,
    required BuildContext context,
  }) =>
      Container(
        padding: const EdgeInsets.all(10.0),
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
              EditGroup(color: color, groupId: group.id),
              const SizedBox(width: 8),
              AddItem(color: color, userId: userId, groupId: group.id),
            ],
          ),
        ),
      );
    } else {
      final double totalLocalPercent = (group.totalValue / allTotalValue) * 100;

      return customContainer(
        context: context,
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GroupCardTitleBar(
              title: group.name,
              subtitle:
                  "Total: ${settings.currencySymbol} ${toCurrency(group.totalValue)}",
              widget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EditGroup(color: color, groupId: group.id),
                  const SizedBox(width: 8),
                  AddItem(color: color, userId: userId, groupId: group.id),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < itemsList!.length; i++) ...[
              SizedBox(
                width: double.infinity,
                child: ItemCard(
                  itemsList![i],
                  settings.relativeTarget ? group.totalValue : allTotalValue,
                  group.colorName,
                  settings.currencySymbol,
                ),
              ),
              if (i < itemsList!.length - 1)
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
                ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(child: SizedBox.shrink()),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (group.targetPercent != -1) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PercentArrow(
                            itemValue: group.totalValue,
                            totalValue: allTotalValue,
                            targetPercent: group.targetPercent,
                          ),
                          const SizedBox(height: 4),
                          UpDownDiffText(
                            currencySymbol: settings.currencySymbol,
                            itemValue: group.totalValue,
                            targetPercent: group.targetPercent,
                            totalValue: allTotalValue,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          children: [
                            Center(
                              child: CircularProgress(
                                totalLocalPercent: totalLocalPercent,
                                color: localTailwindColor[500]!,
                                hasText: false,
                              ),
                            ),
                            Center(
                              child: CircularProgress(
                                totalLocalPercent: group.targetPercent,
                                color: localTailwindColor[200]!,
                                size: 25,
                                hasText: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else
                      CircularProgress(
                        totalLocalPercent: totalLocalPercent,
                        color: color,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class AddItem extends StatelessWidget {
  final Color color;
  final int userId;
  final int groupId;

  const AddItem({
    Key? key,
    required this.color,
    required this.userId,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        fixedSize: const Size(64, 40),
      ),
      child: const Icon(Icons.add_rounded),
      onPressed: () =>
          Beamer.of(context).beamToNamed('/addItem/$groupId/$userId'),
    );
  }
}

class EditGroup extends StatelessWidget {
  final Color color;
  final int groupId;

  const EditGroup({
    Key? key,
    required this.color,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: color,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        fixedSize: const Size(40, 40),
      ),
      child: const Icon(Icons.edit_rounded),
      onPressed: () => Beamer.of(context).beamToNamed("/editGroup/$groupId"),
    );
  }
}

class CircularProgress extends StatelessWidget {
  final double totalLocalPercent;
  final Color color;
  final double size;
  final bool hasText;

  const CircularProgress({
    Key? key,
    required this.totalLocalPercent,
    required this.color,
    this.size = 40,
    this.hasText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      // StrokeWidth is 3.
      padding: const EdgeInsets.all(3),
      child: CustomPaint(
        isComplex: false,
        painter: CirclePercentagePainter(
          percent: totalLocalPercent / 100,
          color: color,
          circleColor: Colors.transparent,
          backgroundColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
        child: hasText
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${totalLocalPercent.toStringAsFixed(0)}%",
                      style: Theme.of(context)
                          .textTheme
                          .overline!
                          .copyWith(fontSize: 8),
                    ),
                  ],
                ),
              )
            : null,
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
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.overline,
                overflow: TextOverflow.ellipsis,
              ),
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
  final String currencySymbol;

  const ItemCard(
      this.item, this.totalValue, this.nameColor, this.currencySymbol,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10.0),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? item.color.withOpacity(0.05)
            : item.color.withOpacity(0.25),
        elevation: 0,
      ),
      onPressed: () {
        Beamer.of(context).beamToNamed('/editItem/${item.id}');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 38,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: item.color,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.firaSans(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.targetPercent != -1)
                      PercentArrow(
                        itemValue: item.price,
                        totalValue: totalValue,
                        targetPercent: item.targetPercent,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                UpDownDiffText(
                  currencySymbol: currencySymbol,
                  itemValue: item.price,
                  targetPercent: item.targetPercent,
                  totalValue: totalValue,
                  leftWidget: Expanded(
                    child: Text(
                      "$currencySymbol ${toCurrency(item.price)} (${(item.price / totalValue).toPercent()}%)",
                      style: GoogleFonts.firaSans(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PercentArrow extends StatelessWidget {
  final double itemValue;
  final double totalValue;
  final double targetPercent;

  const PercentArrow({
    required this.itemValue,
    required this.totalValue,
    required this.targetPercent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${(itemValue / totalValue).toPercent()}%",
          style: GoogleFonts.firaSans(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.50),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.50),
          ),
        ),
        Text(
          "${targetPercent.toStringAsFixed(0)}%",
          style: GoogleFonts.firaSans(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFeatures: const [
              FontFeature.enable('calc'),
            ],
          ),
        ),
      ],
    );
  }
}

class UpDownDiffText extends StatelessWidget {
  final String currencySymbol;
  final double itemValue;
  final double targetPercent;
  final double totalValue;
  final Widget? leftWidget;

  const UpDownDiffText({
    required this.currencySymbol,
    required this.itemValue,
    required this.targetPercent,
    required this.totalValue,
    this.leftWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greenColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff77d874)
        : const Color(0xff2A8B27);

    final redColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xffff5a74)
        : const Color(0xffCC0020);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (leftWidget != null) leftWidget!,
        if (targetPercent > 0)
          Text(
            "${targetPercent / 100 > itemValue / totalValue ? "↑" : "↓"} $currencySymbol ${toCurrency(totalValue * targetPercent / 100 - itemValue)} (${(targetPercent / 100 - itemValue / totalValue).toPercent()}%)",
            style: GoogleFonts.firaSans(
              color: targetPercent / 100 > itemValue / totalValue
                  ? greenColor
                  : redColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

String toCurrency(double value) => toCurrencyString(value.toString());
