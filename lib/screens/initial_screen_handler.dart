import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screens/app_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:provider/provider.dart';

class InitialScreenHandler extends StatefulWidget {
  static const id = 'initial_screen_handler';

  @override
  _InitialScreenHandlerState createState() => _InitialScreenHandlerState();
}

class _InitialScreenHandlerState extends State<InitialScreenHandler> {
  void setInitialScreen() async {
    bool loggedIn = await Provider.of<ProviderClass>(context, listen: false)
        .setUserLoggedIn();

    if (loggedIn) {
      Provider.of<ProviderClass>(context, listen: false).getAppData();
      Navigator.pushReplacementNamed(context, AppScreen.id);
    } else
      Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  @override
  void initState() {
    super.initState();

    setInitialScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitChasingDots(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
