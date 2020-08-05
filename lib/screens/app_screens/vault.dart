import 'package:flutter/material.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/edit_password_screen.dart';
import 'package:password_manager/widgets/my_alert_dialog.dart';
import 'package:password_manager/widgets/password_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyVault());

class MyVault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Consumer<ProviderClass>(
            builder: (context, data, child) {
              return (data.passwords == null)
                  ? CircularProgressIndicator()
                  : (data.passwords.length == 0)
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              """
No passwords added yet. Start by adding a new password by clicking the + icon on the top right.
                              
                              
Swipe right to instantly edit a card.

Swipe left to instantly delete a card.

OR
            
Tap on the card for more information ...
                              
                              """,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: UniqueKey(),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    data.setShowPasswordFields(
                                        data.passwords[index]);
                                    Navigator.pushNamed(
                                        context, EditPasswordScreen.id);
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    data.setShowPasswordFields(
                                        data.passwords[index]);
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

                                            // not using provider as document id is never changed
                                            deletePasswordSuccessful = await data
                                                .deletePasswordFieldFromDatabase(
                                                    data.passwords[index]
                                                        ['documentId']);

                                            if (!deletePasswordSuccessful)
                                              Functions.showSnackBar(context,
                                                  'Error Deleting Password !');
                                          },
                                        ));
                                  }
                                },
                                background: slideRightBackground(),
                                secondaryBackground: slideLeftBackground(),
                                child: PasswordCard(
                                  data.passwords[index],
                                ),
                              );
                            },
                            itemCount: data.passwords.length,
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}
