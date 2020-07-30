import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
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

  String customFieldKey = "";

  @override
  void initState() {
    super.initState();
    fields = {};
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return ModalProgressHUD(
          inAsyncCall: data.showLoadingScreen,
          child: Scaffold(
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
                        if (fields['Title'] == null || fields['Title'].trim() == "") {
                          Functions.showSnackBar(context, 'Title is a mandatory field !');
                        } else {
                          bool addPasswordSuccessful;

                          data.startLoadingScreen();

                          fields['Title'] = Functions.capitalizeFirstLetter(fields['Title']);
                          addPasswordSuccessful = await data.addPassword(fields);
                          if (addPasswordSuccessful)
                            Navigator.pop(context);
                          else {
                            Functions.showSnackBar(context, 'Error adding new password !');
                          }
                          data.stopLoadingScreen();
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
                          onChanged: (String value) {
                            fields[textFieldStrings[index]] = value;
                          },
                          trailingFunction: () {
                            setState(() {
                              textFieldStrings.removeAt(index);
                            });
                          });
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
                      items: dropDownFields.map<DropdownMenuItem<String>>((String value) {
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
                      customFieldKey = value;
                    },
                    trailingFunction: () {
                      customFieldKey = Functions.capitalizeFirstLetter(customFieldKey);

                      if (!textFieldStrings.contains(customFieldKey) &&
                          customFieldKey != "" &&
                          customFieldKey != null) {
                        setState(() {
                          textFieldStrings.add(customFieldKey);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
