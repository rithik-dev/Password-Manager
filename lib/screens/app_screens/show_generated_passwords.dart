import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';

class ShowGeneratedPasswordsScreen extends StatelessWidget {
  final List<String> passwords;

  ShowGeneratedPasswordsScreen(this.passwords);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Builder(
              builder: (context) {
                return Card(
                  elevation: 10,
                  color: kCardBackgroundColor,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: (this.passwords[index].length > 50) ? 10 : 5,
                      horizontal: (this.passwords[index].length > 50) ? 20 : 10,
                    ),
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
