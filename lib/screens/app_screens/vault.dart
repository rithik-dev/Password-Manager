import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
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
  FocusNode _searchFocus = FocusNode();
  static final double kDefaultContainerHeight = 130;
  bool profilePicContainerExpanded = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchFocus.addListener(() {
      setState(() {
        profilePicContainerExpanded = !this._searchFocus.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Consumer<ProviderClass>(
            builder: (context, data, child) {
              return (data.passwords == null)
                  ? Lottie.asset('assets/lottie/loading_vault.json')
                  : Column(
                      children: [
                        AnimatedContainer(
                          padding: EdgeInsets.fromLTRB(10, 15, 20, 0),
                          curve: Curves.easeInOutQuad,
                          duration: Duration(milliseconds: 300),
                          height: (profilePicContainerExpanded ||
                                  data.passwords.length == 0)
                              ? kDefaultContainerHeight
                              : 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  "Passwords",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                        height: 200,
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
                            : _passwordCardsView(context, data,
                                data.searchController, _searchFocus,
                                onChangedCallback: (String value) {
                                data.setSearchText(value);
                                data.setFilteredPasswords(data.passwords
                                    .where((element) => element['Title']
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
    TextEditingController controller, FocusNode searchFocusNode,
    {onChangedCallback}) {
  return Expanded(
    child: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return;
      },
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Color(0xFF111d5e),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: searchFocusNode,
                    textAlignVertical: TextAlignVertical.center,
                    controller: controller,
                    onChanged: onChangedCallback,
                    cursorColor: Colors.tealAccent,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.tealAccent,
                      ),
                      border: InputBorder.none,
                      hintText: "Search",
                    ),
                  ),
                ),
                (searchFocusNode.hasFocus ||
                        (controller?.text != null && controller?.text != ""))
                    ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          size: 25,
                          color: Colors.tealAccent,
                        ),
                        splashRadius: 1,
                        onPressed: () {
                          Functions.popKeyboard(context);
                          data.setSearchText("");
                          controller.clear();
                          data.setFilteredPasswords(data.passwords);
                        },
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                if (data.filteredPasswords[index]['Title'][0] !=
                    data.filteredPasswords[index + 1]['Title'][0])
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Text(
                      data.filteredPasswords[index + 1]['Title'][0],
                      style: TextStyle(
                        color: Color(0xFF7D8AB7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                else
                  return SizedBox.shrink();
              },
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
