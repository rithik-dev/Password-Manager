import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/models/exceptions.dart';
import 'package:password_manager/models/firebase_utils.dart';
import 'package:password_manager/models/functions.dart';

class ProviderClass extends ChangeNotifier {
  String _name, _key, _profilePicURL;
  bool _showLoadingScreen = false; // used for inAsyncCall
  bool _showLoadingScreenOnMainAppScreen = false; // used for inAsyncCall
  List<Map<String, dynamic>> _passwords;
  List<Map<String, dynamic>> filteredPasswords;
  Map<String, dynamic> _showPasswordFields;
  bool _userLoggedIn; // bool holding true if user is already logged in
  FirebaseUser _loggedInUser; // currently logged in user object
  TextEditingController _searchController;
  String _searchText;

  void setSearchController() {
    this._searchController = TextEditingController();
    notifyListeners();
  }

  void disposeSearchController() {
    this._searchController.dispose();
  }

  void setSearchText(String text) {
    this._searchText = text;
    notifyListeners();
  }

  void setSearchTextToLastSearch() {
    _searchController.text = _searchText;
    this.filteredPasswords = this
        ._passwords
        .where((element) => element['Title']
            .toLowerCase()
            .contains(this._searchText.toLowerCase()))
        .toList();

    if (this.filteredPasswords.length == 0) {
      this._searchController.text = "";
      this._searchText = "";
      this.filteredPasswords = this._passwords;
    }
    notifyListeners();
  }

  TextEditingController get searchController => this._searchController;

  bool get showLoadingScreen => this._showLoadingScreen;

  bool get showLoadingScreenOnMainAppScreen =>
      this._showLoadingScreenOnMainAppScreen;

  String get name => this._name;

  String get profilePicURL => this._profilePicURL;

  Map<String, dynamic> get showPasswordFields => this._showPasswordFields;

  List<Map<String, dynamic>> get passwords => this._passwords;

  bool get userLoggedIn => this._userLoggedIn;

  FirebaseUser get loggedInUser => this._loggedInUser;

  void setFilteredPasswords(List<Map> passwords) {
    this.filteredPasswords = passwords;
    notifyListeners();
  }

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

  void setShowPasswordFields(Map<String, dynamic> fields) {
    this._showPasswordFields = fields;
    notifyListeners();
  }

  Future<bool> changeCurrentUserName(String name) async {
    if (name == null) return true;
    final bool changeNameSuccessful =
        await FirebaseUtils.changeCurrentUserName(name, _loggedInUser);
    if (changeNameSuccessful) {
      this._name = name;
      notifyListeners();
      return true;
    } else
      return false;
  }

  Future<bool> addPasswordFieldToDatabase(Map<String, dynamic> fields) async {
    fields = Functions.removeEmptyValuesFromMap(fields);

    String docID = await FirebaseUtils.addPasswordFieldToDatabase(
        fields, _loggedInUser, _key);

    fields['documentId'] = docID;

    this._passwords.add(fields);
    this._passwords.sort((a, b) {
      return a['Title'].compareTo(b['Title']);
    });

    this.filteredPasswords = this._passwords;

    notifyListeners();
    if (docID != null)
      return true;
    else
      return false;
  }

  Future<bool> editPasswordFieldInDatabase(
      Map<String, dynamic> newFields) async {
    newFields = Functions.removeEmptyValuesFromMap(newFields);

    bool editPasswordSuccessful =
    await FirebaseUtils.editPasswordFieldInDatabase(
        newFields, _loggedInUser, _key);

    for (int index = 0; index < this._passwords.length; index++) {
      if (this._passwords[index]['documentId'] == newFields['documentId']) {
        this._passwords[index] = newFields;
      }
    }

    this.filteredPasswords = this._passwords;

    notifyListeners();
    return editPasswordSuccessful;
  }

  Future<bool> deletePasswordFieldFromDatabase(String documentId) async {
    bool deletePasswordSuccessful =
    await FirebaseUtils.deletePasswordFieldFromDatabase(
        documentId, _loggedInUser);

    Map<String, dynamic> passwordToDelete = this
        ._passwords
        .where((element) => element['documentId'] == documentId)
        .first;
    this._passwords.remove(passwordToDelete);

    this.filteredPasswords = this._passwords;

    notifyListeners();
    return deletePasswordSuccessful;
  }

  Future<bool> sendPasswordResetEmailForLoggedInUser() async {
    try {
      return await FirebaseUtils.sendPasswordResetEmail(
          this._loggedInUser.email);
    } catch (e) {
      print("ERROR WHILE SENDING PASSWORD RESET EMAIL : $e");
      throw ForgotPasswordException(e.message);
    }
  }

  Future<void> updateProfilePicture({File newImage}) async {
    String newProfilePictureURL = await FirebaseUtils.updateProfilePicture(
      userId: this._loggedInUser.uid,
      oldImageURL: this._profilePicURL,
      newImage: newImage,
    );
    this._profilePicURL = newProfilePictureURL;
    notifyListeners();
  }

  Future<void> removeProfilePicture() async {
    await FirebaseUtils.removeProfilePicture(
      userId: this._loggedInUser.uid,
      oldImageURL: this._profilePicURL,
    );
    this._profilePicURL = kDefaultProfilePictureURL;
    notifyListeners();
  }

  void setDataToNull() {
    this._name = null;
    this._passwords = null;
    this.filteredPasswords = null;
    this._showPasswordFields = null;
    this._userLoggedIn = null;
    this._loggedInUser = null;
    this._key = null;
    this._profilePicURL = null;
    notifyListeners();
  }

  Future<void> getAppData() async {
    this.setSearchController();
    final Map<String, dynamic> appData =
    await FirebaseUtils.getAppData(_loggedInUser);
    this._name = appData['name'];
    this._passwords = appData['passwords'];
    this.filteredPasswords = appData['passwords'];
    this._key = appData['key'];
    this._profilePicURL = appData['profilePicURL'];
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
