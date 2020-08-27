import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/functions.dart';

class ProviderClass extends ChangeNotifier {
  String _name,_key;
  bool _showLoadingScreen = false; // used for inAsyncCall
  bool _showLoadingScreenOnMainAppScreen = false; // used for inAsyncCall
  List<Map<String, dynamic>> _passwords;
  Map<String,dynamic> _showPasswordFields;
  bool _userLoggedIn; // bool holding true if user is already logged in
  FirebaseUser _loggedInUser;  // currently logged in user object

  bool get showLoadingScreen => this._showLoadingScreen;
  bool get showLoadingScreenOnMainAppScreen => this._showLoadingScreenOnMainAppScreen;
  String get name => this._name;
  Map<String,dynamic> get showPasswordFields => this._showPasswordFields;
  List<Map<String, dynamic>> get passwords => this._passwords;
  bool get userLoggedIn => this._userLoggedIn;
  FirebaseUser get loggedInUser => this._loggedInUser;

  Future<bool> setUserLoggedIn() async {
    try {
      final FirebaseUser user = await FirebaseUtils.getCurrentUser();
      this._loggedInUser = user;
      if (user != null)
        this._userLoggedIn = true;
      else
        this._userLoggedIn = false;
    } catch (e) {
      print(e);
      this._userLoggedIn = false;
    }
    notifyListeners();
    return this._userLoggedIn;
  }

  void setShowPasswordFields(Map<String,dynamic> fields) {
    this._showPasswordFields = fields;
    notifyListeners();
  }

  Future<bool> changeCurrentUserName(String name) async{
    if(name == null) return true;
    final bool changeNameSuccessful = await FirebaseUtils.changeCurrentUserName(name,_loggedInUser);
    if(changeNameSuccessful) {
      this._name = name;
      notifyListeners();
      return true;
    }
    else return false;
  }

  Future<bool> addPasswordFieldToDatabase(Map<String, dynamic> fields) async {

    fields = Functions.removeEmptyValuesFromMap(fields);

    String docID = await FirebaseUtils.addPasswordFieldToDatabase(fields,_loggedInUser,_key);

    fields['documentId'] = docID;

    this._passwords.add(fields);
    this._passwords.sort((a,b) {
      return a['Title'].compareTo(b['Title']);
    });

    notifyListeners();
    if(docID != null) return true;
    else return false;
  }

  Future<bool> editPasswordFieldInDatabase(Map<String, dynamic> newFields) async {

    newFields = Functions.removeEmptyValuesFromMap(newFields);

    bool editPasswordSuccessful = await FirebaseUtils.editPasswordFieldInDatabase(newFields,_loggedInUser,_key);

    for(int index = 0;index<this._passwords.length;index++) {
      if(this._passwords[index]['documentId'] == newFields['documentId']) {
        this._passwords[index] = newFields;
      }
    }

    notifyListeners();
    return editPasswordSuccessful;
  }

  Future<bool> deletePasswordFieldFromDatabase(String documentId) async {
    bool deletePasswordSuccessful = await FirebaseUtils.deletePasswordFieldFromDatabase(documentId,_loggedInUser);

    Map<String,dynamic> passwordToDelete = this._passwords.where((element) => element['documentId']==documentId).first;
    this._passwords.remove(passwordToDelete);

    notifyListeners();
    return deletePasswordSuccessful;
  }

  void setDataToNull() {
    this._name = null;
    this._passwords = null;
    this._showPasswordFields = null;
    this._userLoggedIn = null;
    this._loggedInUser = null;
    this._key = null;
    notifyListeners();
  }

  Future<void> getAppData() async {
    final Map<String,dynamic> appData = await FirebaseUtils.getAppData(_loggedInUser);
    this._name = appData['name'];
    this._passwords = appData['passwords'];
    this._key = appData['key'];
    notifyListeners();
  }

  void startLoadingScreen() {
    this._showLoadingScreen = true;
    notifyListeners();
  }

  void stopLoadingScreen() {
    this._showLoadingScreen = false;
    notifyListeners();
  }

  void startLoadingScreenOnMainAppScreen() {
    this._showLoadingScreenOnMainAppScreen = true;
    notifyListeners();
  }

  void stopLoadingScreenOnMainAppScreen() {
    this._showLoadingScreenOnMainAppScreen = false;
    notifyListeners();
  }
}
