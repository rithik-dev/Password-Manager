import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/register_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kTheme,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        AppScreen.id: (context) => AppScreen(),
      },
      home: LoginScreen(),
    );
  }
}
