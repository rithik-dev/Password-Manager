import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/widgets/password_card.dart';

class ShowPasswordDetails extends StatelessWidget {
  final Map<String, dynamic> fields;

  ShowPasswordDetails(this.fields);

  @override
  Widget build(BuildContext context) {
    List<String> keys = fields.keys.toList();
    keys.remove("documentId");

    return Scaffold(
      body: Container(
        color: Color(0xFF000014),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                color: kCardBackgroundColor,
                child: Builder(
                  builder: (context) {
                    return ListTile(
                      title: Text(keys[index]),
                      subtitle: Text(fields[keys[index]]),
                      trailing: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: fields[keys[index]]));

                          final snackBar = SnackBar(
                              content: Text("Copied ${keys[index]} !"),
                              duration: Duration(seconds: 1));
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: fields.length - 1,
          ),
        ),
      ),
    );
  }
}
