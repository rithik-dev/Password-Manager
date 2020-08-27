import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/exceptions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  static const id = 'change_password_screen';
  String newPassword;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ProviderClass>(context).showLoadingScreen,
      progressIndicator: SpinKitChasingDots(
        color: Theme.of(context).accentColor,
      ),
      child: Consumer<ProviderClass>(
        builder: (context, data, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Change Password"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  MyTextField(
                    labelText: "New Password",
                    autofocus: true,
                    onChanged: (String value) {
                      newPassword = value;
                    },
                  ),
                  SizedBox(height: 10.0),
                  Builder(
                    builder: (context) {
                      return RoundedButton(
                        text: "Change Password",
                        onPressed: () async {
                          if(newPassword == null)
                            Functions.showSnackBar(context, "Please Enter New Password !");
                          else {
                            data.startLoadingScreen();

                            try {
                              final bool changeSuccessful = await FirebaseUtils.changeCurrentUserPassword(newPassword);

                              if (changeSuccessful) {
                                Navigator.pop(context);
                                FirebaseUtils.logoutUser();
                                Navigator.pop(context);
                                Navigator.pushNamed(context, LoginScreen.id);
                              }
                              else
                                Functions.showSnackBar(context, "An Error Occurred While Changing Password");
                            } on ChangePasswordException catch(e) {
                              Functions.showSnackBar(context, e.message,duration: Duration(seconds: 3));
                            }

                            data.stopLoadingScreen();
                          }

                        },
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
