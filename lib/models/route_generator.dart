import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
        return PageTransition(
            type: PageTransitionType.fade, child: InitialScreenHandler());
      case LoginScreen.id:
        return PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: LoginScreen(
              defaultEmail: args is Map ? args['defaultEmail'] : "",
              defaultPassword: args is Map ? args['defaultPassword'] : "",
            ));
      case RegisterScreen.id:
        return PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: RegisterScreen());
      case AppScreen.id:
        return PageTransition(
            type: PageTransitionType.scale, child: AppScreen());
      case AddPasswordScreen.id:
        return PageTransition(
            type: PageTransitionType.scale, child: AddPasswordScreen());
      case EditPasswordScreen.id:
        return PageTransition(
            type: PageTransitionType.scale,
            child: EditPasswordScreen());
      case ChangeNameScreen.id:
        return PageTransition(
            type: PageTransitionType.downToUp, child: ChangeNameScreen());
      case ChangeEmailScreen.id:
        return PageTransition(
            type: PageTransitionType.downToUp, child: ChangeEmailScreen());
      case ChangePasswordScreen.id:
        return PageTransition(
            type: PageTransitionType.downToUp, child: ChangePasswordScreen());
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
