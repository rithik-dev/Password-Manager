import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String text, content;
  final Function continueButtonOnPressed;
  final Widget passwordTextField;

  MyAlertDialog(
      {@required this.text,
      @required this.content,
      this.passwordTextField,
      @required this.continueButtonOnPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: passwordTextField != null ? true : false,
      title: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text("$content\n\nThis action is irreversible !"),
          this.passwordTextField != null
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    this.passwordTextField
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed: continueButtonOnPressed,
        ),
      ],
    );
  }
}
