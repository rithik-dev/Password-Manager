import 'package:flutter/material.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/screens/app_screens/app_screen.dart';
import 'package:password_manager/screens/app_screens/change_email_screen.dart';
import 'package:password_manager/screens/app_screens/change_name_screen.dart';
import 'package:password_manager/screens/app_screens/change_password_screen.dart';
import 'package:password_manager/screens/edit_password_screen.dart';
import 'package:password_manager/screens/initial_screen_handler.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/register_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
// Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case InitialScreenHandler.id:
        return MaterialPageRoute(builder: (context) => InitialScreenHandler());
      case LoginScreen.id:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(
            defaultEmail: args is Map ? args['defaultEmail'] : "",
            defaultPassword: args is Map ? args['defaultPassword'] : "",
          ),
        );
      case RegisterScreen.id:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case AppScreen.id:
        return MaterialPageRoute(builder: (context) => AppScreen());
      case AddPasswordScreen.id:
        return MaterialPageRoute(builder: (context) => AddPasswordScreen());
      case EditPasswordScreen.id:
        return MaterialPageRoute(builder: (context) => EditPasswordScreen());
      case ChangeNameScreen.id:
        return MaterialPageRoute(builder: (context) => ChangeNameScreen());
      case ChangeEmailScreen.id:
        return MaterialPageRoute(builder: (context) => ChangeEmailScreen());
      case ChangePasswordScreen.id:
        return MaterialPageRoute(builder: (context) => ChangePasswordScreen());
// Validation of correct data type
//        if (args is String) {
//          return MaterialPageRoute(
//            builder: (_) => SecondPage(
//              data: args,
//            ),
//          );
//        }
// If args is not of the correct type, return an error page.
//        return _errorRoute();
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String route) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR\n ROUTE NOT FOUND : $route'),
        ),
      );
    });
  }
}
