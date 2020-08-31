import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/show_password_details.dart';
import 'package:provider/provider.dart';

class PasswordCard extends StatelessWidget {
  final Map<String, dynamic> fields;

  PasswordCard(this.fields);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Card(
        color: kCardBackgroundColor,
        child: ListTile(
          title: Text(fields['Title']),
          // if email is null , then show username as subtitle , or blank if both null
          subtitle: Text(fields['Email'] ?? fields['Username'] ?? ""),
          onTap: () {
            Provider.of<ProviderClass>(context, listen: false)
                .setShowPasswordFields(fields);
            showModalBottomSheet(
                context: context, builder: (context) => ShowPasswordDetails());
          },
          trailing: IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              Functions.copyToClipboard(fields['Password']);
              Functions.showSnackBar(
                  context, "Password Copied : ${fields['Title']}");
            },
          ),
        ),
      ),
    );
  }
}
