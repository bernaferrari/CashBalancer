import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../util/tailwind_colors.dart';

class const ColorPicker(
  final String initialSelection,
  final ValueChanged<String> onChanged, {
  super.key,
}) extends StatefulWidget {
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late TailwindColor selected = TailwindColor.fromName(widget.initialSelection);

  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelection != widget.initialSelection) {
      selected = TailwindColor.fromName(widget.initialSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final twColor in TailwindColor.values)
                AnimatedColorItem(
                  color: twColor.palette.s500,
                  isSelected: twColor == selected,
                  onSelected: () {
                    setState(() {
                      selected = twColor;
                    });
                    widget.onChanged(selected.name);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class const AnimatedColorItem({
  required final Color color,
  required final bool isSelected,
  final VoidCallback? onSelected,
  super.key,
}) extends StatelessWidget {
  static const maxSize = 36.0;

  @override
  Widget build(BuildContext context) {
    final size = isSelected ? maxSize - 4 : maxSize;

    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onSelected,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            ),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: size - 8,
                height: size - 8,
                // padding: isSelected ? EdgeInsets.all(4) : EdgeInsets.zero,
                decoration: isSelected
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                      )
                    : BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 0,
                          color: Colors.transparent,
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
