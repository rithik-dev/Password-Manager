import 'package:flutter/material.dart';
import 'package:password_manager/models/functions.dart';
import 'package:password_manager/models/network_helper.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/screens/app_screens/show_generated_passwords.dart';
import 'package:password_manager/widgets/my_switch_card.dart';
import 'package:password_manager/widgets/my_slider_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(PasswordGenerator());

class PasswordGenerator extends StatefulWidget {
  @override
  _PasswordGeneratorState createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  String url;
  bool upper = true, lower = true, numbers = true, special = true;
  int length = 15, repeat = 10;

  String getStringFromBoolean(bool boolean) => boolean ? "on" : "off";

  @override
  Widget build(BuildContext context) {
    url = "";
    return Consumer<ProviderClass>(
      builder: (context, data, child) {
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 20.0),
              child: ListView(
                children: <Widget>[
                  MySwitchCard(
                    title: "Uppercase Letters",
                    currentValue: upper,
                    onChanged: (bool newValue) {
                      setState(() {
                        upper = newValue;
                      });
                    },
                  ),
                  MySwitchCard(
                    title: "Lowercase Letters",
                    currentValue: lower,
                    onChanged: (bool newValue) {
                      setState(() {
                        lower = newValue;
                      });
                    },
                  ),
                  MySwitchCard(
                    title: "Numbers",
                    currentValue: numbers,
                    onChanged: (bool newValue) {
                      setState(() {
                        numbers = newValue;
                      });
                    },
                  ),
                  MySwitchCard(
                    title: "Special Characters",
                    currentValue: special,
                    subtitle: "( < > ` ! ? @ # \$ % ^ & * ( ) . , _ - )",
                    onChanged: (bool newValue) {
                      setState(() {
                        special = newValue;
                      });
                    },
                  ),
                  MySliderCard(
                    title: "Password Length",
                    value: length,
                    onChanged: (double newValue) {
                      setState(() {
                        length = newValue.round();
                      });
                    },
                  ),
                  MySliderCard(
                    title: "Number of Passwords",
                    value: repeat,
                    onChanged: (double newValue) {
                      setState(() {
                        repeat = newValue.round();
                      });
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () async {
                // if all values are false
                if (!upper && !lower && !numbers && !special) {
                  Functions.showSnackBar(
                      context, "No Content is chosen for the Password !",
                      duration: Duration(seconds: 2));
                }
                else {
                  url = "https://passwordwolf.com/api/?";
                  url += "upper=${getStringFromBoolean(upper)}&";
                  url += "lower=${getStringFromBoolean(lower)}&";
                  url += "numbers=${getStringFromBoolean(numbers)}&";
                  url += "special=${getStringFromBoolean(special)}&";
                  url += "length=$length&";
                  url += "repeat=$repeat";

                  data.startLoadingScreenOnMainAppScreen();

                  List<String> passwordsFromAPI = await NetworkHelper.getData(url);
                  showModalBottomSheet(context: context,
                      builder: (context) => ShowGeneratedPasswordsScreen(passwordsFromAPI));

                  data.stopLoadingScreenOnMainAppScreen();
                }
              },
            ),
          ),
        );
      },
    );
  }
}