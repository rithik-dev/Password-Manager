import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/models/route_generator.dart';
import 'package:password_manager/screens/initial_screen_handler.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData appTheme = ThemeData(
    fontFamily: 'ProductSans',
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(color: kSecondaryColor),
    scaffoldBackgroundColor: kScaffoldBackgroundColor,
    dialogBackgroundColor: kCardBackgroundColor,
    canvasColor: kCardBackgroundColor,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.deepPurple,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ChangeNotifierProvider<ProviderClass>(
      create: (context) => ProviderClass(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: this.appTheme,
        darkTheme: this.appTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: InitialScreenHandler.id,
      ),
    );
  }
}
