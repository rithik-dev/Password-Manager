import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:password_manager/models/exceptions.dart';

class FirebaseUtils {
  //preventing the class from being instantiated
  FirebaseUtils._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  static final PlatformStringCryptor _cryptor = new PlatformStringCryptor();
  static const int LEVELS_OF_ENCRYPTION = 5;

  static final String defaultProfilePicURL =
      "https://firebasestorage.googleapis.com/v0/b/password-manager-2083b.appspot.com/o/Profile%20Pictures%2FuserDefaultProfilePicture.png?alt=media&token=ee3d17ce-b1e2-4a53-bb86-13dac6d3af09";

  static final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://password-manager-2083b.appspot.com');

  static Future<String> uploadFile(String userId, File image) async {
    StorageUploadTask uploadTask =
        _storage.ref().child('Profile Pictures/$userId.png').putFile(image);
    await uploadTask.onComplete;
    String fileURL = await _storage
        .ref()
        .child('Profile Pictures/$userId.png')
        .getDownloadURL();
    return fileURL;
  }

  static Future<FirebaseUser> getCurrentUser() async {
    try {
      final FirebaseUser currentUser = await _auth.currentUser();
      if (currentUser != null && currentUser.isEmailVerified)
        return currentUser;
      else
        return null;
    } catch (e) {
      print("ERROR WHILE GETTING CURRENT USER : $e");
      return null;
    }
  }

  static Future<String> getCurrentUserEmail() async {
    try {
      final FirebaseUser user = await getCurrentUser();
      if (user != null) {
        return user.email;
      } else
        return "";
    } catch (e) {
      print("ERROR WHILE GETTING CURRENT USER EMAIL : $e");
      return "";
    }
  }

  static Future<Map<String, dynamic>> getAppData(
      FirebaseUser currentUser) async {
    List<Map<String, dynamic>> passwords = [];
    String fullName;
    String key;
    String profilePicURL;

    try {
      final DocumentSnapshot dataSnapshot =
          await _firestore.collection("data").document(currentUser.uid).get();
      if (dataSnapshot.data == null) {
        fullName = "";
        key = "";
        profilePicURL = defaultProfilePicURL;
      } else {
        fullName = dataSnapshot.data['fullName'];
        key = dataSnapshot.data['key'];
        profilePicURL = dataSnapshot.data['profilePicURL'];
      }

      final documentSnapshot = await _firestore
          .collection("data")
          .document(currentUser.uid)
          .collection("passwords")
          .orderBy('Title')
          .getDocuments();

      for (var document in documentSnapshot.documents) {
        Map<String, dynamic> data = document.data;
        // decrypting password
        if (data.containsKey('Password'))
          data['Password'] = await _decryptPassword(data['Password'], key);
        passwords.add(data);
      }

      final Map<String, dynamic> appData = {
        'name': fullName,
        'passwords': passwords,
        'key': key,
        'profilePicURL': profilePicURL,
      };

      return appData;
    } catch (e) {
      print("ERROR WHILE GETTING APP DATA : $e");
      throw AppDataReceiveException(
          "An error occurred while fetching data. Please restart the app or try deleting the account and creating a new one !");
    }
  }

  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("ERROR WHILE SENDING PASSWORD RESET EMAIL : $e");
      throw ForgotPasswordException(e.message);
    }
  }

  static Future<bool> resendEmailVerificationLink(String email,
      String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        await user.user.sendEmailVerification();
        return true;
      } else
        return false;
    } catch (e) {
      print("ERROR WHILE RE SENDING EMAIL VERIFICATION LINK : $e");
      return false;
    }
  }

  static Future<bool> registerUser(String email, String password,
      {String fullName, File image}) async {
    try {
      final AuthResult user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String profilePicURL = defaultProfilePicURL;
      if (image != null) profilePicURL = await uploadFile(user.user.uid, image);

      await user.user.sendEmailVerification();

      if (user != null) {
        //creating a unique key for encrypting passwords for each user
        final String _key = await _cryptor.generateRandomKey();

        // creating document for new user
        _firestore.collection("data").document(user.user.uid).setData({
          "fullName": fullName,
          "key": _key,
          "profilePicURL": profilePicURL,
        });
        return true;
      } else
        return false;
    } catch (e) {
      print("EXCEPTION WHILE REGISTERING NEW USER : $e");
      throw RegisterException(e.message);
    }
  }

  static Future<bool> loginUser(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        if (user.user.isEmailVerified)
          return true;
        else
          throw LoginException("EMAIL_NOT_VERIFIED");
      } else
        return false;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING IN USER : $e");
      throw LoginException(e.message);
    }
  }

  static Future<bool> logoutUser() async {
    try {
      _auth.signOut();
      return true;
    } catch (e) {
      print("EXCEPTION WHILE LOGGING OUT USER : $e");
      return false;
    }
  }

  static Future<String> addPasswordFieldToDatabase(Map<String, dynamic> _fields,
      FirebaseUser currentUser, String key) async {
    // check if empty map is not received
    if (_fields.isNotEmpty)
      try {
        final String userId = currentUser.uid;

        Map<String, dynamic> fields = Map<String, dynamic>.from(_fields);

        String docID = _firestore
            .collection("data")
            .document(userId)
            .collection("passwords")
            .document()
            .documentID;

        //adding documentId to fields
        fields.addAll({
          "documentId": docID,
        });

        //encrypting passwords before sending to firebase
        if (fields['Password'] != null && fields['Password'] != "")
          fields['Password'] = await _encryptPassword(fields['Password'], key);
        else
          fields.remove('Password');

        //setting the value of the new document with fields
        await _firestore
            .collection("data")
            .document(userId)
            .collection("passwords")
            .document(fields['documentId'])
            .setData(fields);

        return docID;
      } catch (e) {
        print("ERROR WHILE ADDING NEW PASSWORD : $e");
        return null;
      }
    else
      //fields is empty
      return null;
  }

  static Future<bool> editPasswordFieldInDatabase(
      Map<String, dynamic> newFields,
      FirebaseUser currentUser,
      String key) async {
    try {
      final String userId = currentUser.uid;

      Map<String, dynamic> fields = Map<String, dynamic>.from(newFields);

      //encrypting passwords before sending to firebase
      if (fields.containsKey('Password'))
        fields['Password'] = await _encryptPassword(fields['Password'], key);

      // adding new data
      await _firestore
          .collection("data")
          .document(userId)
          .collection("passwords")
          .document(newFields['documentId'])
          .setData(fields, merge: false);

      return true;
    } catch (e) {
      print("ERROR WHILE UPDATING PASSWORD $e");
      return false;
    }
  }

  static Future<bool> deletePasswordFieldFromDatabase(String documentId,
      FirebaseUser currentUser) async {
    try {
      final String userId = currentUser.uid;

      await _firestore
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

  static Future<bool> changeCurrentUserName(String name,
      FirebaseUser currentUser) async {
    try {
      await _firestore
          .collection("data")
          .document(currentUser.uid)
          .setData({"fullName": name}, merge: true);
      return true;
    } catch (e) {
      print("ERROR WHILE CHANGING CURRENT USER NAME : $e");
      return false;
    }
  }

  static Future<bool> changeCurrentUserPassword(String oldPassword,
      String newPassword) async {
    try {
      final FirebaseUser user = await getCurrentUser();

      AuthCredential credential = EmailAuthProvider.getCredential(
          email: user.email, password: oldPassword);
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print("ERROR WHILE CHANGING CURRENT USER PASSWORD : $e");
      throw ChangePasswordException(e.message);
    }
  }

  static Future<bool> deleteCurrentUser(String password) async {
    try {
      final FirebaseUser user = await getCurrentUser();

      AuthCredential credential = EmailAuthProvider.getCredential(
          email: user.email, password: password);
      await user.reauthenticateWithCredential(credential);

      if (user != null) {
        // first deleting passwords
        final passwordsSnapshot = await _firestore
            .collection("data")
            .document(user.uid)
            .collection("passwords")
            .getDocuments();

        for (var passwordField in passwordsSnapshot.documents)
          await _firestore
              .collection("data")
              .document(user.uid)
              .collection("passwords")
              .document(passwordField.data['documentId'])
              .delete();

        // deleting users document
        await _firestore.collection("data").document(user.uid).delete();
        // deleting user
        await user.delete();
      }
      return true;
    } catch (e) {
      print("ERROR WHILE DELETING USER : $e");
      throw DeleteUserException(e.message);
    }
  }

  static Future<String> _encryptPassword(String password, String _key) async {
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

  static Future<String> _decryptPassword(String password, String _key) async {
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
