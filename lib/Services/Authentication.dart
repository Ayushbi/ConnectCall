import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<String?> registration(
    String email,
    String pass,
    String Phone,
  ) async {
    try {
      if (email.isNotEmpty && pass.isNotEmpty) {
        final register = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);

        if (register.user != null) {
          final user_id = register.user!.uid;
          await db.collection("Phone").doc(user_id).set({
            "email": email,
            "phone": Phone,
          });
          await FirebaseAuth.instance.signOut();
          return null;
        }

        return "Registration failed";
      }
      return "Please enter email and password";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);

      return e.message ?? "Registration failed";
    } catch (e) {
      final error = e.toString();
      return error.isNotEmpty ? error : "Something went wrong";
    }
  }

  static Future<String?> Login(String email, String pass) async {
    try {
      if (email.isNotEmpty && pass.isNotEmpty) {
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        if (user.user != null) {
          return null;
        }
        return "Login failed";
      }
      return "Please enter email and password";
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      return e.message ?? "Login failed";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<Map<String, String>>userDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {"email": "No email", "phone": "No phone number"};
    }

    final doc = await FirebaseFirestore.instance
        .collection("Phone")
        .doc(user.uid)
        .get();

    final email = user.email ?? "No email";
    final phone = doc.data()?['phone'] ?? "No phone number";

    return {"email": email, "phone": phone.toString()};
  }

  static Future<void> Logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> Changepass({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final email = user.email;

        final credential = EmailAuthProvider.credential(
          email: email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);

        return true;
      } catch (e) {
        rethrow;
      }
    }

    return false;
  }


  static Future<bool> DeleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
        await user.delete();
        return true;
      }

      return false;
    } catch (e) {
      print("REAUTHENTICATION ERROR: $e");
      return false;
    }
  }
}
