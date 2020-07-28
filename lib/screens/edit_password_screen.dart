import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/widgets/column_builder.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

//FIXME: custom fields add even if one with same name exists

Map<String, dynamic> newFields;

class EditPasswordScreen extends StatefulWidget {
  static const id = 'edit_password_screen';

  final Map<String, dynamic> fields;

  EditPasswordScreen(this.fields);

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  List<String> textFieldStrings = [];

  String convertToTitleCase(String str) {
    str = str.trim().toLowerCase();
    return '${str[0].toUpperCase()}${str.substring(1)}';
  }

  String dropDownValue = 'Email';
  List<String> dropDownFields = ['Email', 'Username', 'Phone', 'Link'];

  void createTextFields(Map<String, dynamic> fields) {
    List<MyTextField> textFields = [];

    fields.forEach((key, value) {
      if (key != "documentId") textFieldStrings.add(key.trim());
    });
    print(textFieldStrings);

    for (String textFieldString in textFieldStrings) {
      textFields.add(
        MyTextField(
          labelText: textFieldString,
          defaultValue: newFields[textFieldString],
          trailing: IconButton(
            color: Colors.lightBlueAccent,
            icon: Icon(Icons.delete, size: 30.0),
            onPressed: () {
              setState(() {
                textFieldStrings.remove(textFieldString);
              });
            },
          ),
          onChanged: (String value) {
            // not trimming password
            if (value != "") {
              if (fields[textFieldString] == "Password")
                fields[textFieldString] = value;
              else
                fields[textFieldString] = value.trim();
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newFields = widget.fields;
    createTextFields(newFields);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> newFields = widget.fields;
    String customFieldKey = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Password"),
        centerTitle: true,
        backgroundColor: kSecondaryColor,
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  // title is mandatory field
                  if (newFields['Title'] == null || newFields['Title'] == "") {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Title is a mandatory field !')));
                  } else {
                    bool editPasswordSuccessful;
                    editPasswordSuccessful =
                        await Provider.of<ProviderClass>(context, listen: false)
                            .editPassword(newFields);
                    if (editPasswordSuccessful) Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            ColumnBuilder(
              itemBuilder: (context, index) {
                return MyTextField(
                  labelText: textFieldStrings[index],
                  defaultValue: newFields[textFieldStrings[index]],
                  onChanged: (String value) {
                    // not trimming password
                    if (value != "") {
                      if (textFieldStrings[index] == "Password")
                        newFields[textFieldStrings[index]] = value;
                      else
                        newFields[textFieldStrings[index]] = value.trim();
                    }
                  },
                  trailing: IconButton(
                    color: Colors.lightBlueAccent,
                    icon: Icon(Icons.delete, size: 30.0),
                    onPressed: () {
                      newFields.remove(textFieldStrings[index]);
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
                  color: Colors.blue,
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
                  if (!textFieldStrings.contains(customFieldKey) &&
                      customFieldKey != "" &&
                      customFieldKey != null) {
                    customFieldKey = convertToTitleCase(customFieldKey);
                    setState(() {
                      textFieldStrings.add(customFieldKey);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
