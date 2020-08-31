import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/column_builder.dart';
import 'package:password_manager/widgets/my_drop_down_button.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> newFields;

class EditPasswordScreen extends StatefulWidget {
  static const id = 'edit_password_screen';

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  List<String> textFieldStrings = ['Title', 'Password'];

  String dropDownValue;
  List<String> dropDownFields = ['Email', 'Username', 'Phone', 'Link'];
  final TextEditingController _controller = TextEditingController();

  String customFieldKey = "";

  @override
  void initState() {
    super.initState();

    // listen : false is necessary to access provider values in initState
    newFields = Map<String, dynamic>.from(
        Provider.of<ProviderClass>(context, listen: false).showPasswordFields);

    newFields.forEach((key, value) {
      if (key != "documentId") {
        if (!textFieldStrings.contains(key)) textFieldStrings.add(key);
      }
    });

    textFieldStrings =
        Functions.reorderTextFieldsDisplayOrder(textFieldStrings);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return ModalProgressHUD(
          progressIndicator: SpinKitChasingDots(
            color: Theme
                .of(context)
                .accentColor,
          ),
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
                        if (newFields['Title'] == null ||
                            newFields['Title'].trim() == "") {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Title is a mandatory field !')));
                        } else {
                          bool editPasswordSuccessful;

                          if (newFields['Password'] == null ||
                              newFields['Password'] == "")
                            newFields.remove('Password');

                          data.setShowPasswordFields(newFields);
                          Functions.popKeyboard(context);

                          data.startLoadingScreen();

                          newFields['Title'] = Functions.capitalizeFirstLetter(
                              newFields['Title']);

                          editPasswordSuccessful =
                              await data.editPasswordFieldInDatabase(newFields);
                          if (editPasswordSuccessful)
                            Navigator.pop(context);
                          else {
                            Functions.showSnackBar(
                                context, 'Error editing password !');
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
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: ListView(
                children: <Widget>[
                  ColumnBuilder(
                    itemBuilder: (context, index) {
                      return MyTextField(
                          labelText: textFieldStrings[index],
                          autofocus: textFieldStrings[index] == "Title",
                          defaultValue:
                          newFields[textFieldStrings[index]] ?? "",
                          onChanged: (String value) {
                            newFields[textFieldStrings[index]] = value;
                          },
                          trailingFunction: () {
                            newFields.remove(textFieldStrings[index]);
                            setState(() {
                              textFieldStrings.removeAt(index);
                            });
                          });
                    },
                    itemCount: textFieldStrings.length,
                  ),
                  MyDropDownButton(
                    dropDownOnChanged: (String newValue) {
                      setState(() {
                        dropDownValue = newValue;
                        if (!textFieldStrings.contains(dropDownValue))
                          textFieldStrings.add(dropDownValue);
                      });
                    },
                    dropDownFields: this.dropDownFields,
                  ),
                  MyTextField(
                    labelText: "Custom Field Name",
                    controller: _controller,
                    onChanged: (String value) {
                      customFieldKey = value;
                    },
                    trailingFunction: () {
                      customFieldKey =
                          Functions.capitalizeFirstLetter(customFieldKey);

                      if (!textFieldStrings.contains(customFieldKey) &&
                          customFieldKey != "" &&
                          customFieldKey != null) {
                        _controller.clear();
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
