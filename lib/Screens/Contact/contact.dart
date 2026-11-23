import 'dart:async';

import 'package:connectcall/Controller/Call_Controller.dart';
import 'package:connectcall/Models/Contact_model.dart';
import 'package:connectcall/Navigator/GlobalNav.dart';
import 'package:connectcall/Screens/Contact/Add_contact.dart';
import 'package:connectcall/Screens/Home/Homcontent.dart';
import 'package:connectcall/Services/UserInfo.dart';
import 'package:connectcall/Utilities/Phone_normalize.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as PhoneContact;
import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';



class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  int? Contactindex;
  bool Tapped = false;
  List<PhoneContact.Contact> FilterList = Contacts;
  final TextEditingController searchController = TextEditingController();
  bool search = false;
  bool select = false;
  Set<int> selectedContacts = {};


  @override
  void initState() {
    super.initState();

    Controller.receiveOffer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contacts",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                    padding: EdgeInsets.only(
                      top: 12,
                      right: 20,
                      left: 20,
                      bottom: 7,
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          FilterList = Contacts.where((contact) {
                            return (contact.displayName ?? "")
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search contacts",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                        if (!search) {
                          searchController.clear();
                          FilterList = Contacts;
                        }
                      },
                      icon: Icon(Icons.search),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          select = !select;

                          if (select) {
                            selectedContacts = Set.from(
                              List.generate(
                                FilterList.length,
                                (index) => index,
                              ),
                            );
                          } else {
                            selectedContacts.clear();
                          }
                        });
                      },
                      icon: Icon(select ? Icons.deselect : Icons.select_all),
                    ),
                  ],
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: FilterList.length,
                    itemBuilder: (context, index) {
                      final contact = FilterList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: contact.photo?.fullSize != null
                              ? MemoryImage(contact.photo!.fullSize!)
                              : null,
                          child: contact.photo?.fullSize == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(contact.displayName ?? "No name"),
                        subtitle: Text(
                          contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : "No phone",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("coming soon"),
                                      content: Text(
                                        "Video calling is not available yet.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            navigation.currentState!.pop();
                                          },
                                          child: Text("cancel"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.videocam),
                            ),

                            IconButton(
                              onPressed: Contactindex == index
                                  ? null
                                  : () async {
                                      setState(() {
                                        Contactindex = index;
                                      });
                                      try {
                                        if (contact.phones.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                "No phone number available",
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        final Phone = NormalizePhone(
                                          contact.phones.first.number,
                                        );

                                        final user = await UserData.Checkuser(
                                          Phone,
                                        ).timeout(Duration(seconds: 5));
                                        if (user != null) {
                                          final id = user;
                                          await Controller.Startcall(
                                            reciver_id: id,
                                            name:
                                                contact.displayName ??
                                                "Unknown",
                                          ).timeout(Duration(seconds: 5));
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                "phone number is Not registered",
                                              ),
                                            ),
                                          );
                                          await Future.delayed(
                                            Duration(seconds: 1),
                                          );
                                          SharePlus.instance.share(
                                            ShareParams(
                                              title: "Share App",
                                              text:
                                                  "Hey! I'm using ConnectCall. You should try it too!",
                                            ),
                                          );
                                        }
                                      } on TimeoutException {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                              "Network error. Please try again.",
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text("$e"),
                                          ),
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            Contactindex = null;
                                          });
                                        }
                                      }
                                    },
                              icon: Contactindex == index
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(Icons.call),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContact()),
                  );
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
