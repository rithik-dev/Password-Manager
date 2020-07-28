import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/my_text_field.dart';
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
                Flexible(child: Icon(Icons.security, size: 100.0)),
                SizedBox(height: 70.0),
                MyTextField(
                  labelText: "First Name",
                  onChanged: (String firstName) {
                    _fname = firstName.trim().toLowerCase();
                    _fname = '${_fname[0].toUpperCase()}${_fname.substring(1)}';
                  },
                ),
                SizedBox(height: 5.0),
                MyTextField(
                  labelText: "Last Name",
                  onChanged: (String lastName) {
                    _lname = lastName.trim().toLowerCase();
                    _lname = '${_lname[0].toUpperCase()}${_lname.substring(1)}';
                  },
                ),
                SizedBox(height: 5.0),
                MyTextField(
                  labelText: "Email",
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
                        Provider.of<ProviderClass>(context, listen: false)
                            .startLoadingScreen();

                        final registerSuccessful =
                            await FirebaseUtils.registerUser(_email, _password,
                                firstName: _fname, lastName: _lname);

                        if (registerSuccessful) {
                          Provider.of<ProviderClass>(context, listen: false)
                              .getAppData();
                          Navigator.pushNamed(context, AppScreen.id);
                        } else {
                          final snackBar = SnackBar(
                              content: Text('Registering new user failed !'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }

                        Provider.of<ProviderClass>(context, listen: false)
                            .stopLoadingScreen();
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
