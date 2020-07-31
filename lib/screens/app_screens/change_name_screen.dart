import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class ChangeNameScreen extends StatelessWidget {
  static const id = 'change_name_screen';
  String name;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ProviderClass>(context).showLoadingScreen,
      child: Consumer<ProviderClass>(
        builder: (context,data,child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Change Name"),
              centerTitle: true
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  MyTextField(
                    labelText: "Name",
                    showTrailingWidget: false,
                    defaultValue: data.name,
                    autofocus: true,
                    onChanged: (String value) {
                      name = value;
                    },
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
          );
        },
      ),
    );
  }
}
