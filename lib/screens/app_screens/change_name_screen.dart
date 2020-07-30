import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class ChangeNameScreen extends StatelessWidget {
  static const id = 'change_name_screen';
  String name = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ProviderClass>(context).showLoadingScreen,
      child: Consumer<ProviderClass>(
        builder: (context,data,child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Change Name"),
              centerTitle: true,
              leading: Container(),
            ),
            body: Container(
              color: Color(0xFF000014),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0)),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      MyTextField(
                        labelText: "Name",
                        defaultValue: data.name,
                        autoFocus: true,
                        onChanged: (String value) {
                          name = value;
                        },
                        showTrailingWidget: false,
                      ),
                      SizedBox(height: 10.0),
                      Builder(
                        builder: (context) {
                          return RoundedButton(
                            text: "Change Name",
                            onPressed: () async {

                              data.startLoadingScreen();

                              name = Functions.capitalizeFirstLetter(name);

                              final bool changeSuccessful = await data.changeCurrentUserName(name);

                              if (changeSuccessful) Navigator.pop(context);

                              data.stopLoadingScreen();
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
