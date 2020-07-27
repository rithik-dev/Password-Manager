import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class AddPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000014),
      child: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: kScaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        ),
        child: ListView(
          children: <Widget>[],
        ),
      ),
    );
  }
}

// "timestamp": FieldValue.serverTimestamp(),
