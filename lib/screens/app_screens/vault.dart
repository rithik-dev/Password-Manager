import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/edit_password_screen.dart';
import 'package:password_manager/widgets/my_alert_dialog.dart';
import 'package:password_manager/widgets/password_card.dart';
import 'package:password_manager/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyVault());

class MyVault extends StatefulWidget {
  @override
  _MyVaultState createState() => _MyVaultState();
}

class _MyVaultState extends State<MyVault> {
//  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
////    _controller = TextEditingController();
//    Provider.of<ProviderClass>(context, listen: false).setSearchController();
    print("initstate called");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<ProviderClass>(context).disposeSearchController();
    print("dispose c");
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Consumer<ProviderClass>(
            builder: (context, data, child) {
              return (data.passwords == null)
                  ? SpinKitChasingDots(
                      color: Theme.of(context).accentColor,
                    )
                  : Column(
                      children: [
                  data.searchController.text != ""
                      ? SizedBox.shrink()
                      : Padding(
                    padding:
                    const EdgeInsets.fromLTRB(10, 15, 20, 15),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Passwords",
                          style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ProfilePicture(data.profilePicURL),
                      ],
                    ),
                  ),
                  (data.passwords.length == 0)
                      ? Expanded(
                    child: Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Lottie.asset(
                            'assets/lottie/404.json',
                            height: 150,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                          SizedBox(height: 30),
                          Text(
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
                        ],
                      ),
                    ),
                  )
                      : _passwordCardsView(
                      context, data, data.searchController,
                      onChangedCallback: (String value) {
                        data.setSearchText(value);
                        data.setFilteredPasswords(data.passwords
                            .where((element) =>
                            element['Title']
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList());
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _passwordCardsView(BuildContext context, data,
    TextEditingController controller,
    {onChangedCallback}) {
  return Expanded(
    child: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return;
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: TextField(
              controller: controller,
              onChanged: (String value) => onChangedCallback(value),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Icon(Icons.search),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Functions.popKeyboard(context);
                    controller.clear();
                    data.setFilteredPasswords(data.passwords);
                  },
                ),
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (DismissDirection direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      data.setShowPasswordFields(data.filteredPasswords[index]);
                      Navigator.pushNamed(context, EditPasswordScreen.id);
                    } else if (direction == DismissDirection.endToStart) {
                      data.setShowPasswordFields(data.filteredPasswords[index]);
                      Functions.showAlertDialog(
                          context,
                          MyAlertDialog(
                            text:
                            "Delete ${data.showPasswordFields['Title']
                                .toUpperCase()} ?",
                            content:
                            "Are you sure you want to delete ${data
                                .showPasswordFields['Title'].toUpperCase()} ?",
                            continueButtonOnPressed: () async {
                              bool deletePasswordSuccessful;

                              Navigator.pop(context);

                              data.startLoadingScreenOnMainAppScreen();
                              // not using provider as document id is never changed
                              final String title =
                              data.filteredPasswords[index]['Title'];
                              deletePasswordSuccessful =
                              await data.deletePasswordFieldFromDatabase(
                                  data.filteredPasswords[index]
                                  ['documentId']);

                              data.stopLoadingScreenOnMainAppScreen();

//                              if (controller.text.trim() != "") {
//                                Functions.popKeyboard(context);
//                              }
                              data.setSearchTextToLastSearch();

                              Fluttertoast.showToast(msg: "Deleted $title");

                              if (!deletePasswordSuccessful)
                                Functions.showSnackBar(
                                    context, 'Error Deleting Password !');
                            },
                          ));
                    }
                  },
                  background: _slideRightBackground(),
                  secondaryBackground: _slideLeftBackground(),
                  child: PasswordCard(
                    data.filteredPasswords[index],
                  ),
                );
              },
              itemCount: data.filteredPasswords.length,
            ),
          ),
        ],
      ),
    ),
  );
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
