import 'dart:async';

import 'package:connectcall/Screens/Home/Homcontent.dart';

import 'package:connectcall/Screens/auth/Registration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer((Duration(seconds: 3)), () async {
      if (!mounted) return;

      final userid = await SharedPreferences.getInstance();
      final id = userid.getString("id");
      if (id != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homecontent()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Registration()),
        );
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 130, child: Image.asset("assets/calling.png")),

            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
