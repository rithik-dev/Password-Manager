import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class FirebaseUtils {
  //preventing the class from being instantiated
  FirebaseUtils._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  static final PlatformStringCryptor _cryptor = new PlatformStringCryptor();
  static const int LEVELS_OF_ENCRYPTION = 5;

  static Future<FirebaseUser> getCurrentUser() async {
    try {
      final FirebaseUser currentUser = await _auth.currentUser();
      return currentUser;
    } catch (e) {
      print("ERROR WHILE GETTING CURRENT USER : $e");
      return null;
    }
  }

  static Future<String> getCurrentUserName() async {
    try {
      final FirebaseUser currentUser = await getCurrentUser();
      final DocumentSnapshot documentSnapshot = await _firestore.collection("data").document(currentUser.uid).get();
      final String fullName = documentSnapshot.data['fullName'];
      return fullName;
    } catch (e) {
      print("ERROR WHILE GETTING CURRENT USER NAME : $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getPasswords() async {
    List<Map<String, dynamic>> passwords = [];

    try {
      final FirebaseUser currentUser = await getCurrentUser();
      final documentSnapshot = await _firestore
          .collection("data")
          .document(currentUser.uid)
          .collection("passwords")
          .orderBy('Title')
          .getDocuments();

      for (var document in documentSnapshot.documents) {
        Map<String, dynamic> data = document.data;
        // decrypting password
        data['Password'] = await _decryptPassword(data['Password']);
        passwords.add(data);
      }
      return passwords;
    } catch (e) {
      print("ERROR WHILE FETCHING PASSWORDS FROM FIREBASE : $e");
      return [];
    }
  }

  static Future<bool> registerUser(String email, String password, {String fullName}) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (user != null) {
        // creating document for new user
        final FirebaseUser currentUser = await getCurrentUser();
        //creating a unique key for encrypting passwords for each user
        final String _key = await _cryptor.generateRandomKey();

        _firestore.collection("data").document(currentUser.uid).setData({
          "fullName": fullName,
          "key": _key,
        });
        return true;
      } else
        return false;
    } catch (e) {
      print("EXCEPTION WHILE REGISTERING NEW USER : $e");
      return false;
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (user != null)
        return true;
      else
        return false;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING IN USER : $e");
      return false;
    }
  }

  static Future<bool> logoutUser() async {
    try {
      final FirebaseUser user = await getCurrentUser();
      if (user != null) {
        _auth.signOut();
        return true;
      }
      else return false;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING OUT USER : $e");
      return false;
    }
  }

  static Future<bool> addPassword(Map<String, dynamic> fields) async {
    // check if empty map is not received
    if (fields.isNotEmpty)
      try {
        final FirebaseUser currentUser = await _auth.currentUser();
        final String userId = currentUser.uid;

        //adding documentId to fields
        fields.addAll({
          "documentId": _firestore
              .collection("data")
              .document(userId)
              .collection("passwords")
              .document()
              .documentID,
        });

        //encrypting passwords before sending to firebase
        fields['Password'] = await _encryptPassword(fields['Password']);

        //setting the value of the new document with fields
        _firestore
            .collection("data")
            .document(userId)
            .collection("passwords")
            .document(fields['documentId'])
            .setData(fields);

        return true;
      } catch (e) {
        print("ERROR WHILE ADDING NEW PASSWORD : $e");
        return false;
      }
    else
      //fields is empty
      return false;
  }

  static Future<bool> editPassword(Map<String, dynamic> newFields) async {
    try {
      final FirebaseUser currentUser = await _auth.currentUser();
      final String userId = currentUser.uid;

      //encrypting passwords before sending to firebase
      // not updating newFields directly as it was affecting show password details screen
      final String _encryptedPassword = await _encryptPassword(newFields['Password']);

      // adding new data
      _firestore
          .collection("data")
          .document(userId)
          .collection("passwords")
          .document(newFields['documentId'])
          .setData(newFields, merge: false);

      // adding password separately
      _firestore
          .collection("data")
          .document(userId)
          .collection("passwords")
          .document(newFields['documentId'])
          .setData({"Password": _encryptedPassword}, merge: true);

      return true;
    } catch (e) {
      print("ERROR WHILE UPDATING PASSWORD $e");
      return false;
    }
  }

  static Future<bool> deletePassword(String documentId) async {
    try {
      final FirebaseUser currentUser = await _auth.currentUser();
      final String userId = currentUser.uid;

      _firestore
          .collection("data")
          .document(userId)
          .collection("passwords")
          .document(documentId)
          .delete();

      return true;
    } catch (e) {
      print("ERROR WHILE DELETING PASSWORD $e");
      return false;
    }
  }

  static Future<String> _getKey(String userId) async {
    try {
      final DocumentSnapshot documentSnapshot = await _firestore.collection("data").document(userId).get();
      final String _key = documentSnapshot.data['key'];
      return _key;
    } catch (e) {
      print("ERROR WHILE GETTING KEY : $e");
      return null;
    }
  }

  static Future<String> _encryptPassword(String password) async {
    if (password == null) password="";
    String encrypted;

    final FirebaseUser user = await getCurrentUser();
    final String _key = await _getKey(user.uid);

    try {
      for (int i = 0; i < LEVELS_OF_ENCRYPTION; i++) {
        encrypted = await _cryptor.encrypt(password, _key);
        password = encrypted;
      }
    } catch (e) {
      print("ERROR WHILE ENCRYPTING PASSWORD : $e");
    }
    return password;
  }

  static Future<String> _decryptPassword(String password) async {
    if (password == null) password="";
    String decrypted;

    final FirebaseUser user = await getCurrentUser();
    final String _key = await _getKey(user.uid);

    try {
      for (int i = 0; i < LEVELS_OF_ENCRYPTION; i++) {
        decrypted = await _cryptor.decrypt(password, _key);
        password = decrypted;
      }
    } catch (e) {
      print("ERROR WHILE DECRYPTING PASSWORD : $e");
    }
    return password;
  }
}
