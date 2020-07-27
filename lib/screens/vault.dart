import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/widgets/password_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyVault());

class MyVault extends StatefulWidget {
  @override
  _MyVaultState createState() => _MyVaultState();
}

//TODO: add bottom modal sheet when user taps on a card to view details and copy     showModalBottomSheet();

class _MyVaultState extends State<MyVault> {
  List<Map<String, dynamic>> passwords = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: ListView(
          children: [],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, AddPasswordScreen.id);
          },
        ),
      ),
    );
  }
}
