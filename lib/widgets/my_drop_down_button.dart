import 'package:flutter/material.dart';

class MyDropDownButton extends StatelessWidget {
  final Function dropDownOnChanged;
  final List<String> dropDownFields;

  MyDropDownButton({
    @required this.dropDownOnChanged,
    @required this.dropDownFields,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 2, 10, 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.0),
            border: Border.all(
              color: Colors.lightBlueAccent,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            hint: Text("Select a field to add"),
            icon: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(Icons.keyboard_arrow_down),
            ),
            iconSize: 30.0,
            iconEnabledColor: Colors.lightBlueAccent,
            elevation: 16,
            onChanged: this.dropDownOnChanged,
            items: this
                .dropDownFields
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
