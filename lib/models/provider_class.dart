import 'package:flutter/foundation.dart';
import 'package:password_manager/models/firebase_utils.dart';

class ProviderClass extends ChangeNotifier {
  String _name; // _showPasswordDocumentId;
  bool _showLoadingScreen = false; // used for inAsyncCall
  List<Map<String, dynamic>> _passwords;
  Map<String, dynamic> _showPasswordFields;

  bool get showLoadingScreen => this._showLoadingScreen;

  String get name {
    return this._name;
  }

//  Map<String, dynamic> get showPasswordFields {
//    getShowPasswordFields();
//    return this._showPasswordFields;
//  }
//
//  void resetShowPasswordFields() {
//    this._showPasswordFields = null;
//  }

//  String get editPasswordDocumentId {
//    return this._editPasswordDocumentId;
//  }

//  String get showPasswordDocumentId {
//    return this._showPasswordDocumentId;
//  }

  List<Map<String, dynamic>> get passwords {
    return this._passwords;
  }

//  void getShowPasswordFields() async {
//    _showPasswordFields =
//        await FirebaseUtils.getFieldsFromDocumentId(_showPasswordDocumentId);
//    notifyListeners();
//  }

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
    bool deletePasswordSuccessful =
        await FirebaseUtils.deletePassword(documentId);
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
    return deletePasswordSuccessful;
  }

//  void setEditPasswordDocumentId(String documentId) {
//    this._editPasswordDocumentId = documentId;
//    notifyListeners();
//  }

//  void setShowPasswordDocumentId(String documentId) {
//    this._showPasswordDocumentId = documentId;
//    notifyListeners();
//  }

  void setDataToNull() {
    this._name = null;
    this._passwords = null;
//    this._editPasswordDocumentId = null;
//    this._showPasswordDocumentId = null;
    notifyListeners();
  }

  void getAppData() async {
    this._name = await FirebaseUtils.getCurrentUserName();
    this._passwords = await FirebaseUtils.getPasswords();
    notifyListeners();
  }

  void getPasswords() async {
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
