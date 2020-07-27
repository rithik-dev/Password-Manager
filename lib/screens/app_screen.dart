import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/screens/password_generator.dart';
import 'package:password_manager/screens/vault.dart';
import 'package:password_manager/screens/settings.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();

    getName();
  }

  void getName() async {
    name = await FirebaseUtils.getCurrentUserName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Password Manager"),
          centerTitle: true,
          backgroundColor: kSecondaryColor,
          leading: Container(),
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
