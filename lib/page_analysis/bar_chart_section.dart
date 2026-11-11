import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:cash_balancer/database/data.dart';
import 'package:cash_balancer/page_home/details_page.dart';
import 'package:flutter/material.dart';

class const BarChartSection(final FullData data, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (data.allItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<ItemData> sortedItems = [...data.allItems];
    if (data.settings.sortBy == 0) {
      sortedItems.sort((a, b) => b.totalValue.compareTo(a.totalValue));
    } else {
      sortedItems.sort((a, b) => a.name.compareTo(b.name));
    }

    final double maximumPrice =
        sortedItems.map((e) => e.totalValue).reduce(max);

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              for (final item in sortedItems)
                () {
                  final percent = data.totalValue > 0
                      ? (item.totalValue / data.totalValue * 100)
                          .toStringAsFixed(1)
                      : '0';
                  return Tooltip(
                    key: ValueKey(item.id),
                    message:
                        '${item.name} • ${data.settings.currencySymbol} ${toCurrency(item.totalValue)} ($percent%)',
                    child: RectangularPercentageWidget(
                      id: item.id,
                      percent: maximumPrice > 0
                          ? item.totalValue / maximumPrice
                          : 0,
                      size: 40,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withValues(alpha: 0.10),
                      borderWidth: 0,
                      progressColor: item.color,
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      borderRadius: 8,
                    ),
                  );
                }(),
            ],
          ),
        ),
      ),
    );
  }
}

class const RectangularPercentageWidget({
  super.key,
  required final int id,
  final double percent = 0.0,
  final double size = 30,
  final Axis direction = Axis.horizontal,
  final VerticalDirection verticalDirection = VerticalDirection.down,
  final double borderRadius = 4,
  final Color borderColor = const Color(0xFFFA7268),
  final double borderWidth = 0.2,
  final Color backgroundColor = const Color(0x00FFFFFF),
  final Color? progressColor = const Color(0xFFFA7268),
}) extends StatefulWidget {
  @override
  State createState() => _RectangularPercentageWidgetState();
}

class _RectangularPercentageWidgetState
    extends State<RectangularPercentageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _controller.animateTo(
      widget.percent.clamp(0.0, 1.0),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RectangularPercentageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      _controller.animateTo(
        widget.percent.clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          foregroundColor: widget.progressColor,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: () =>
            Beamer.of(context).beamToNamed('/editItem/${widget.id}'),
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final int filledFlex =
                (_controller.value.clamp(0.0, 1.0) * 1000).round();
            final int emptyFlex = 1000 - filledFlex;

            return Flex(
              direction: widget.direction,
              verticalDirection: widget.verticalDirection,
              children: <Widget>[
                if (filledFlex > 0)
                  Expanded(
                    flex: filledFlex,
                    child: progressWidget,
                  ),
                if (emptyFlex > 0)
                  Expanded(
                    flex: emptyFlex,
                    child: const SizedBox.expand(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
