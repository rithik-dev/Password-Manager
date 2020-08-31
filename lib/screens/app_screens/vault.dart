import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/edit_password_screen.dart';
import 'package:password_manager/widgets/my_alert_dialog.dart';
import 'package:password_manager/widgets/password_card.dart';
import 'package:password_manager/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyVault());

class MyVault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        backgroundColor: kScaffoldBackgroundColor,
        onRefresh: () =>
            Provider.of<ProviderClass>(context, listen: false).getAppData(),
        child: Scaffold(
          body: Center(
            child: Consumer<ProviderClass>(
              builder: (context, data, child) {
                return (data.passwords == null)
                    ? SpinKitChasingDots(
                        color: Theme.of(context).accentColor,
                      )
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
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 15, 20, 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Passwords",
                                        style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ProfilePicture(
                                        "https://firebasestorage.googleapis.com/v0/b/eleventhhour-eb2e0.appspot.com/o/Courses%2F%20qgmB50hOxXJjIOOEBVUM%2Fthumbnail.jpg?alt=media&token=4be71194-d0e9-4769-b9ef-05e24f4d7bff",
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
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
                                                  continueButtonOnPressed:
                                                      () async {
                                                    bool
                                                        deletePasswordSuccessful;

                                                    Navigator.pop(context);

                                                    data.startLoadingScreenOnMainAppScreen();
                                                    // not using provider as document id is never changed
                                                    deletePasswordSuccessful =
                                                        await data
                                                            .deletePasswordFieldFromDatabase(
                                                                data.passwords[
                                                                        index][
                                                                    'documentId']);

                                                    data.stopLoadingScreenOnMainAppScreen();

                                                    if (!deletePasswordSuccessful)
                                                      Functions.showSnackBar(
                                                          context,
                                                          'Error Deleting Password !');
                                                  },
                                                ));
                                          }
                                        },
                                        background: _slideRightBackground(),
                                        secondaryBackground:
                                            _slideLeftBackground(),
                                        child: PasswordCard(
                                          data.passwords[index],
                                        ),
                                      );
                                    },
                                    itemCount: data.passwords.length,
                                  ),
                                ),
                              ],
                            ),
                          );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget _slideLeftBackground() {
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

Widget _slideRightBackground() {
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
