import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/firebase_utils.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/rounded_button.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email, _password;

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
                  text: "Register",
                  onPressed: () async {
                    final registerSuccessful =
                        await FirebaseUtils.registerUser(_email, _password);

                    if (registerSuccessful)
                      Navigator.pushNamed(context, AppScreen.id);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Login?"),
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
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
