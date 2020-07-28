import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/screens/show_password_details.dart';

class PasswordCard extends StatelessWidget {
  final Map<String, dynamic> fields;

  PasswordCard(this.fields);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardBackgroundColor,
      child: ListTile(
        title: Text(fields['Title']),
        // if email is null , then show username as subtitle , or blank if both null
        subtitle: Text(fields['Email'] ?? fields['Username'] ?? ""),
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => ShowPasswordDetails(fields));
        },
        trailing: IconButton(
          icon: Icon(Icons.content_copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: fields['Password']));

            final snackBar = SnackBar(
                content: Text("Password Copied : ${fields['Title']}"),
                duration: Duration(seconds: 1));
            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}
