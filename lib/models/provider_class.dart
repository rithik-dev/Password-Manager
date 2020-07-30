import 'package:flutter/foundation.dart';
import 'package:password_manager/models/firebase_utils.dart';

class ProviderClass extends ChangeNotifier {
  String _name;
  bool _showLoadingScreen = false; // used for inAsyncCall
  List<Map<String, dynamic>> _passwords;
  Map<String,dynamic> _showPasswordFields;

  bool get showLoadingScreen => this._showLoadingScreen;
  String get name => this._name;
  Map<String,dynamic> get showPasswordFields => this._showPasswordFields;
  List<Map<String, dynamic>> get passwords => this._passwords;

  void setShowPasswordFields(Map<String,dynamic> fields) {
    this._showPasswordFields = fields;
    notifyListeners();
  }

  Future<bool> changeCurrentUserName(String name) async{
    final bool changeNameSuccessful = await FirebaseUtils.changeCurrentUserName(name);
    if(changeNameSuccessful) {
      this._name = name;
      notifyListeners();
      return true;
    }
    else return false;
  }

  Future<bool> addPasswordFieldToDatabase(Map<String, dynamic> fields) async {
    bool addPasswordSuccessful = await FirebaseUtils.addPasswordFieldToDatabase(fields);
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
    return addPasswordSuccessful;
  }

  Future<bool> editPasswordFieldInDatabase(Map<String, dynamic> newFields) async {
    bool editPasswordSuccessful = await FirebaseUtils.editPasswordFieldInDatabase(newFields);
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
    return editPasswordSuccessful;
  }

  Future<bool> deletePasswordFieldFromDatabase(String documentId) async {
    bool deletePasswordSuccessful = await FirebaseUtils.deletePasswordFieldFromDatabase(documentId);
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
    return deletePasswordSuccessful;
  }

  void setDataToNull() {
    this._name = null;
    this._passwords = null;
    this._showPasswordFields = null;
    notifyListeners();
  }

  void getAppData() async {
    final Map<String,dynamic> appData = await FirebaseUtils.getAppData();
    this._name = appData['name'];
    this._passwords = appData['passwords'];
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
