import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/widgets/password_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyVault());

class MyVault extends StatelessWidget {
//TODO: add bottom modal sheet when user taps on a card to view details and copy /delete    showModalBottomSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Consumer<ProviderClass>(
            builder: (context, data, child) {
              return (data.passwords == null)
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return PasswordCard(data.passwords[index]);
                        },
                        itemCount: data.passwords.length,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
