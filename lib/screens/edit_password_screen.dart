import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/column_builder.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> newFields;

class EditPasswordScreen extends StatefulWidget {
  static const id = 'edit_password_screen';

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  List<String> textFieldStrings = [];

  String dropDownValue = 'Email';
  List<String> dropDownFields = ['Email', 'Username', 'Phone', 'Link'];

  String customFieldKey = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // this method is called just after initState and using this method because we cannot Provider in initState

    newFields = Map<String,dynamic>.from(Provider.of<ProviderClass>(context).showPasswordFields);

    newFields.forEach((key, value) {
      if (key != "documentId") textFieldStrings.add(key.trim());
    });

    textFieldStrings = Functions.reorderTextFieldsDisplayOrder(textFieldStrings);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context,data,child) {
        return ModalProgressHUD(
          inAsyncCall: data.showLoadingScreen,
          child: Scaffold(
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
                        if (newFields['Title'] == null || newFields['Title'].trim() == "") {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Title is a mandatory field !')));
                        } else {
                          bool editPasswordSuccessful;

                          data.setShowPasswordFields(newFields);

                          data.startLoadingScreen();

                          newFields['Title'] = Functions.capitalizeFirstLetter(newFields['Title']);

                          editPasswordSuccessful = await data.editPasswordFieldInDatabase(newFields);
                          if (editPasswordSuccessful)
                            Navigator.pop(context);
                          else {
                            Functions.showSnackBar(context, 'Error editing password !');
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
                          defaultValue: newFields[textFieldStrings[index]]??"",
                          onChanged: (String value) {
                            newFields[textFieldStrings[index]] = value;
                          },
                          trailingFunction: () {
                            print(newFields[textFieldStrings[index]]);
                            newFields.remove(textFieldStrings[index]);
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
