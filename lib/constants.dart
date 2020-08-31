import 'package:flutter/material.dart';

const Color kScaffoldBackgroundColor = Color(0xFF040F2D);

const Color kSecondaryColor = Color(0xFF050C25);

const Color kButtonColor = Color(0xFF0000B3);

const Color kCardBackgroundColor = Color(0xFF091642);

const TextStyle kCardTitleTextStyle = TextStyle(
    color: Colors.cyanAccent, fontSize: 20.0, fontWeight: FontWeight.bold);

const TextStyle kCardContentTextStyle = TextStyle(
  fontSize: 20.0,
);

const String kDefaultProfilePictureURL =
    "https://firebasestorage.googleapis.com/v0/b/password-manager-2083b.appspot.com/o/Profile%20Pictures%2FuserDefaultProfilePicture.png?alt=media&token=7e734c34-911b-4090-a217-a2fb89c0c287";

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Value',
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
