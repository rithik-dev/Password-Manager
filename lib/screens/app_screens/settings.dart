import 'package:flutter/material.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screens/change_name_screen.dart';
import 'package:password_manager/screens/app_screens/change_password_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/my_alert_dialog.dart';
import 'package:password_manager/widgets/settings_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(Settings());

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ProviderClass>(
        builder: (context,data,child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Scaffold(
              // waiting to load the name of the user
              body: (data.name == null)
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                children: <Widget>[
                  SettingsCard(
                    text: "Change Name",
                    onPressed: () async{
                      Navigator.pushNamed(context, ChangeNameScreen.id);
                    },
                  ),
                  SettingsCard(
                    text: "Change Password",
                    onPressed: () async{
                      Navigator.pushNamed(context, ChangePasswordScreen.id);
                    },
                  ),
                  SettingsCard(
                    text: "Delete Account",
                    onPressed: () async{
                      Functions.showAlertDialog(context, MyAlertDialog(
                        text: "Delete Account ?",
                        content: "Are you sure you want to delete this account ?",
                        continueButtonOnPressed: () async{
                          bool deleteUserSuccessful = await FirebaseUtils.deleteCurrentUser();
                          if(deleteUserSuccessful) {
                            await FirebaseUtils.logoutUser();
                            data.setDataToNull();
                            Navigator.pop(context);
                            Navigator.pushNamed(context, RegisterScreen.id);
                          }
                          else {
                            Functions.showSnackBar(context, "Failed to Delete Account. Please Login Again and Try Again !",
                                duration: Duration(seconds: 2));
                          }
                        },
                      ));
                    },
                  ),
                  SettingsCard(
                    text:
                    "Logout  :  ${data.name}",
                    onPressed: () async {
                      await FirebaseUtils.logoutUser();
                      data.setDataToNull();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
