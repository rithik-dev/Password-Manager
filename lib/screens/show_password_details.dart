import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/edit_password_screen.dart';
import 'package:password_manager/widgets/my_alert_dialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ShowPasswordDetails extends StatelessWidget {
  Map<String, dynamic> _fields;

  @override
  Widget build(BuildContext context) {
    _fields = Provider.of<ProviderClass>(context).showPasswordFields;

    List<String> tempKeys = _fields.keys.toList();
    tempKeys.remove("documentId");

    final List<String> keys = Functions.reorderTextFieldsDisplayOrder(tempKeys);

    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return Scaffold(
          backgroundColor: kSecondaryColor,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        data.showPasswordFields['Title'].toUpperCase(),
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit, size: 30.0),
                          onPressed: () {
                            data.setShowPasswordFields(data.showPasswordFields);
                            Navigator.pushNamed(context, EditPasswordScreen.id);
                          },
                        ),
                        SizedBox(width: 10.0),
                        Builder(
                          builder: (context) {
                            return IconButton(
                              icon: Icon(Icons.delete, size: 30.0),
                              onPressed: () async {
                                Functions.showAlertDialog(
                                    context,
                                    MyAlertDialog(
                                      text:
                                          "Delete ${data.showPasswordFields['Title'].toUpperCase()} ?",
                                      content:
                                          "Are you sure you want to delete ${data.showPasswordFields['Title'].toUpperCase()} ?",
                                      continueButtonOnPressed: () async {
                                        bool deletePasswordSuccessful;

                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        data.startLoadingScreenOnMainAppScreen();

                                        // not using provider as document id is never changed
                                        deletePasswordSuccessful = await data
                                            .deletePasswordFieldFromDatabase(
                                                _fields['documentId']);

                                        data.stopLoadingScreenOnMainAppScreen();
                                        if (!deletePasswordSuccessful)
                                          Functions.showSnackBar(context,
                                              'Error Deleting Password !');
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
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        color: kCardBackgroundColor,
                        child: Builder(
                          builder: (context) {
                            return ListTile(
                              title: Text(keys[index]),
                              subtitle:
                                  Text(data.showPasswordFields[keys[index]]),
                              isThreeLine:
                                  data.showPasswordFields[keys[index]].length >
                                  30,
                              trailing: IconButton(
                                icon: Icon(Icons.content_copy),
                                onPressed: () {
                                  Functions.copyToClipboard(
                                      data.showPasswordFields[keys[index]]);
                                  Functions.showSnackBar(context,
                                      "${keys[index]} Copied : ${data
                                          .showPasswordFields['Title']}");
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                    itemCount: data.showPasswordFields.length - 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
