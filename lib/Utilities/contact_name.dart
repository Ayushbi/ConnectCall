import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> Contactname(String id) async {
  final user = await FirebaseFirestore.instance
      .collection("Phone")
      .doc(id)
      .get();
  final phone = user.data()?["phone"];
  return phone;
}
