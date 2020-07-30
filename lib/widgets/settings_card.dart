import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class SettingsCard extends StatelessWidget {
  final String text;
  final Function onPressed;

  SettingsCard({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: kCardBackgroundColor,
      child: MaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(text, style: TextStyle(fontSize: 20.0), textAlign: TextAlign.start),
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
