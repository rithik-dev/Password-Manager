import 'package:flutter/material.dart';
import 'package:password_manager/models/provider_class.dart';
import 'package:password_manager/widgets/password_card.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyVault());

class MyVault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Consumer<ProviderClass>(
            builder: (context, data, child) {
              return (data.passwords == null)
                  ? CircularProgressIndicator()
                  : (data.passwords.length == 0)
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "No passwords added yet. Start by adding a new password by clicking the + icon on the top right.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return PasswordCard(data.passwords[index]);
                            },
                            itemCount: data.passwords.length,
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
}
