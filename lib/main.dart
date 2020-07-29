import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/screens/app_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/register_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderClass>(
      create: (context) => ProviderClass(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: kScaffoldBackgroundColor,
          dialogBackgroundColor: kCardBackgroundColor,
          canvasColor: kCardBackgroundColor,
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.deepPurple,
            contentTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          AppScreen.id: (context) => AppScreen(),
          AddPasswordScreen.id: (context) => AddPasswordScreen(),
        },
        home: LoginScreen(),
      ),
    );
  }
}
