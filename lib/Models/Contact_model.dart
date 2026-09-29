
import 'package:flutter/foundation.dart';

class ContactModel {
  String name;
  String id;
  String email;
  ContactModel({
    required this.name,
    required this.email,
    required this.id
});
  factory  ContactModel.FromData(String id ,Map<dynamic,dynamic>data){
    return ContactModel(name: data['Name'],email: data['email'], id: id);
  }

}