import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screens/app_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:password_manager/models/exceptions.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;

  void getCurrentUser() async {
    try {
      final user = await FirebaseUtils.getCurrentUser();
      if (user != null) {
        Provider.of<ProviderClass>(context, listen: false).getAppData();
        //removing login screen from the stack if user is already logged in
        Navigator.pop(context);
        Navigator.pushNamed(context, AppScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(
      builder: (context,data,child) {
        return ModalProgressHUD(
          inAsyncCall: Provider.of<ProviderClass>(context).showLoadingScreen,
          child: SafeArea(
            child: Scaffold(
              body: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: Icon(Icons.security, size: 150.0)),
                    SizedBox(height: 70.0),
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
                          text: "Login",
                          onPressed: () async {
                            if(_email==null)
                              Functions.showSnackBar(context, "Please Enter your Email Address !");
                            else if(_password==null)
                              Functions.showSnackBar(context, "Please Enter your Password !");
                            else {
                              data.startLoadingScreen();

                              bool loginSuccessful;

                              try {
                                loginSuccessful = await FirebaseUtils.loginUser(_email, _password);

                                if (loginSuccessful) {
                                  data.getAppData();

                                  //removing login screen from the stack on successful login
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, AppScreen.id);
                                } else {
                                  Functions.showSnackBar(context, 'Login Unsuccessful !');
                                }
                              } on LoginException catch(e){
                                if(e.message != null)
                                  Functions.showSnackBar(context, e.message,duration: Duration(seconds: 3));
                              }
                              catch(e) {
                                print("LOGIN EXCEPTION : ${e.message}");
                              }

                              data.stopLoadingScreen();
                            }

                          },
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text("Forgot Password ?"),
                              onPressed: () async{
                                if(_email==null)
                                  Functions.showSnackBar(context, "Please Enter your Email Address !");
                                else {
                                  data.startLoadingScreen();

                                  try {
                                    bool passwordResetEmailSent = await FirebaseUtils.sendPasswordResetEmail(_email);
                                    if(passwordResetEmailSent)
                                      Functions.showSnackBar(context, "Password Reset Email Sent !");
                                    else
                                      Functions.showSnackBar(context, "An Error Occurred While Sending Password Reset Email !");
                                  } on ForgotPasswordException catch(e) {
                                    Functions.showSnackBar(context, e.message,duration: Duration(seconds: 3));
                                  } catch(e) {
                                    print("FORGOT PASSWORD EXCEPTION ${e.message}");
                                  }

                                  data.stopLoadingScreen();
                                }
                              },
                            )
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 1.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text("Register?"),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, RegisterScreen.id);
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
