import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import 'widgets/color_picker.dart';

void main() => runApp(const StorybookApp());

class const StorybookApp({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Storybook(
        stories: [
          Story(
            name: 'Animated Color Item',
            builder: (_) => ColorPicker('red', (changed) {}),
          ),
        ],
      );
}
