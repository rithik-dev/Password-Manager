import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/edit_password_screen.dart';
import 'package:password_manager/widgets/my_alert_dialog.dart';
import 'package:provider/provider.dart';

//TODO: re order text fields display order

class ShowPasswordDetails extends StatelessWidget {
  final Map<String,dynamic> fields;

  ShowPasswordDetails(this.fields);

  @override
  Widget build(BuildContext context) {
    List<String> keys = fields.keys.toList();
    keys.remove("documentId");

    return Scaffold(
      body: Container(
        color: Color(0xFF000014),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("  " + fields['Title'].toUpperCase(),
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit, size: 30.0),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditPasswordScreen(fields)),
                          );
                        },
                      ),
                      SizedBox(width: 10.0),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: Icon(Icons.delete, size: 30.0),
                            onPressed: () async {
                              Functions.showAlertDialog(context, MyAlertDialog(
                                text: "Delete ${fields['Title'].toUpperCase()} ?",
                                content: "Are you sure you want to delete ${fields['Title'].toUpperCase()} ?\n\nThis action is irreversible !",
                                cancelButtonOnPressed: () {
                                  Navigator.pop(context);
                                },
                                continueButtonOnPressed:  () async {
                                  bool deletePasswordSuccessful;

                                  deletePasswordSuccessful = await Provider.of<ProviderClass>(context, listen: false)
                                      .deletePassword(fields['documentId']);

                                  if (deletePasswordSuccessful) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    Functions.showSnackBar(context, 'Error deleting password !');
                                  }
                                },
                              ));
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15.0),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      color: kCardBackgroundColor,
                      child: Builder(
                        builder: (context) {
                          return ListTile(
                            title: Text(keys[index]),
                            subtitle: Text(fields[keys[index]]),
                            trailing: IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () {
                                Functions.copyToClipboard(fields[keys[index]]);
                                Functions.showSnackBar(context, "${keys[index]} Copied !");
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  itemCount: fields.length - 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
