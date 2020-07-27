import 'package:flutter/material.dart';
import 'package:password_manager/firebase_utils.dart';
import 'package:password_manager/screens/add_password_screen.dart';

void main() => runApp(MyVault());

class MyVault extends StatefulWidget {
  @override
  _MyVaultState createState() => _MyVaultState();
}

class _MyVaultState extends State<MyVault> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Text("VAULT")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print("ADD NEW PASSWORD CARD");
            showModalBottomSheet(
                context: context, builder: (context) => AddPasswordScreen());
          },
        ),
      ),
    );
  }
}
