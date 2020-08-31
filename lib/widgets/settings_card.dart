import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class SettingsCard extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool showTrailing;
  final bool centerText;

  SettingsCard(
      {this.text,
      this.onPressed,
      this.showTrailing = true,
      this.centerText = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: kCardBackgroundColor,
      child: ListTile(
        onTap: this.onPressed,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        title: Text(
          text,
          style: TextStyle(fontSize: 20.0),
          textAlign: this.centerText ? TextAlign.center : TextAlign.start,
        ),
        trailing: this.showTrailing ? Icon(Icons.arrow_forward_ios) : null,
      ),
    );
  }
}
