import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

void main() => runApp(Settings());

//TODO: change passwords, change theme

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: Scaffold(
          // waiting to load the name of the user
          body: (Provider.of<ProviderClass>(context).name == null)
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RoundedButton(
                      text:
                          "Logout  :  ${Provider.of<ProviderClass>(context).name}",
                      onPressed: () async {
                        await FirebaseUtils.logoutUser();
                        Provider.of<ProviderClass>(context, listen: false)
                            .setNameToNull();
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
