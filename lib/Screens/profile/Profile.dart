import 'dart:io';

import 'package:connectcall/Screens/Riverpod/ScreenTheme.dart';
import 'package:connectcall/Screens/auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  bool edit = false;
  XFile? selected;
  final ImagePicker image = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: selected!=
                          null?FileImage(File(selected!.path)):null,

                    ),
                    onTap: () async {
                      final XFile? file = await image.pickImage(
                        source: ImageSource.gallery,
                      );
                      if(file!=null) {
                        setState(() {
                        selected=file;
                        });
                      }
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 6),
                      edit
                          ? SizedBox(
                              width: 150,
                              child: TextField(
                                decoration: InputDecoration(labelText: "Name"),
                              ),
                            )
                          : Text("Ayush", style: TextStyle(fontSize: 16)),

                      SizedBox(width: width * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, size: 12, color: Colors.green),
                          SizedBox(width: width * 0.06),
                          Text("Online"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 6),
                      edit
                          ? SizedBox(
                              width: 200,
                              child: TextField(
                                decoration: InputDecoration(labelText: "Email"),
                              ),
                            )
                          : Text(
                              "ayushbijalm@gmail.com",
                              style: TextStyle(fontSize: 16),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text("Dark Theme"),
              trailing: Switch(
                value: ref.watch(Themeprovider),

                onChanged: (value) {
                  ref.read(Themeprovider.notifier).state = value;
                },
              ),
            ),

            ListTile(
              leading: Icon(Icons.edit),
              title: edit ? Text("Save") : Text("Edit"),
              onTap: () {
                setState(() {
                  edit = true;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                final id = await SharedPreferences.getInstance();
                final logout = id.remove("id");
                if (logout != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }
              },
            ),
            if (edit)
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text("Cancel"),
                onTap: () {
                  setState(() {
                    edit = false;
                  });
                },
              ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("share"),
              onTap: () {
                SharePlus.instance.share(
                  ShareParams(text: "Download Connect Call app"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
