import 'package:flutter/material.dart';

const Color kScaffoldBackgroundColor = Color(0xFF040F2D);

const Color kSecondaryColor = Color(0xFF050C25);

const Color kButtonColor = Color(0xFF0000B3);

const Color kCardBackgroundColor = Color(0xFF091642);

ThemeData kTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: kScaffoldBackgroundColor,
  dialogBackgroundColor: kCardBackgroundColor,
  canvasColor: kCardBackgroundColor,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.deepPurple,
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
);

const TextStyle kCardTitleTextStyle = TextStyle(
    color: Colors.cyanAccent, fontSize: 20.0, fontWeight: FontWeight.bold);

const TextStyle kCardContentTextStyle = TextStyle(
  fontSize: 20.0,
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
);
