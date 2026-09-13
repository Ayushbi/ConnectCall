
import 'package:flutter/material.dart';
class Button {
  static BottomNavigationBar Bottombar(BuildContext context,currentindex, Function(int) onTap,){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
   currentIndex: currentindex,
        onTap: onTap,
        items:const[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home"

      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.contact_page),
        label: "Contacts"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: "Call_history"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile"
      )
    ] );
  }


}