import 'package:flutter/material.dart';
import 'package:password_manager/constants.dart';

class PasswordCard extends StatefulWidget {
  final Map<String, dynamic> fields;

  PasswordCard({@required this.fields});

  @override
  _PasswordCardState createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  List<Widget> getCardBody(Map fields) {
    List<Widget> cardColumns = [];

    cardColumns.addAll([
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              widget.fields["Title"] == null
                  ? ""
                  : widget.fields["Title"].toUpperCase(), // null operator
              style: kCardTitleTextStyle),
        ],
      ),
      SizedBox(height: 10.0),
    ]);

    for (String key in fields.keys) {
      if (!(key == "Title" || key == "id"))
        cardColumns.add(
          ListTile(
            title: Text(key,
                style: TextStyle(
                    color: Colors.yellow, fontWeight: FontWeight.bold)),
            subtitle: Text(
              key == "Password" ? '***********' : fields[key],
              style: kCardContentTextStyle,
            ),
            trailing: IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () {
//                  Clipboard.setData(ClipboardData(text: widget.fields[key]));

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("$key Copied to Clipboard"),
                    duration: Duration(seconds: 1),
                  ));
                }),
          ),
        );
    }

    return cardColumns;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: getCardBody(widget.fields),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
