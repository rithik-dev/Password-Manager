import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }

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

  //TODO: error handling , show users snackbar if password wrong etc.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kTheme,
      home: ModalProgressHUD(
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
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Enter email.."),
                    onChanged: (String email) {
                      _email = email.trim().toLowerCase();
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Enter password.."),
                    obscureText: true,
                    onChanged: (String password) {
                      _password = password;
                    },
                  ),
                  RoundedButton(
                    text: "Login",
                    onPressed: () async {
                      Provider.of<ProviderClass>(context, listen: false)
                          .startLoadingScreen();
                      final loginSuccessful =
                          await FirebaseUtils.loginUser(_email, _password);

                      if (loginSuccessful) {
                        Provider.of<ProviderClass>(context, listen: false)
                            .getAppData();
                        Navigator.pushNamed(context, AppScreen.id);
                      }

                      Provider.of<ProviderClass>(context, listen: false)
                          .stopLoadingScreen();
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
      ),
    );
  }
}
