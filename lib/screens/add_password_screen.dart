import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/vault.dart';
import 'package:password_manager/widgets/column_builder.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> fields = {};

class AddPasswordScreen extends StatefulWidget {
  static const id = 'add_password_screen';

  @override
  _AddPasswordScreenState createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  List<String> textFieldStrings = ['Title', 'Password'];
  String dropDownValue = 'Email';
  List<String> dropDownFields = ['Email', 'Username', 'Phone', 'Link'];

  //convert all to same case .
  String convertToTitleCase(String str) {
    str = str.trim().toLowerCase();
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }

  // TODO: add show hide password?

  // TODO: fix keyboard type not showing etc.

  //TODO: fix title and password as mandatory field

  @override
  Widget build(BuildContext context) {
    String customFieldKey = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Password"),
        centerTitle: true,
        backgroundColor: kSecondaryColor,
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  // title is mandatory field
                  if (fields['Title'] == null || fields['Title'] == "") {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Title is a mandatory field !')));
                  } else {
                    bool addPasswordSuccessful;
                    print("Sending $fields");
                    addPasswordSuccessful =
                        await Provider.of<ProviderClass>(context,listen: false)
                            .addPassword(fields);
                    if (addPasswordSuccessful) Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
        child: ListView(
          children: <Widget>[
            ColumnBuilder(
              itemBuilder: (context, index) {
                return MyTextField(
                  labelText: textFieldStrings[index],
                  onChanged: (String value) {
                    // not trimming password
                    if (value != "") {
                      if (fields[textFieldStrings[index]] == "Password")
                        fields[textFieldStrings[index]] = value;
                      else
                        fields[textFieldStrings[index]] = value.trim();
                    }
                  },
                  trailing: IconButton(
                    color: Colors.lightBlueAccent,
                    icon: Icon(Icons.delete, size: 30.0),
                    onPressed: () {
                      setState(() {
                        textFieldStrings.removeAt(index);
                      });
                    },
                  ),
                );
              },
              itemCount: textFieldStrings.length,
            ),
            ListTile(
              title: DropdownButton<String>(
                value: dropDownValue,
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropDownValue = newValue;
                  });
                },
                items: dropDownFields
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              trailing: IconButton(
                icon: Icon(Icons.add, size: 30.0),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  setState(() {
                    if (!textFieldStrings.contains(dropDownValue))
                      textFieldStrings.add(dropDownValue);
                  });
                },
              ),
            ),
            MyTextField(
              labelText: "Custom Field Name",
              onChanged: (String value) {
                if (value != "") customFieldKey = value;
              },
              trailing: IconButton(
                icon: Icon(Icons.add, size: 30.0),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  customFieldKey = convertToTitleCase(customFieldKey);
                  setState(() {
                    if (!textFieldStrings.contains(customFieldKey) &&
                        customFieldKey != "" &&
                        customFieldKey != null)
                      textFieldStrings.add(customFieldKey);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
