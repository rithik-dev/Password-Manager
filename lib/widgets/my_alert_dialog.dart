import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String text, content;
  final Function cancelButtonOnPressed, continueButtonOnPressed;

  MyAlertDialog(
      {@required this.text,
      @required this.content,
      @required this.cancelButtonOnPressed,
      @required this.continueButtonOnPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: false,
      title: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(content),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: cancelButtonOnPressed,
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: continueButtonOnPressed,
        ),
      ],
    );
  }
}
