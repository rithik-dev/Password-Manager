import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';

class ShowGeneratedPasswordsScreen extends StatelessWidget {
  final List<String> passwords;

  ShowGeneratedPasswordsScreen(this.passwords);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        color: kSecondaryColor,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Builder(
              builder: (context) {
                return Card(
                  color: kCardBackgroundColor,
                  child: ListTile(
                    title: Text(this.passwords[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.content_copy),
                      onPressed: () {
                        Functions.copyToClipboard(this.passwords[index]);
                        Functions.showSnackBar(context, "Password Copied !");
                      },
                    ),
                  ),
                );
              },
            );
          },
          itemCount: passwords.length,
        ),
      ),
    );
  }
}
