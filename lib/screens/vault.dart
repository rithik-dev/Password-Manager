import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/widgets/password_card.dart';

void main() => runApp(MyVault());

class MyVault extends StatefulWidget {
  @override
  _MyVaultState createState() => _MyVaultState();
}

//TODO: add bottom modal sheet when user taps on a card to view details and copy     showModalBottomSheet();

class _MyVaultState extends State<MyVault> {
  List<Map<String, dynamic>> passwords = [];
  List<Widget> cards = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPasswordCards();
  }

  void getPasswordCards() async {
    passwords = await FirebaseUtils.getPasswords();

    for (Map<String, dynamic> passwordFields in passwords) {
      cards.add(PasswordCard(fields: passwordFields));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: ListView(  // TODO: use list view builder?
          children: cards,
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
