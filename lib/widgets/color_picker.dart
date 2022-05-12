import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../util/tailwind_colors.dart';

class ColorPicker extends StatefulWidget {
  final String initialSelection;
  final ValueChanged<String> onChanged;

  const ColorPicker(this.initialSelection, this.onChanged, {Key? key})
      : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late String selected = widget.initialSelection;

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
              for (String colorName in tailwindColorsNames)
                AnimatedColorItem(
                  color: tailwindColors[colorName]![500]!,
                  isSelected: colorName == selected,
                  onSelected: () {
                    setState(() {
                      selected = colorName;
                    });
                    widget.onChanged(selected);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback? onSelected;

  const AnimatedColorItem({
    required this.color,
    required this.isSelected,
    this.onSelected,
    Key? key,
  }) : super(key: key);

  final maxSize = 36.0;

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
