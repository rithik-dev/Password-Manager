import 'package:flutter/material.dart';

void main() => runApp(PasswordGenerator());

class PasswordGenerator extends StatefulWidget {
  @override
  _PasswordGeneratorState createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: Text("PASSWORD GENERATOR")),
      ),
    );
  }
}
