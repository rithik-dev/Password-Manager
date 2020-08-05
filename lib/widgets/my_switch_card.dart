import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class MySwitchCard extends StatelessWidget {
  MySwitchCard({this.title, this.onChanged, this.currentValue, this.subtitle});

  final String title;
  final Function onChanged;
  final bool currentValue;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardBackgroundColor,
      child: ListTile(
        title: Text(this.title),
        subtitle: this.subtitle == null ? null : Text(this.subtitle),
        // switch.adaptive shows ios type switch on ios devices and android type on android devices
        trailing: Switch.adaptive(
          value: this.currentValue,
          onChanged: this.onChanged,
        ),
      ),
    );
  }
}
