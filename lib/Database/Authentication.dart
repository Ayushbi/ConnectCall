import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Db {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<bool> signin(String Email, String pass) async {
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email,
        password: pass,
      );
      if (user.user != null) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> Login(String Email, String pass) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email,
        password: pass,
      );
      if (user.user != null) {
        final id = user.user!.uid;
       final SharedPreferences Userlogin = await SharedPreferences.getInstance();
       await Userlogin.setString("id", id);
        return true;

      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
