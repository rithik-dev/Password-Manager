import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:password_manager/models/exceptions.dart';

class RegisterScreen extends StatelessWidget {
  static const id = 'register_screen';
  String _email, _password, _firstName, _lastName;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return ModalProgressHUD(
          inAsyncCall: data.showLoadingScreen,
          child: SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: Icon(Icons.security, size: 100.0)),
                    SizedBox(height: 70.0),
                    MyTextField(
                      labelText: "First Name",
                      showTrailingWidget: false,
                      onChanged: (String firstName) {
                        _firstName = Functions.capitalizeFirstLetter(firstName);
                      },
                    ),
                    SizedBox(height: 5.0),
                    MyTextField(
                      labelText: "Last Name",
                      showTrailingWidget: false,
                      onChanged: (String lastName) {
                        _lastName = Functions.capitalizeFirstLetter(lastName);
                      },
                    ),
                    SizedBox(height: 5.0),
                    MyTextField(
                      labelText: "Email",
                      showTrailingWidget: false,
                      onChanged: (String email) {
                        _email = email.trim().toLowerCase();
                      },
                    ),
                    SizedBox(height: 5.0),
                    MyTextField(
                      labelText: "Password",
                      onChanged: (String password) {
                        _password = password;
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return RoundedButton(
                          text: "Register",
                          onPressed: () async {
                            if (_firstName == null || _firstName.trim() == "") {
                              Functions.showSnackBar(
                                  context, "Please Enter Your First Name !");
                            } else if (_lastName == null ||
                                _lastName.trim() == "") {
                              Functions.showSnackBar(
                                  context, "Please Enter Your Last Name !");
                            } else if (_email == null ||
                                _firstName.trim() == "") {
                              Functions.showSnackBar(
                                  context, "Please Enter Your Email Address !");
                            } else if (_password == null)
                              Functions.showSnackBar(
                                  context, "Please Enter Your Password !");
                            else {
                              data.startLoadingScreen();

                              bool registerSuccessful;

                              try {
                                registerSuccessful =
                                    await FirebaseUtils.registerUser(_email, _password, fullName: "$_firstName $_lastName");

                                if (registerSuccessful) {
                                  Functions.showSnackBar(
                                      context, "Verification Email Sent !");
                                } else {
                                  Functions.showSnackBar(
                                      context, 'Registering New User Failed !');
                                }
                              } on RegisterException catch (e) {
                                Functions.showSnackBar(context, e.message,
                                    duration: Duration(seconds: 3));
                              } catch (e) {
                                print("REGISTER EXCEPTION : ${e.message}");
                              }

                              data.stopLoadingScreen();
                            }
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text("Login?"),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
