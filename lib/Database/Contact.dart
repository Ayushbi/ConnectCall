import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/Models/Contact_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class contact {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  Future<dynamic> SaveContact(
    String number,
    String name, [
    String? email,
    XFile? image,
  ]) async {
    try {
      final Collection = db.collection("contact").doc();
      await Collection.set({"phone": number, "Name": name, "email": email});

      // if (image != null) {
      //   final ref = storage.ref().child("Profile/${Collection.id}");
      //   final bytes = await image.readAsBytes();
      //   await ref.putData(bytes);
      // }
      return true;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> Getcontact() async {
    try {
      final data = await db.collection("contact").get();
      List<ContactModel> contacts = data.docs.map((item) {
        return ContactModel.FromData(
          item.id,
          item.data(),
        );
      }).toList();

      return contacts;

    } catch (e) {
      return e;
    }
  }
}
