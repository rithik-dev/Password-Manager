import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class MyTextField extends StatelessWidget {
  final Map<String, TextInputType> keyboardTypes = {
    'Email': TextInputType.emailAddress,
    'Phone': TextInputType.phone,
    'Link': TextInputType.url,
  };

  final String labelText;
  final Widget trailing;
  final Function onChanged;
  final String defaultValue;

  final TextEditingController _controller = TextEditingController();

  MyTextField(
      {@required this.labelText,
      this.trailing,
      @required this.onChanged,
      this.defaultValue = ""});

  @override
  Widget build(BuildContext context) {
    bool useDefaultValue = (this.defaultValue != "");
    if (useDefaultValue) _controller.text = this.defaultValue;

    return ListTile(
      title: TextField(
        controller: useDefaultValue ? _controller : null,
        textAlign: TextAlign.center,
        autofocus: this.labelText == "Title",
        keyboardType: keyboardTypes[this.labelText] ?? TextInputType.text,
        onChanged: this.onChanged,
        obscureText: this.labelText == "Password",
        decoration: kTextFieldDecoration.copyWith(
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
