import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//TODO: error handling , show users snack bar if password wrong etc.

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;

  void getCurrentUser() async {
    try {
      final user = await FirebaseUtils.getCurrentUser();
      if (user != null) {
        Provider.of<ProviderClass>(context, listen: false).getAppData();
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
                            data.startLoadingScreen();

                            final loginSuccessful =
                            await FirebaseUtils.loginUser(_email, _password);

                            if (loginSuccessful) {
                              data.getAppData();
                              Navigator.pushNamed(context, AppScreen.id);
                            } else {
                              Functions.showSnackBar(context, 'Login Unsuccessful ! Email or password is wrong.');
                            }

                            data.stopLoadingScreen();
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text("Register?"),
                          onPressed: () {
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
