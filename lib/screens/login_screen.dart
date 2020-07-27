import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/firebase_utils.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:password_manager/widgets/rounded_button.dart';

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
        Navigator.pushNamed(context, AppScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kTheme,
      home: SafeArea(
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
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: "Enter email.."),
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
                    final loginSuccessful =
                        await FirebaseUtils.loginUser(_email, _password);

                    if (loginSuccessful)
                      Navigator.pushNamed(context, AppScreen.id);
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
  }
}
