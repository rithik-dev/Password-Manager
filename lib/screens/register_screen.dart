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

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  static const id = 'register_screen';
  String _email, _password, _firstName, _lastName;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return ModalProgressHUD(
          progressIndicator: SpinKitChasingDots(
            color: Theme.of(context).accentColor,
          ),
          inAsyncCall: data.showLoadingScreen,
          child: SafeArea(
            child: Scaffold(
              body: Center(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    children: <Widget>[
                      SizedBox(height: 70.0),
                      MyTextField(
                        labelText: "First Name",
                        showTrailingWidget: false,
                        autofocus: true,
                        validator: (String firstName) {
                          if (firstName == null || firstName.trim() == "")
                            return "Please Enter First Name";

                          return null;
                        },
                        onChanged: (String firstName) {
                          _firstName =
                              Functions.capitalizeFirstLetter(firstName);
                        },
                      ),
                      SizedBox(height: 5.0),
                      MyTextField(
                        labelText: "Last Name",
                        validator: (String lastName) {
                          if (lastName == null || lastName.trim() == "")
                            return "Please Enter Last Name";

                          return null;
                        },
                        showTrailingWidget: false,
                        onChanged: (String lastName) {
                          _lastName = Functions.capitalizeFirstLetter(lastName);
                        },
                      ),
                      SizedBox(height: 5.0),
                      MyTextField(
                        labelText: "Email",
                        showTrailingWidget: false,
                        validator: (String email) {
                          if (email == null || email.trim() == "")
                            return "Please Enter Email";
                          else if (!(email.contains(".") &&
                              email.contains("@"))) return "Invalid Email";

                          return null;
                        },
                        onChanged: (String email) {
                          _email = email.trim().toLowerCase();
                        },
                      ),
                      SizedBox(height: 5.0),
                      MyTextField(
                        labelText: "Password",
                        validator: (String password) {
                          if (password == null || password.trim() == "")
                            return "Please Enter Password";
                          return null;
                        },
                        onChanged: (String password) {
                          _password = password;
                        },
                      ),
                      Builder(
                        builder: (context) {
                          return RoundedButton(
                            text: "Register",
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                data.startLoadingScreen();

                                bool registerSuccessful;

                                try {
                                  registerSuccessful =
                                  await FirebaseUtils.registerUser(
                                      _email, _password,
                                      fullName: "$_firstName $_lastName");

                                  if (registerSuccessful) {
                                    Functions.showSnackBar(
                                        context, "Verification Email Sent !");
                                  } else {
                                    Functions.showSnackBar(context,
                                        'Registering New User Failed !');
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
          ),
        );
      },
    );
  }
}
