import 'package:cash_balancer/util/tailwind_colors.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() => runApp(const StorybookApp());

class AnimatedColorPicker extends StatefulWidget {
  @override
  _AnimatedColorPickerState createState() => _AnimatedColorPickerState();
}

class _AnimatedColorPickerState extends State<AnimatedColorPicker> {
  final colors = {
    Color(0xfff43f5e): false,
    Color(0xffec4899): false,
    Color(0xffd946ef): false,
    Color(0xffa855f7): false,
    Color(0xff8b5cf6): false,
    Color(0xff6366f1): false,
    Color(0xff3b82f6): false,
    Color(0xff0ea5e9): false,
    Color(0xff06b6d4): false,
    Color(0xff14b8a6): false,
    Color(0xff10b981): false,
    Color(0xff22c55e): false,
    Color(0xff84cc16): false,
    Color(0xffeab308): false,
    Color(0xfff59e0b): false,
    Color(0xfff97316): false,
    Color(0xffef4444): false,
    Color(0xff78716c): false,
    Color(0xff737373): false,
    Color(0xff71717a): false,
    Color(0xff6b7280): false,
    Color(0xff64748b): false,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          for (var color in colors.entries)
            AnimatedColorItem(
              color: color.key,
              isSelected: color.value,
              onSelected: () {
                print("onSelected!!");
                setState(() {
                  print("${color.key} -> ${!color.value}");
                  for (var element in colors.entries) {
                    colors[element.key] = false;
                  }

                  colors[color.key] = !color.value;
                  print("${color.key} -> ${!color.value}");
                });
              },
            ),
        ],
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

  final maxSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final _size = isSelected ? maxSize - 4 : maxSize;

    return GestureDetector(
      onTap: onSelected,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Container(
          color: Colors.black,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StorybookApp extends StatelessWidget {
  const StorybookApp();

  @override
  Widget build(BuildContext context) => Storybook(
        children: [
          Story(
            name: 'Animated Color Item',
            builder: (_, k) => AnimatedColorPicker(),
          ),
        ],
      );
}
