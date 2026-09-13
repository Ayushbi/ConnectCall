import 'package:connectcall/Database/Authentication.dart';
import 'package:connectcall/Screens/Home/Homcontent.dart';
import 'package:connectcall/Screens/Home/Home_Screen.dart';
import 'package:connectcall/Screens/auth/Registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Container(
                child: Image.asset("assets/calling.png"),
                height: 200,
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                height: 500,
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 90),
                      TextFormField(
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

                      SizedBox(height: 15),

                      TextFormField(
                        controller: pass,
                        decoration: InputDecoration(
                          label: Text("pass"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password required";
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              right: 60,
              child: Container(
                height: 60,
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {


                       final user=await Db.Login(email.text, pass.text);
                       if(user==true){
                       Navigator.pushReplacement(context,
                           MaterialPageRoute(builder: (context)=>HomeScreen()));

                      }
                    }
                  },
                  child: Text("login"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account ? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "Signup",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
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
    );
  }
}
