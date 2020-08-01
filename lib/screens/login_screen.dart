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

class LoginScreen extends StatelessWidget {
  static const id = 'login_screen';
  String _email, _password;

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
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: Icon(Icons.security, size: 100.0)),
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
                            if(_email==null || _email.trim()=="")
                              Functions.showSnackBar(context, "Please Enter your Email Address !");
                            else if(_password==null)
                              Functions.showSnackBar(context, "Please Enter your Password !");
                            else {
                              data.startLoadingScreen();

                              bool loginSuccessful;

                              try {
                                loginSuccessful = await FirebaseUtils.loginUser(_email, _password);

                                if (loginSuccessful) {
                                  await data.setLoggedInUser();
                                  await data.getAppData();
                                Navigator.pushReplacementNamed(context, AppScreen.id);
                                } else {
                                  Functions.showSnackBar(context, 'Login Unsuccessful !');
                                }
                              } on LoginException catch(e){
                                if(e.message != null) {
                                  if(e.message == "EMAIL_NOT_VERIFIED")
                                    Functions.showSnackBar(context, "Please Verify Your Email Address !",duration:Duration(seconds: 3),
                                        action: SnackBarAction(
                                      label: "RESEND LINK !",
                                      textColor: Colors.white,
                                      onPressed: () async{

                                        data.startLoadingScreen();

                                        final bool success = await FirebaseUtils.resendEmailVerificationLink(_email, _password);
                                        if(success)
                                          Functions.showSnackBar(context, "Email Verification Link Sent Successfully !");
                                        else
                                          Functions.showSnackBar(context, "An Error Occurred While Sending Email Verification Link !");

                                        data.stopLoadingScreen();
                                        },
                                    ));
                                  else
                                    Functions.showSnackBar(context, e.message,duration: Duration(seconds: 3));
                                }

                              } on AppDataReceiveException catch(e) {
                                Functions.showSnackBar(context, e.message,duration: Duration(seconds: 5));
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text("Register?"),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, RegisterScreen.id);
                              },
                            )
                          ],
                        )
                      ],
                    ),
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
