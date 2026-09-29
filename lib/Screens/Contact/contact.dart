import 'package:connectcall/Database/Contact.dart';
import 'package:connectcall/Models/Contact_model.dart';
import 'package:connectcall/Screens/Contact/Add_contact.dart';
import 'package:flutter/material.dart';


class Contact extends StatefulWidget {
  const Contact({super.key,});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<ContactModel> Contacts=[];
  List<ContactModel>FilterList=[];

  bool search = false;
  bool select = false;
  Set<int> selectedContacts = {};
   LoadContact()async{
     var data =await contact().Getcontact();
     setState(() {
       Contacts=data;
       FilterList=data;
     });
   }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contacts",
          style: TextStyle(

            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          if (select)
            PopupMenuButton(
              itemBuilder: (context) {
                return [PopupMenuItem(child: Text("Delete"), value: "delete")];
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (search)
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                       FilterList=Contacts.where((Contact){
                         return Contact.name.toLowerCase().contains(value.toLowerCase());

                       }).toList();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search contacts",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          search = !search;
                        });
                      },
                      icon: Icon(Icons.search, color: Colors.black),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          select = !select;

                          if (select) {
                            selectedContacts = Set.from(
                              List.generate(30, (index) => index),
                            );
                          } else {
                            selectedContacts.clear();
                          }
                        });
                      },
                      icon: Icon(
                        select ? Icons.deselect : Icons.select_all,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: FilterList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text(Contacts[index].name),
                        subtitle: Text(Contacts[index].email ??""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Video call
                              },
                              icon: Icon(Icons.videocam),
                            ),

                            IconButton(
                              onPressed: () {
                                // Audio call
                              },
                              icon: Icon(Icons.call),
                            ),
                            if (select)
                              Checkbox(
                                value: selectedContacts.contains(index),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedContacts.add(index);
                                    } else {
                                      selectedContacts.remove(index);
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>AddContact()));
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
