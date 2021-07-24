import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/util/row_column_spacer.dart';
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final FullData data;

  const BarChart(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ItemData> sortedItems;
    if (data.settings.sortBy == 0) {
      sortedItems = data.allItems..sort((a, b) => b.price.compareTo(a.price));
    } else {
      sortedItems = data.allItems..sort((a, b) => a.name.compareTo(b.name));
    }

    final double maximumPrice =
        sortedItems.map((e) => e.price).toList().reduce(max);

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: spaceRow(
            16,
            [
              ...sortedItems.map((item) {
                return RectangularPercentageWidget(
                  id: item.id,
                  percent: item.price / maximumPrice,
                  size: 40,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  borderWidth: 0,
                  progressColor: item.color,
                  direction: Axis.vertical,
                  verticalDirection: VerticalDirection.up,
                  borderRadius: 8,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class RectangularPercentageWidget extends StatefulWidget {
  const RectangularPercentageWidget({
    Key? key,
    required this.id,
    this.percent = 0.0,
    this.size = 30,
    this.direction = Axis.horizontal,
    this.verticalDirection = VerticalDirection.down,
    this.borderRadius = 4,
    this.borderColor = const Color(0xFFFA7268),
    this.borderWidth = 0.2,
    this.backgroundColor = const Color(0x00FFFFFF),
    this.progressColor = const Color(0xFFFA7268),
  }) : super(key: key);

  final int id;
  final double percent;
  final double size;
  final Axis direction;
  final VerticalDirection verticalDirection;
  final double borderRadius;
  final Color backgroundColor;
  final Color? progressColor;
  final Color borderColor;
  final double borderWidth;

  @override
  State createState() => _RectangularPercentageWidgetState();
}

class _RectangularPercentageWidgetState
    extends State<RectangularPercentageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.animateTo(widget.percent);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RectangularPercentageWidget oldWidget) {
    if (oldWidget.percent != widget.percent) {
      _controller.animateTo(widget.percent);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final double position = _controller.value;

    final Widget progressWidget = Container(
      decoration: BoxDecoration(
        color: widget.progressColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.borderRadius),
        ),
      ),
    );

    return Container(
      width: widget.direction == Axis.vertical ? widget.size : null,
      height: widget.direction == Axis.horizontal ? widget.size : null,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.borderRadius),
          bottom: Radius.circular(widget.borderRadius / 2),
        ),
        border: widget.borderWidth == 0
            ? null
            : Border.all(
                color: widget.borderColor,
                width: widget.borderWidth,
              ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(),
          primary: widget.progressColor,
        ),
        onPressed: () =>
            Beamer.of(context).beamToNamed('editItem/${widget.id}'),
        child: Flex(
          direction: widget.direction,
          verticalDirection: widget.verticalDirection,
          children: <Widget>[
            Expanded(
              flex: (position * 100).toInt(),
              child: progressWidget,
            ),
            Expanded(
              flex: 100 - (position * 100).toInt(),
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
