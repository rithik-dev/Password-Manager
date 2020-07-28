import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Map<String, TextInputType> keyboardTypes = {
    'Email': TextInputType.emailAddress,
    'Phone': TextInputType.phone,
    'Link': TextInputType.url,
  };

  final String labelText;
  final Widget trailing;
  final Function onChanged;

  MyTextField(
      {@required this.labelText, this.trailing, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        autofocus: this.labelText == "Title",
        keyboardType: keyboardTypes.containsKey(this.labelText)
            ? keyboardTypes[this.labelText]
            : TextInputType.text,
        onChanged: this.onChanged,
        obscureText: this.labelText == "Password",
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter ${this.labelText}",
            labelText: this.labelText),
      ),
      // not showing trailing if fields are title or password as those are mandatory fields.
      trailing: this.labelText == "Title" || this.labelText == "Password"
          ? null
          : this.trailing,
    );
  }
}
