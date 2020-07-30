import 'package:flutter/material.dart';

class MySlider extends StatelessWidget {
  final int value, minValue, maxValue;
  final Function onChanged;

  MySlider({this.value, this.onChanged, this.minValue = 1, this.maxValue = 128});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        inactiveTrackColor: Color(0xFF8D8E98),
        activeTrackColor: Colors.white,
        thumbColor: Color(0xFFEB1555),
        overlayColor: Color(0x29EB1555),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
      ),
      child: Slider(
        value: this.value.toDouble(),
        onChanged: this.onChanged,
        min: this.minValue.toDouble(),
        max: this.maxValue.toDouble(),
      ),
    );
  }
}
