import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/firebase_utils.dart';

Map<String, dynamic> fields = {};

class AddPasswordScreen extends StatefulWidget {
  static const id = 'add_password_screen';

  @override
  _AddPasswordScreenState createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  String tempKey;
  String dropDownValue = "Email";
  List<String> dropDownFields = ['Email', 'Username', 'Phone', 'Link'];
  List<String> fieldsCreated = ['Title', 'Password'];

  List<Widget> textFields = [
    MyTextField(labelText: "Title"),
    MyTextField(labelText: "Password")
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fields = {};
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
          child: ListView(
            children: <Widget>[
              Column(children: textFields),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ListTile(
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
                        icon: Icon(Icons.add, size: 40.0),
                        color: Colors.blue,
                        disabledColor: Colors.grey,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          if (!fieldsCreated.contains(dropDownValue)) {
                            if (!(dropDownValue == null ||
                                dropDownValue == "")) {
                              print("ADDING NEW DROPDOWN FIELD $dropDownValue");
                              fieldsCreated.add(dropDownValue);
                              print("FIELDS CREATED : $fieldsCreated");
                              setState(() {
                                textFields.add(
                                  MyTextField(
                                    labelText: dropDownValue,
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        fieldsCreated.remove(dropDownValue);
                                        fields.remove(dropDownValue);
                                        setState(() {
                                          textFields
                                              .removeAt(textFields.length - 1);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              });
                            } else
                              print("DROPDOWN VALUE NULL OR EMPTY");
                          } else {
                            print("ERROR ADDING NEW FIELD");
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      title: TextField(
                        onChanged: (tempValue) {
                          tempKey = tempValue.trim();
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Custom Field Name",
                            labelText: "Custom Field Name"),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add, size: 40.0),
                        color: Colors.blue,
                        disabledColor: Colors.grey,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          if (!fieldsCreated.contains(tempKey)) {
                            if (!(tempKey == null || tempKey == "")) {
                              print("ADDING NEW CUSTOM FIELD");
                              fieldsCreated.add(tempKey);
                              print("FIELDS CREATED : $fieldsCreated");
                              setState(() {
                                textFields.add(
                                  MyTextField(
                                    labelText: tempKey,
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        print("tempkey $tempKey");
                                        //FIXME: fieldsCreated does not remove tempKey
                                        fieldsCreated.remove(tempKey);

                                        print("created $fieldsCreated");
                                        fields.remove(tempKey);
                                        print("fields $fields");
                                        setState(() {
                                          textFields
                                              .removeAt(textFields.length - 1);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              });
                              tempKey = "";
                            }
                          } else {
                            print("ERROR ADDING NEW FIELD");
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              FlatButton(
                child: Text("ADD PASSWORD"),
                onPressed: () async {
                  bool addPasswordSuccessful;
                  addPasswordSuccessful =
                      await FirebaseUtils.addPassword(fields);
                  if (addPasswordSuccessful) Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String labelText;
  final Widget trailing;

  MyTextField({this.labelText, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: TextField(
          onChanged: (value) {
            fields[this.labelText] = value;
          },
          obscureText: this.labelText == "Password",
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter ${this.labelText}",
              labelText: this.labelText),
        ),
        trailing: this.trailing);
  }
}
