import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/widgets/my_slider.dart';

class MySliderCard extends StatelessWidget {

  final String title;
  final int value;
  final Function onChanged;

  MySliderCard({this.title,this.value,this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 17.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                Text(
                  "${this.value}  ",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            MySlider(
              value: this.value,
              onChanged: this.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
