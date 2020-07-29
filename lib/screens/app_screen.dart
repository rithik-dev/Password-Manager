import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/screens/password_generator.dart';
import 'package:password_manager/screens/vault.dart';
import 'package:password_manager/screens/settings.dart';

void main() => runApp(AppScreen());

class AppScreen extends StatefulWidget {
  static const id = 'app_screen';

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndexBottomNavBar = 0;

  final tabs = [MyVault(), PasswordGenerator(), Settings()];
  String name;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Password Manager"),
          centerTitle: true,
          backgroundColor: kSecondaryColor,
          leading: Container(),
          // if user is on vault page , show + icon on app bar to add a new password
          actions: (_selectedIndexBottomNavBar==0)?<Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, AddPasswordScreen.id);
              },
            )
          ]:null,
        ),
        body: tabs[_selectedIndexBottomNavBar],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30.0,
          backgroundColor: kSecondaryColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              title: Text('Vault'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              title: Text('Password Generator'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
          currentIndex: _selectedIndexBottomNavBar,
          selectedItemColor: Color(0xFF295A9E),
          onTap: (int index) {
            setState(() {
              _selectedIndexBottomNavBar = index;
            });
          },
        ),
      ),
    );
  }
}
