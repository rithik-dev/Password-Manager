import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/exceptions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChangeEmailScreen extends StatelessWidget {
  static const id = 'change_email_screen';
  String newEmail;
  String password;
  final _formKey = GlobalKey<FormState>();

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
              title: Text("Change Email"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    MyTextField(
                      labelText: "New Email",
                      showTrailingWidget: false,
                      autofocus: true,
                      validator: (String _email) {
                        if (_email == null || _email.trim() == "")
                          return "Please Enter New Email";
                        else if (_email.trim() == data.loggedInUser.email)
                          return "Please Enter New Email";
                        else if (!(_email.contains(".") &&
                            _email.contains("@"))) return "Invalid Email";
                        return null;
                      },
                      onChanged: (String value) {
                        newEmail = value;
                      },
                    ),
                    MyTextField(
                      labelText: "Password",
                      validator: (String _password) {
                        if (_password == null || _password.trim() == "")
                          return "Please Enter Password";
                        return null;
                      },
                      onChanged: (String value) {
                        password = value;
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return RoundedButton(
                          text: "Change Email",
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              Functions.popKeyboard(context);
                              data.startLoadingScreen();

                              try {
                                final bool changeSuccessful =
                                    await FirebaseUtils.changeCurrentUserEmail(
                                  newEmail: this.newEmail.trim(),
                                  password: this.password,
                                );

                                if (changeSuccessful) {
                                  Navigator.pop(context);
                                  await FirebaseUtils.logoutUser();
                                  data.setDataToNull();
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.id,
                                      arguments: {
                                        'defaultEmail': this.newEmail.trim(),
                                        'defaultPassword': this.password,
                                      });
                                  Fluttertoast.showToast(
                                    msg:
                                        "Email Changed Successfully !\nPlease Verify New Email and Login",
                                    gravity: ToastGravity.TOP,
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else
                                  Functions.showSnackBar(context,
                                      "An Error Occurred While Changing Email");
                              } on ChangePasswordException catch (e) {
                                Functions.showSnackBar(context, e.message,
                                    duration: Duration(seconds: 3));
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
            ),
          );
        },
      ),
    );
  }
}
