import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final Function onChanged;
  final Function trailingFunction;
  final String defaultValue;
  final bool showTrailingWidget;

  MyTextField(
      {@required this.labelText,
      @required this.onChanged,
      this.trailingFunction,
      this.showTrailingWidget = true,
      this.defaultValue = ""});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final TextEditingController _controller = TextEditingController();

  final Map<String, TextInputType> keyboardTypes = {
    'Email': TextInputType.emailAddress,
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
      icon: Icon(Icons.delete, size: 30.0),
      onPressed: this.widget.trailingFunction,
    );

    if (labelText == "Title")
      return null;
    else if (labelText == "Custom Field Name")
      return addButton;
    else if (labelText == "Password") {
      return IconButton(
        color: Colors.lightBlueAccent,
        icon: _showPassword
            ? Icon(Icons.visibility, size: 30.0)
            : Icon(Icons.visibility_off, size: 30.0),
        onPressed: () {
          toggleShowPassword();
        },
      );
    } else
      return deleteButton;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool useDefaultValue = (this.widget.defaultValue != "");
    if (useDefaultValue) _controller.text = this.widget.defaultValue;

    return ListTile(
      title: TextField(
        controller: useDefaultValue ? _controller : null,
        textAlign: TextAlign.center,
        autofocus: this.widget.labelText == "Title",
        keyboardType: keyboardTypes[this.widget.labelText] ?? TextInputType.text,
        onChanged: this.widget.onChanged,
        obscureText: this.widget.labelText == "Password" ? !_showPassword : false,
        decoration: kTextFieldDecoration.copyWith(
            border: InputBorder.none,
            hintText: "Enter ${this.widget.labelText}",
            labelText: this.widget.labelText),
      ),
      trailing: this.widget.showTrailingWidget?getTrailingWidget(this.widget.labelText):null,
    );
  }
}