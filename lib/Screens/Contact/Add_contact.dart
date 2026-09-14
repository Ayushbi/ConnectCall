import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final ImagePicker image = ImagePicker();
  XFile? SelectFile;

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
        child: Center(
          child: Column(
            children: [
              SizedBox(height: height * 0.04),
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
              SizedBox(height: height * 0.04),
              Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Name",
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    hintText: "Phone",
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: "Email",
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              FloatingActionButton(onPressed: () {}, child: Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
