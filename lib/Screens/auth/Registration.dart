import 'package:connectcall/Screens/auth/Login.dart';
import 'package:connectcall/Services/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool button = false;
  bool visible = true;

  int step = 0;
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController Confirm_email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirm_pass = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController confirm_phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (step > 0) {
          setState(() {
            step--;
          });
        }
      },
      child: Theme(
        data: ThemeData.light(),
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 180,
                  width: 200,
                  child: Image.asset("assets/calling.png"),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: 70),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    height: 500,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 25),
                            if (step == 0) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 35,
                                  right: 20,
                                  left: 20,
                                ),
                                child: TextFormField(

                                  controller: email,
                                  decoration: InputDecoration(
                                    label: Text("Email"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email required";
                                    }
                                    if (!value.contains("@gmail.com")) {
                                      return "Enter valid email";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: TextFormField(
                                  controller: Confirm_email,
                                  decoration: InputDecoration(
                                    label: Text("Confirm Email"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email required";
                                    }
                                    if (Confirm_email.text != email.text) {
                                      return " Email Mismatched";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                            if (step == 1) ...[
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 35,
                                  right: 20,
                                  left: 20,
                                ),
                                child: TextFormField(
                                  controller: phone,
                                  decoration: InputDecoration(
                                    label: Text("Enter Phone number "),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Phone number required";
                                    }
                                    if (value.length != 10) {
                                      return "Phone number invalid";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: TextFormField(
                                  controller: confirm_phone,
                                  decoration: InputDecoration(
                                    label: Text("Confirm Phone Number"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Phone number  required";
                                    }
                                    if (confirm_phone.text != phone.text) {
                                      return "Phone number Mismatched";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                            if (step == 2) ...[
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 35,
                                  right: 20,
                                  left: 20,
                                ),
                                child: TextFormField(
                                  obscureText: visible,
                                  controller: pass,

                                  decoration: InputDecoration(
                                    label: Text("Password"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        visible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          visible = !visible;
                                        });
                                      },
                                    ),
                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password required";
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: TextFormField(
                                  controller: confirm_pass,
                                  obscureText: visible,
                                  decoration: InputDecoration(
                                    label: Text("Confirm Password"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        visible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          visible = !visible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password required";
                                    }
                                    if (confirm_pass.text != pass.text) {
                                      return "Password Mismatched";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],

                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: button
                                  ? null
                                  : () async {
                                      if (!_formkey.currentState!.validate()) {
                                        return;
                                      }
                                      if (step < 2) {
                                        setState(() {
                                          step++;
                                        });
                                      } else {
                                        setState(() {
                                          button = true;
                                        });

                                        final data =
                                            await Authentication.registration(
                                              email.text,
                                              pass.text,
                                              phone.text,
                                            );
                                        setState(() {
                                          button = false;
                                        });
                                        if (!context.mounted) return;
                                        if (data == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                "Registration successful",
                                              ),
                                            ),
                                          );
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Login(),
                                            ),
                                            (route) => false,
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(data),
                                            ),
                                          );
                                        }
                                      }
                                    },

                              child: Text(step < 2 ? "Next" : "Signup"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an  have an account ? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
