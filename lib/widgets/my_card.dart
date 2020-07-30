import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class MyCard extends StatelessWidget {
  MyCard({this.title, this.onChanged, this.currentValue, this.subtitle});

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
        trailing: Switch(
          value: this.currentValue,
          onChanged: this.onChanged,
        ),
      ),
    );
  }
}
