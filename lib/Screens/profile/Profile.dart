import 'dart:io';

import 'package:connectcall/Navigator/GlobalNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectcall/Screens/Riverpod/ScreenTheme.dart';
import 'package:connectcall/Screens/auth/Login.dart';
import 'package:connectcall/Screens/auth/Registration.dart';
import 'package:connectcall/Services/Authentication.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

String? user;

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  TextEditingController Email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool edit = false;
  XFile? selected;
  final ImagePicker image = ImagePicker();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? email;
  String? phone;
  bool hideOldPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  Future<void> userDetails() async {
    final data = await Authentication().userDetails();
    if (!mounted) return;

    setState(() {
      email = data["email"];
      phone = data["phone"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDetails();
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: selected != null
                            ? FileImage(File(selected!.path))
                            : null,
                      ),
                      onTap: () async {
                        final XFile? file = await image.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (file != null) {
                          setState(() {
                            selected = file;
                          });
                        }
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 6),
                            edit
                                ? SizedBox(
                                    width: 190,
                                    child: TextField(
                                      controller: Email,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                      ),
                                    ),
                                  )
                                : Text(
                                    email ?? "",
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ],
                        ),
                        if (!edit) ...[
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.circle, size: 12, color: Colors.green),
                              SizedBox(width: width * 0.01),
                              Text(phone ?? ""),
                            ],
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: height * 0.03),
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
                    edit = !edit;
                    Email.clear();
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  Authentication.Logout();
                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
                  );
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
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Change Password"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.symmetric(horizontal: 30),
                            title: Text("Change Password"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "old password",

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          hideOldPassword = !hideOldPassword;
                                        });
                                      },
                                      icon: Icon(
                                        hideOldPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  controller: oldPasswordController,
                                  obscureText: hideOldPassword,
                                ),
                                SizedBox(height: height * 0.009),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "New password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          hideNewPassword = !hideNewPassword;
                                        });
                                      },
                                      icon: Icon(
                                        hideNewPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  controller: newPasswordController,
                                  obscureText: hideNewPassword,
                                ),
                                SizedBox(height: height * 0.009),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Confirm New password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          hideConfirmPassword =
                                              !hideConfirmPassword;
                                        });
                                      },
                                      icon: Icon(
                                        hideConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  controller: confirmPasswordController,
                                  obscureText: hideConfirmPassword,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  newPasswordController.clear();
                                  oldPasswordController.clear();
                                  confirmPasswordController.clear();
                                },
                                child: Text("cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (newPasswordController.text ==
                                      confirmPasswordController.text) {
                                    if (newPasswordController.text.length >=
                                        6) {
                                      try {
                                        final res =
                                            await Authentication.Changepass(
                                              currentPassword:
                                                  oldPasswordController.text,
                                              newPassword:
                                                  newPasswordController.text,
                                            );
                                        if (res == true) {
                                          Navigator.pop(context);
                                          newPasswordController.clear();
                                          oldPasswordController.clear();
                                          confirmPasswordController.clear();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                "Password changed successfully",
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      newPasswordController.clear();
                                      oldPasswordController.clear();
                                      confirmPasswordController.clear();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            " Password must be at least 6 characters long",
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    Navigator.pop(context);
                                    newPasswordController.clear();
                                    oldPasswordController.clear();
                                    confirmPasswordController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text("Password mismatch"),
                                      ),
                                    );
                                  }
                                },

                                child: Text("Save"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete Your account"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Delete Account"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Are you sure you want to delete your account?",
                            ),
                            SizedBox(height: height * 0.009),
                            TextField(
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              password.clear();
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              final email = user?.email;
                              final delete = await Authentication.DeleteAccount(
                                email: email!,
                                password: password.text,
                              );
                              Navigator.pop(context);

                              if (delete == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                      "Account deleted successfully",
                                    ),
                                  ),
                                );

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Registration(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Account deletion failed"),
                                  ),
                                );
                              }
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                  password.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
