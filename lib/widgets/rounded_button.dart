import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  RoundedButton({this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AnimatedButton(
          color: kCardBackgroundColor,
          shadowDegree: ShadowDegree.dark,
          duration: 50,
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
