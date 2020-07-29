import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Functions {
  Functions._();

  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text), duration: Duration(seconds: 1));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void copyToClipboard(String data) {
    Clipboard.setData(ClipboardData(text: data));
  }

  static String capitalizeFirstLetter(String str) {
    String _temp, finalString = "";
    str = str.trim().toLowerCase();
    List<String> strings = str.split(" ");

    for (int index = 0; index < strings.length; index++) {
      _temp = strings[index].trim();
      if (_temp != "")
        finalString += '${_temp[0].toUpperCase()}${_temp.substring(1)} ';
    }
    return finalString.trim();
  }

  static void showAlertDialog(BuildContext context,Widget alertDialog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
