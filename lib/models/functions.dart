import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Functions {
  Functions._();

  static void showSnackBar(BuildContext context, String text, {Duration duration}) {
    final snackBar = SnackBar(content: Text(text), duration: duration ?? Duration(seconds: 1));
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

  static void showAlertDialog(BuildContext context, Widget alertDialog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  // function for show password screen and edit screen to reorder widgets accordingly
  static List<String> reorderTextFieldsDisplayOrder(List<String> keys) {
    List<String> displayOrder = [
      'Title',
      'Email',
      'Username',
      'Password',
      'Phone',
      'Link'
    ];

    Set keysSet = Set.from(keys);
    Set displayOrderSet = Set.from(displayOrder);
    List<String> customFieldsList = List.from(keysSet.difference(displayOrderSet));
    customFieldsList.sort();

    List<String> reorderedDisplayOrderList = [];

    for (int index = 0; index < displayOrder.length; index++) {
      if (keys.contains(displayOrder[index])) {
        reorderedDisplayOrderList.add(displayOrder[index]);
      }
    }

    final List<String> finalList = reorderedDisplayOrderList + customFieldsList;
    return finalList;
  }
}
