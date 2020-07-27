import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/firebase_utils.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/rounded_button.dart';

void main() => runApp(Settings());

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RoundedButton(
                text: "Logout",
                onPressed: () async {
                  await FirebaseUtils.logoutUser();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
