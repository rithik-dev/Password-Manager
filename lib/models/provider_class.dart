import 'package:flutter/foundation.dart';
import 'package:password_manager/models/firebase_utils.dart';

class ProviderClass extends ChangeNotifier {
  String _name;
  bool _showLoadingScreen = false; // used for inAsyncCall

  bool get showLoadingScreen => this._showLoadingScreen;

  String get name {
    getName();
    return this._name;
  }

  void getName() async {
    this._name = await FirebaseUtils.getCurrentUserName();
    notifyListeners();
  }

  void startLoadingScreen() {
    _showLoadingScreen = true;
    notifyListeners();
  }

  void stopLoadingScreen() {
    _showLoadingScreen = false;
    notifyListeners();
  }
}
