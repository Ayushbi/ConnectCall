import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final ImagePicker image = ImagePicker();
  XFile? SelectFile;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> AddContact() async {
    final permission = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );
    final imagedata = SelectFile != null
        ? await SelectFile!.readAsBytes()
        : null;
    if (permission == PermissionStatus.granted) {
      final newContact = Contact(
        name: Name(first: name.text),
        phones: [Phone(number: phone.text)],
        emails: [Email(address: email.text)],
        photo: imagedata!=null ? Photo(fullSize: imagedata) : null,
      );

      await FlutterContacts.create(newContact);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Contact saved to phone!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        title: Text(
          "New Contact",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: SelectFile != null
                        ? FileImage(File(SelectFile!.path))
                        : null,
                  ),
                  onTap: () async {
                    final XFile? file = await image.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) {
                      setState(() {
                        SelectFile = file;
                      });
                    }
                  },
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 7),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Name",
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 7),
                  child: TextField(
                    controller: phone,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: "Phone",
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 7),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: "Email",
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                FloatingActionButton(
                  onPressed: () async {
                    await AddContact();
                    email.clear();
                    name.clear();
                    phone.clear();
                    setState(() {
                      SelectFile = null;
                    });
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
