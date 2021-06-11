import 'package:flutter/material.dart';

class InputDialogGroup extends StatefulWidget {
  final Function(String)? onSavePressed;

  const InputDialogGroup({this.onSavePressed, Key? key}) : super(key: key);

  @override
  _InputDialogGroupState createState() => _InputDialogGroupState();
}

class _InputDialogGroupState extends State<InputDialogGroup> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create a Group"),
      content: TextFormField(
        controller: textEditingController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter the name',
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            widget.onSavePressed?.call(textEditingController.text);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
