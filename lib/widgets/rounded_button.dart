import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class RoundedButton extends StatelessWidget {
//  final Color color;
  final String text;
  final Function onPressed;

  RoundedButton({/*this.color,*/ this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: kButtonColor,//this.color
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed: this.onPressed,
          minWidth: 150.0,
          height: 42.0,
          child: Text(
            this.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
