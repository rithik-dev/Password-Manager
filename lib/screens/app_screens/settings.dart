import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/models/exceptions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screens/change_email_screen.dart';
import 'package:password_manager/screens/app_screens/change_name_screen.dart';
import 'package:password_manager/screens/app_screens/change_password_screen.dart';
import 'package:password_manager/screens/app_screens/edit_profile_picture_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/my_alert_dialog.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/profile_picture.dart';
import 'package:password_manager/widgets/settings_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(Settings());

// ignore: must_be_immutable
class Settings extends StatelessWidget {
  String password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<ProviderClass>(
      builder: (context, data, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Scaffold(
            // waiting to load the name of the user
            body: (data.name == null)
                ? Center(
                    child: SpinKitChasingDots(
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Stack(
                            children: [
                              ProfilePicture(data.profilePicURL, radius: 60),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.black,
                                  child: IconButton(
                                    iconSize: 15,
                                    color: Colors.white,
                                    icon: Icon(Icons.edit),
                                    onPressed: () => showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          EditProfilePictureScreen(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                data.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.1),
                              ),
                              SizedBox(height: 15),
                              Text(
                                data.loggedInUser.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(letterSpacing: 0.5),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overScroll) {
                            overScroll.disallowGlow();
                            return;
                          },
                          child: ListView(
                            children: <Widget>[
                              SettingsCard(
                                text: "Change Name",
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ChangeNameScreen.id);
                                },
                              ),
                              SettingsCard(
                                text: "Change Email",
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ChangeEmailScreen.id);
                                },
                              ),
                              SettingsCard(
                                text: "Change Password",
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ChangePasswordScreen.id);
                                },
                              ),
                              SettingsCard(
                                text: "Forgot Password",
                                onPressed: () async {
                                  data.startLoadingScreenOnMainAppScreen();

                                  try {
                                    bool passwordResetEmailSent = await data
                                        .sendPasswordResetEmailForLoggedInUser();
                                    if (passwordResetEmailSent)
                                      Functions.showSnackBar(context,
                                          "Password Reset Email Sent !");
                                    else
                                      Functions.showSnackBar(context,
                                          "An Error Occurred While Sending Password Reset Email !");
                                  } on ForgotPasswordException catch (e) {
                                    Functions.showSnackBar(context, e.message,
                                        duration: Duration(seconds: 3));
                                  } catch (e) {
                                    print(
                                        "FORGOT PASSWORD EXCEPTION ${e.message}");
                                  }

                                  data.stopLoadingScreenOnMainAppScreen();
                                },
                              ),
                              SettingsCard(
                                text: "Delete Account",
                                onPressed: () async {
                                  Functions.showAlertDialog(
                                      context,
                                      MyAlertDialog(
                                        text: "Delete Account ?",
                                        content:
                                            "Are you sure you want to delete this account ?",
                                        passwordTextField: Form(
                                          key: _formKey,
                                          child: MyTextField(
                                            labelText: "Password",
                                            autofocus: true,
                                            onChanged: (String _password) {
                                              this.password = _password;
                                            },
                                            validator: (String _password) {
                                              if (_password == null ||
                                                  _password.trim() == "")
                                                return "Please Enter Password";
                                              return null;
                                            },
                                          ),
                                        ),
                                        continueButtonOnPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            try {
                                              Navigator.pop(context);

                                              data.startLoadingScreenOnMainAppScreen();

                                              bool deleteUserSuccessful =
                                                  await FirebaseUtils
                                                      .deleteCurrentUser(
                                                oldImageURL: data.profilePicURL,
                                                password: password,
                                              );

                                              if (deleteUserSuccessful) {
                                                await FirebaseUtils
                                                    .logoutUser();
                                                data.setDataToNull();
                                                Navigator.pushReplacementNamed(
                                                    context, RegisterScreen.id);
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Account Deleted Successfully",
                                                  gravity: ToastGravity.TOP,
                                                );
                                              } else {
                                                Functions.showSnackBar(context,
                                                    "Failed to Delete Account. Please Try Again !",
                                                    duration:
                                                        Duration(seconds: 2));
                                              }
                                            } on DeleteUserException catch (e) {
                                              Functions.showSnackBar(
                                                  context, e.message,
                                                  duration:
                                                      Duration(seconds: 3));
                                            } finally {
                                              data.stopLoadingScreenOnMainAppScreen();
                                            }
                                          }
                                        },
                                      ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    ));
  }
}
