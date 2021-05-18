import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Relative Target"),
            subtitle: Text(
              "Sum up to 100% in each section, instead of all sections.",
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
        ],
      ),
    );
  }
}
