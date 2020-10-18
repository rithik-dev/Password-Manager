import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/column_builder.dart';
import 'package:password_manager/widgets/my_drop_down_button.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

Map<String, dynamic> fields = {};

class AddPasswordScreen extends StatefulWidget {
  static const id = 'add_password_screen';

  @override
  _AddPasswordScreenState createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  List<String> textFieldStrings = ['Title', 'Email', 'Password', 'Username'];
  List<String> dropDownFields = ['Email', 'Username', 'Phone', 'Link'];
  final TextEditingController _controller = TextEditingController();

  String customFieldKey = "";

  @override
  void initState() {
    super.initState();
    fields = {};
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
            color: Theme.of(context).accentColor,
          ),
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
                        if (fields['Title'] == null ||
                            fields['Title'].trim() == "") {
                          Functions.showSnackBar(
                              context, 'Title is a mandatory field !');
                        } else {
                          bool addPasswordSuccessful;
                          Functions.popKeyboard(context);

                          data.startLoadingScreen();

                          fields['Title'] =
                              Functions.capitalizeFirstLetter(fields['Title']);
                          addPasswordSuccessful =
                              await data.addPasswordFieldToDatabase(fields);
                          if (addPasswordSuccessful) {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Added ${fields['Title']}");
                          } else {
                            Functions.showSnackBar(
                                context, 'Error adding new password !');
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
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  ColumnBuilder(
                    itemBuilder: (context, index) {
                      return MyTextField(
                          key: ObjectKey(textFieldStrings[index]),
                          labelText: textFieldStrings[index],
                          autofocus: textFieldStrings[index] == "Title",
                          onChanged: (String value) {
                            setState(() {
                              fields[textFieldStrings[index]] = value;
                            });
                          },
                          trailingFunction: () {
                            fields.remove(textFieldStrings[index]);
                            setState(() {
                              textFieldStrings.removeAt(index);
                            });
                          });
                    },
                    itemCount: textFieldStrings.length,
                  ),
                  Builder(
                    builder: (context) {
                      return MyDropDownButton(
                        dropDownOnChanged: (String newValue) {
                          setState(() {
                            if (!textFieldStrings.contains(newValue))
                              textFieldStrings.add(newValue);
                            else
                              Functions.showSnackBar(
                                  context, "$newValue already exists !!");
                          });
                        },
                        dropDownFields: this.dropDownFields,
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return MyTextField(
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
                          } else if (customFieldKey != "" &&
                              customFieldKey != null)
                            Functions.showSnackBar(
                                context, "$customFieldKey already exists !!");
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
