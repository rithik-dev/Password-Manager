import 'package:flutter/foundation.dart';
import 'package:password_manager/models/firebase_utils.dart';

class ProviderClass extends ChangeNotifier {
  String _name;
  bool _showLoadingScreen = false; // used for inAsyncCall
  List<Map<String, dynamic>> _passwords;

  bool get showLoadingScreen => this._showLoadingScreen;

  String get name {
    return this._name;
  }

  List<Map<String, dynamic>> get passwords {
    return this._passwords;
  }

  Future<bool> addPassword(Map<String, dynamic> fields) async {
    bool addPasswordSuccessful = await FirebaseUtils.addPassword(fields);
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
    return addPasswordSuccessful;
  }

  Future<bool> editPassword(Map<String, dynamic> newFields) async {
    bool editPasswordSuccessful = await FirebaseUtils.editPassword(newFields);
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
    return editPasswordSuccessful;
  }

  Future<bool> deletePassword(String documentId) async {
    bool deletePasswordSuccessful = await FirebaseUtils.deletePassword(documentId);
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
    return deletePasswordSuccessful;
  }

  void setDataToNull() {
    this._name = null;
    this._passwords = null;
    notifyListeners();
  }

  void getAppData() async {
    this._name = await FirebaseUtils.getCurrentUserName();
    this._passwords = await FirebaseUtils.getPasswords();
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
