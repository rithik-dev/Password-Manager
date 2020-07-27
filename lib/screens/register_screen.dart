import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

//TODO: error handling , show users snackbar if password wrong , email already in use etc.

class _RegisterScreenState extends State<RegisterScreen> {
  String _email, _password, _fname, _lname;

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
                  Flexible(child: Icon(Icons.security, size: 100.0)),
                  SizedBox(height: 70.0),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Enter first name.."),
                    onChanged: (String firstName) {
                      _fname = firstName.trim().toLowerCase();
                      _fname =
                          '${_fname[0].toUpperCase()}${_fname.substring(1)}';
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Enter last name.."),
                    onChanged: (String lastName) {
                      _lname = lastName.trim().toLowerCase();
                      _lname =
                          '${_lname[0].toUpperCase()}${_lname.substring(1)}';
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Enter email.."),
                    onChanged: (String email) {
                      _email = email.trim().toLowerCase();
                    },
                  ),
                  SizedBox(height: 10.0),
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
                      Provider.of<ProviderClass>(context, listen: false)
                          .startLoadingScreen();

                      final registerSuccessful =
                          await FirebaseUtils.registerUser(_email, _password,
                              firstName: _fname, lastName: _lname);

                      if (registerSuccessful) {
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
      ),
    );
  }
}
