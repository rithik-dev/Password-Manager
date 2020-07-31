import 'package:flutter/material.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screens/app_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:provider/provider.dart';

class InitialScreenHandler extends StatefulWidget {
  @override
  _InitialScreenHandlerState createState() => _InitialScreenHandlerState();
}

class _InitialScreenHandlerState extends State<InitialScreenHandler> {
  Widget getInitialScreen(){
    if (Provider.of<ProviderClass>(context).userLoggedIn == null)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    else if (Provider.of<ProviderClass>(context).userLoggedIn == true) {
      Provider.of<ProviderClass>(context, listen: false).getAppData();
      return AppScreen();
    } else
      return LoginScreen();
  }

  @override
  void initState() {
    super.initState();

    setUserLoggedIn();
  }

  void setUserLoggedIn() async {
    await Provider.of<ProviderClass>(context, listen: false).setUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return getInitialScreen();
  }
}
