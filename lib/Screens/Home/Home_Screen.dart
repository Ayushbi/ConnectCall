import 'package:connectcall/Common_button.dart';

import 'package:connectcall/Screens/Contact/contact.dart';
import 'package:connectcall/Screens/Home/Homcontent.dart';
import 'package:connectcall/Screens/history/calling_history.dart';
import 'package:connectcall/Screens/profile/Profile.dart';

import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {


  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index=0;
List<Widget>pages=[Homecontent(),Contact(),Call_history(),Profile()];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        body: pages[index],
        bottomNavigationBar: Button.Bottombar(
          context,
          index,
              (item) {
            setState(() {
              index = item;
            });
          },
        ),

    );
  }
}
