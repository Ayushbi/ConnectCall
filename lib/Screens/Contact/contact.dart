import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  bool search = false;
  bool select = false;
  Set<int> selectedContacts = {};

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
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text("Contact $index"),
                        subtitle: Text("Online"),
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
                onPressed: () {},
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
