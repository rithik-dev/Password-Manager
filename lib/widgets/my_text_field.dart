import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final Function onChanged;
  final Function trailingFunction;
  final String defaultValue;
  final bool showTrailingWidget;
  final bool autofocus;
  final TextEditingController controller;
  final Function validator;

  MyTextField(
      {@required this.labelText,
      @required this.onChanged,
      this.trailingFunction,
      this.showTrailingWidget = true,
      this.defaultValue,
      this.autofocus = false,
      this.controller,
      this.validator});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final Map<String, TextInputType> keyboardTypes = {
    'Email': TextInputType.emailAddress,
    'Password': TextInputType.visiblePassword,
    'Phone': TextInputType.phone,
    'Link': TextInputType.url,
  };

  bool _showPassword = false;

  void toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget getTrailingWidget(String labelText) {
    IconButton addButton = IconButton(
      color: Colors.lightBlueAccent,
      icon: Icon(Icons.add, size: 30.0),
      onPressed: this.widget.trailingFunction,
    );

    IconButton deleteButton = IconButton(
      color: Colors.lightBlueAccent,
      icon: Icon(Icons.delete, size: 25.0),
      onPressed: this.widget.trailingFunction,
    );

    if (labelText == "Title")
      return null;
    else if (labelText == "Custom Field Name")
      return addButton;
    else if (labelText.contains("Password")) {
      return IconButton(
        color: Colors.lightBlueAccent,
        icon: _showPassword
            ? Icon(Icons.visibility, size: 25.0)
            : Icon(Icons.visibility_off, size: 25.0),
        onPressed: () {
          toggleShowPassword();
        },
      );
    } else
      return deleteButton;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: this.widget.controller,
        validator: this.widget.validator,
        initialValue: this.widget.defaultValue,
        textAlign: TextAlign.center,
        autofocus: this.widget.autofocus,
        keyboardType:
            keyboardTypes[this.widget.labelText] ?? TextInputType.text,
        onChanged: this.widget.onChanged,
        obscureText:
            this.widget.labelText.contains("Password") ? !_showPassword : false,
        decoration: kTextFieldDecoration.copyWith(
          hintText: "Enter ${this.widget.labelText}",
          labelText: this.widget.labelText,
          suffixIcon: this.widget.showTrailingWidget
              ? Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: getTrailingWidget(this.widget.labelText),
                )
              : null,
        ),
      ),
    );
  }
}
