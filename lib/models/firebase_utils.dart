import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:password_manager/models/exceptions.dart';

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
      if(currentUser!=null && currentUser.isEmailVerified)
        return currentUser;
      else
        return null;
    } catch (e) {
      print("ERROR WHILE GETTING CURRENT USER : $e");
      return null;
    }
  }

  static Future<String> getCurrentUserEmail() async{
    try{
      final FirebaseUser user = await getCurrentUser();
      if(user != null) {
        return user.email;
      }
      else
        return "";
    }
    catch(e) {
      print("ERROR WHILE GETTING CURRENT USER EMAIL : $e");
      return "";
    }
  }

  static Future<Map<String,dynamic>> getAppData(FirebaseUser currentUser) async{
    List<Map<String, dynamic>> passwords = [];
    String fullName;

    try{
      final DocumentSnapshot fullNameSnapshot = await _firestore.collection("data").document(currentUser.uid).get();
      if(fullNameSnapshot.data==null)
        fullName = "";
      else
        fullName = fullNameSnapshot.data['fullName'];

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

      final Map<String,dynamic> appData = {
        'name' : fullName,
        'passwords' : passwords,
      };
      return appData;
    }
    catch(e) {
      print("ERROR WHILE GETTING APP DATA : $e");
      throw AppDataReceiveException("An error occurred while fetching data. Please restart the app or try deleting the account and creating a new one !");
    }
  }

  static Future<List<Map<String, dynamic>>> getPasswords(FirebaseUser currentUser) async {
    List<Map<String, dynamic>> passwords = [];

    try {
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

  static Future<bool> sendPasswordResetEmail(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    }
    catch(e) {
      print("ERROR WHILE SENDING PASSWORD RESET EMAIL : $e");
      throw ForgotPasswordException(e.message);
    }
  }

  static Future<bool> resendEmailVerificationLink(String email,String password) async{
    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        await user.user.sendEmailVerification();
        return true;
      }
      else return false;
    } catch(e) {
      print("ERROR WHILE RE SENDING EMAIL VERIFICATION LINK : $e");
      return false;
    }
  }

  static Future<bool> registerUser(String email, String password, {String fullName}) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await user.user.sendEmailVerification();

      if (user != null) {

        //creating a unique key for encrypting passwords for each user
        final String _key = await _cryptor.generateRandomKey();

        // creating document for new user
        _firestore.collection("data").document(user.user.uid).setData({
          "fullName": fullName,
          "key": _key,
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
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        if(user.user.isEmailVerified)
          return true;
        else
          throw LoginException("EMAIL_NOT_VERIFIED");
      }
      else
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

  static Future<bool> addPasswordFieldToDatabase(Map<String, dynamic> fields,FirebaseUser currentUser) async {
    // check if empty map is not received
    if (fields.isNotEmpty)
      try {
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

  static Future<bool> editPasswordFieldInDatabase(Map<String, dynamic> newFields,FirebaseUser currentUser) async {
    try {
      final String userId = currentUser.uid;

      Map<String,dynamic> fields = Map<String,dynamic>.from(newFields);

      fields['Password'] = await _encryptPassword(fields['Password']);

      // adding new data
      _firestore
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

  static Future<bool> deletePasswordFieldFromDatabase(String documentId,FirebaseUser currentUser) async {
    try {
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

  static Future<bool> changeCurrentUserName(String name,FirebaseUser currentUser) async{
    try{
      await _firestore.collection("data").document(currentUser.uid).setData({"fullName" : name},merge: true);
      return true;
    }
    catch(e){
      print("ERROR WHILE CHANGING CURRENT USER NAME : $e");
      return false;
    }
  }

  static Future<bool> changeCurrentUserPassword(String password) async{
    if(password == null) return true;
    try{
      final FirebaseUser user = await getCurrentUser();
      await user.updatePassword(password);
      return true;
    }
    catch(e){
      print("ERROR WHILE CHANGING CURRENT USER PASSWORD : $e");
      throw ChangePasswordException(e.message);
    }
  }

  static Future<bool> deleteCurrentUser() async{
    try{
      final FirebaseUser user = await getCurrentUser();
      if (user != null) {
        // first deleting passwords
        final passwordsSnapshot =
          await _firestore.collection("data").document(user.uid).collection("passwords").getDocuments();

        for(var passwordField in passwordsSnapshot.documents)
          await _firestore.collection("data").document(user.uid).collection("passwords").document(passwordField.data['documentId']).delete();

          // deleting users collection
        await _firestore.collection("data").document(user.uid).delete();
        // deleting user
        await user.delete();
      }
      return true;
    }
    catch(e){
      print("ERROR WHILE DELETING USER : $e");
      throw DeleteUserException(e.message);
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
