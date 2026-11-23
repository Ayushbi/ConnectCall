import 'package:connectcall/Controller/Call_Controller.dart';
import 'package:connectcall/Models/call_history.dart';
import 'package:connectcall/Screens/Contact/contact.dart';
import 'package:connectcall/Screens/history/calling_history.dart';
import 'package:connectcall/Screens/profile/Profile.dart';
import 'package:connectcall/Services/UserInfo.dart';
import 'package:connectcall/Utilities/Phone_normalize.dart';
import 'package:connectcall/Utilities/contact_name.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as PhoneContact;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
List<PhoneContact.Contact> Contacts = [];
class Homecontent extends StatefulWidget {
  const Homecontent({super.key});

  @override
  State<Homecontent> createState() => _HomecontentState();
}

class _HomecontentState extends State<Homecontent> {
  bool search = false;
  final contacts = Contacts;
  bool outgoing = false;
  bool loading = true;
  Map<String, String> contactNames = {};
  List<Call_History> call_history = [];
  List<Call_History> filter = [];
  TextEditingController search_number = TextEditingController();
  TextEditingController number = TextEditingController();

  Future<void> Call() async {
    final data = await UserData.CallHistory();
    if (!mounted) return;
    setState(() {
      call_history = data;
      filter = data;

      loading = false;
    });
  }
  Future<void> Getcontacts() async {
    final permission = await PhoneContact.FlutterContacts.permissions.request(
      PhoneContact.PermissionType.readWrite,
    );
    if (permission == PhoneContact.PermissionStatus.granted) {
      final Contact = await PhoneContact.FlutterContacts.getAll(
        properties: {
          PhoneContact.ContactProperty.name,
          PhoneContact.ContactProperty.phone,
          PhoneContact.ContactProperty.email,
          PhoneContact.ContactProperty.photoFullRes,
        },
      );

      if (!mounted) return;
      setState(() {
        Contacts = Contact;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    Getcontacts();
    Call();
  }

  Widget dialButton(String value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: Size(80, 80)),
      onPressed: () {
        setState(() {
          number.text += value;
        });
      },
      child: Text(value, style: TextStyle(fontSize: 25)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Connect call",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: loading
          ? Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(strokeWidth: 5),
        ),
      )
          : SafeArea(
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 120,
                    width: 150,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Call_history(),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.call, size: 45),
                            SizedBox(height: height * 0.01),
                            Text(
                              "Call History",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 120,
                    width: 150,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Contact(),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.contacts, size: 45),
                            SizedBox(height: height * 0.01),
                            Text(
                              "Contacts",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            Column(
              children: [
                Text(
                  "Recent calls",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: call_history.length,

                itemBuilder: (context, index) {
                  return FutureBuilder<String?>(
                    future: Contactname(call_history[index].user_id),

                    builder: (context, snapshot) {
                      final phone = snapshot.data;
                      String Displayname = phone ?? "";
                      if (phone != null) {
                        try {
                          final Contact = Contacts.firstWhere((data) {
                            return data.phones.any((p) {
                              return NormalizePhone(p.number) ==
                                  NormalizePhone(phone);
                            });
                          });

                          Displayname = Contact.displayName ?? phone;
                        } catch (e) {}
                      }

                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(Displayname),
                        subtitle: Row(
                          children: [
                            call_history[index].Direction == "outgoing"
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
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              call_history[index].started_at != null
                                  ? DateFormat('hh:mm a').format(
                                call_history[index].started_at!
                                    .toDate(),
                              )
                                  : "",
                            ),
                            Text(
                              "${call_history[index].Duration} Seconds",
                            ),
                          ],
                        ),
                        onTap: () {
                          print("Tapped");
                        },
                      );
                    },
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  controller: number,
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter number",
                                  ),
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (number.text.isNotEmpty) {
                                      number.text = number.text.substring(
                                        0,
                                        number.text.length - 1,
                                      );
                                    }
                                  });
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.02),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.5,

                            children: [
                              dialButton("1"),
                              dialButton("2"),
                              dialButton("3"),
                              dialButton("4"),
                              dialButton("5"),
                              dialButton("6"),
                              dialButton("7"),
                              dialButton("8"),
                              dialButton("9"),
                              dialButton("*"),
                              dialButton("0"),
                              dialButton("#"),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            child: IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (number.text.length != 10) {
                                  Navigator.pop(context);
                                  number.clear();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Check your number",
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          "Invalid number",
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  );
                                  return;
                                }
                                final receiverId =
                                await UserData.Checkuser(number.text);
                                final enteredNumber = number.text;
                                String name = enteredNumber;
                                try {
                                  final contact = Contacts.firstWhere((data) {
                                    return data.phones.any((p) {
                                      return NormalizePhone(p.number) ==
                                          NormalizePhone(enteredNumber);
                                    });
                                  });
                                  name = contact.displayName ?? enteredNumber;
                                } catch (e) {}

                                if (receiverId == null) {
                                  Navigator.pop(context);
                                  number.clear();
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

                                  return;
                                }


                                number.clear();
                                Navigator.pop(context);
                                await Controller.Startcall(
                                    reciver_id: receiverId,
                                    name:name
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.dialpad),
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      ),
    );
  }
}
