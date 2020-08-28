import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChangeNameScreen extends StatelessWidget {
  static const id = 'change_name_screen';
  String name;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Theme.of(context).accentColor,
      ),
      inAsyncCall: Provider.of<ProviderClass>(context).showLoadingScreen,
      child: Consumer<ProviderClass>(
        builder: (context, data, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Change Name"), centerTitle: true),
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

                          if(name == null || name == "")
                            Functions.showSnackBar(context, "Please Enter New Name !");
                          else {
                            Functions.popKeyboard(context);
                            final bool changeSuccessful =
                                await data.changeCurrentUserName(name);

                            if (changeSuccessful) Navigator.pop(context);
                          }
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
