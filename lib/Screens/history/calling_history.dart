
import 'package:connectcall/Common_button.dart';
import 'package:flutter/material.dart';

class Call_history extends StatefulWidget {
  const Call_history({super.key});

  @override
  State<Call_history> createState() => _Call_historyState();
}

class _Call_historyState extends State<Call_history> {
  bool outgoing=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call history",style: TextStyle(

          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        ),
      ),
      body: SafeArea(child:
          Center(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Text("Calls",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
     Expanded(child:
     ListView.builder(
       itemCount: 15,

         itemBuilder: (context,index){

       return ListTile(
         leading: Icon(Icons.person),
         title: Text("Ankit"),
         subtitle: Row(
           children: [
             outgoing
             ? Row(
               children: [
                 Icon(Icons.call_made),
                 Text("Outgoing"),
               ],
             )
                 : Row(
               children: [
                 Icon(Icons.call_received),
                 Text("Incoming"),
               ],
             )
           ],
         ),
         trailing: Text("10:30 AM"),
         onTap: () {
           print("Tapped");
         },
       );

     })
     ),


      ],)),
      ),

    );
  }
}
