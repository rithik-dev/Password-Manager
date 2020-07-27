import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  static getCurrentUser() async {
    final currentUser = await _auth.currentUser();
    return currentUser;
  }

  static Future<bool> registerUser(String email, String password) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null)
        return true;
      else
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

  static void addToCollection(Map<String,dynamic> fields) async {
    final FirebaseUser currentUser = await _auth.currentUser();
    final String userId = currentUser.uid;
    _firestore.collection(userId).add(fields);
  }
}
