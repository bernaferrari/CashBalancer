import 'package:flutter/material.dart';

class InputDialogGroup extends StatefulWidget {
  final Function(String)? onSavePressed;

  const InputDialogGroup({this.onSavePressed});

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
      title: Text("Create a Group"),
      content: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter the name',
        ),
      ),
      contentPadding: EdgeInsets.only(left: 24, right: 24, top: 16),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Save'),
          onPressed: () {
            widget.onSavePressed?.call(textEditingController.text);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
