import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/screens/app_screens/password_generator.dart';
import 'package:password_manager/screens/app_screens/settings.dart';
import 'package:password_manager/screens/app_screens/vault.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppScreen());

class AppScreen extends StatefulWidget {
  static const id = 'app_screen';

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndexBottomNavBar = 0;

  final List<Widget> tabs = [MyVault(), PasswordGenerator(), Settings()];
  final List<String> titles = ["Vault", "Password Generator", "Settings"];

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Theme.of(context).accentColor,
      ),
      inAsyncCall:
          Provider.of<ProviderClass>(context).showLoadingScreenOnMainAppScreen,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: (_selectedIndexBottomNavBar == 0)
                  ? (Provider.of<ProviderClass>(context).name == null)
                      ? Text("Vault")
                      : Text(
                          "${Provider.of<ProviderClass>(context).name}'s Vault")
                  : Text(titles[_selectedIndexBottomNavBar]),
              centerTitle: true,
              automaticallyImplyLeading: false,
              // if user is on vault page , show + icon on app bar to add a new password
              actions: <Widget>[
                _selectedIndexBottomNavBar == 0
                    ? IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.pushNamed(context, AddPasswordScreen.id);
                        },
                      )
                    : SizedBox.shrink(),
                _selectedIndexBottomNavBar == 2
                    ? IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () async {
                          await FirebaseUtils.logoutUser();
                          Provider.of<ProviderClass>(context, listen: false)
                              .setDataToNull();
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                          Fluttertoast.showToast(
                            msg: "Logged Out Successfully",
                            gravity: ToastGravity.TOP,
                          );
                        },
                      )
                    : SizedBox.shrink(),
              ]),
          body: RefreshIndicator(
            displacement: 20.0,
            onRefresh: () =>
                Provider.of<ProviderClass>(context, listen: false).getAppData(),
            child: tabs[_selectedIndexBottomNavBar],
          ),
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
            selectedItemColor: Colors.lightBlueAccent,
            onTap: (int index) {
              setState(() {
                _selectedIndexBottomNavBar = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
