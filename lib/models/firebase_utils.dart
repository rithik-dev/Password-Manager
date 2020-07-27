import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class FirebaseUtils {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  static final PlatformStringCryptor _cryptor = new PlatformStringCryptor();
  static final String _key =
      "/i2bqsPdHXwjJLgZhW+exw==:TUto2rgeldflGQ7G8ot68RfjzxG5zqk/edZVbZ2VQ2U=";
  static const int LEVELS_OF_ENCRYPTION = 5;

  static Future<FirebaseUser> getCurrentUser() async {
    try {
      final currentUser = await _auth.currentUser();
      return currentUser;
    } catch (e) {
      print("ERROR WHILE GETTING CURRENT USER : $e");
      return null;
    }
  }

  static Future<String> getCurrentUserName() async {
    try {
      final currentUser = await getCurrentUser();
      final documentSnapshot =
          await _firestore.collection("data").document(currentUser.uid).get();
      final String firstName = documentSnapshot.data['firstName'];
      final String lastName = documentSnapshot.data['lastName'];
      return "$firstName $lastName";
    } catch (e) {
      print("ERROR WHILE GETTING CURRENT USER NAME : $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getPasswords() async {
    List<Map<String, dynamic>> passwords = [];

    try {
      final currentUser = await getCurrentUser();
      final documentSnapshot = await _firestore
          .collection("data")
          .document(currentUser.uid)
          .collection("passwords")
          .orderBy('timestamp')
          .getDocuments();
      for (var document in documentSnapshot.documents) {
        Map<String, dynamic> data = document.data;
        // decrypting password
        data['Password'] = await decryptPassword(data['Password']);
        passwords.add(data);
      }
      return passwords;
    } catch (e) {
      print("ERROR WHILE FETCHING PASSWORDS FROM FIREBASE : $e");
      return [];
    }
  }

  static Future<bool> registerUser(String email, String password,
      {String firstName, String lastName}) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        // creating document for new user
        final currentUser = await getCurrentUser();
        _firestore.collection("data").document(currentUser.uid).setData({
          "firstName": firstName,
          "lastName": lastName,
        });
        // creating passwords collection for the new user
        _firestore
            .collection("data")
            .document(currentUser.uid)
            .collection("passwords");
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
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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
        print("LOGGED OUT USER");
        return true;
      }
      return false;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING OUT USER : $e");
      return false;
    }
  }

  static Future<bool> addPassword(Map<String, dynamic> fields) async {
    // empty map received
    print("FIELDS RECEIVED $fields");
    if (fields.isNotEmpty)
      try {
        final FirebaseUser currentUser = await _auth.currentUser();
        final String userId = currentUser.uid;

        //adding timestamp and documentId to fields
        fields.addAll({
          "timestamp": FieldValue.serverTimestamp(),
          "documentId": _firestore
              .collection("data")
              .document(userId)
              .collection("passwords")
              .document()
              .documentID,
        });

        //encrypting passwords before sending to firebase
        fields['Password'] = await encryptPassword(fields['Password']);

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

  static Future<String> encryptPassword(String password) async {
    if (password == null || password == "") return "";
    String encrypted;

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

  static Future<String> decryptPassword(String password) async {
    if (password == null || password == "") return "";
    String decrypted;

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
