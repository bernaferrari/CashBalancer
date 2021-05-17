import 'package:flutter/material.dart';

import '../util/tailwind_colors.dart';

class AnimatedColorPicker extends StatefulWidget {
  final String initialSelection;
  final ValueChanged<String> onChanged;

  const AnimatedColorPicker(this.initialSelection, this.onChanged);

  @override
  _AnimatedColorPickerState createState() => _AnimatedColorPickerState();
}

class _AnimatedColorPickerState extends State<AnimatedColorPicker> {
  late String selected;

  @override
  void initState() {
    selected = widget.initialSelection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
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
  });

  final maxSize = 36.0;

  @override
  Widget build(BuildContext context) {
    final _size = isSelected ? maxSize - 4 : maxSize;

    return InkWell(
      customBorder: CircleBorder(),
      onTap: onSelected,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            ),
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: _size - 8,
                height: _size - 8,
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
