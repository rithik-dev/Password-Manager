import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/models/route_generator.dart';
import 'package:password_manager/screens/initial_screen_handler.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderClass>(
      create: (context) => ProviderClass(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
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
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: InitialScreenHandler.id,
      ),
    );
  }
}
