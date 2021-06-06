import 'package:flutter/material.dart';

import '../widgets/dialog_screen_base.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogScreenBase(
      colorName: 'warmGray',
      appBarTitle: "Settings",
      children: [
        SizedBox(height: 24),
        SwitchListTile(
          title: Text("Relative Target"),
          subtitle: Text(
            "Sum up to 100% in each section, instead of considering all sections.",
          ),
          value: true,
          onChanged: (value) {},
        ),
        ListTile(
          title: Text("Currency Symbol"),
          subtitle: Text(
            "E.g. \$, € or R\$",
          ),
        ),
        ListTile(
          title: Text("Sort by"),
          subtitle: Text(
            "Name / Max Price / Min Price",
          ),
        ),
      ],
    );
  }
}
