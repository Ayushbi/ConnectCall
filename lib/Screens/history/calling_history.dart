
import 'package:connectcall/Models/call_history.dart';
import 'package:connectcall/Screens/Contact/contact.dart';
import 'package:connectcall/Screens/Home/Homcontent.dart';
import 'package:connectcall/Services/UserInfo.dart';
import 'package:connectcall/Utilities/Phone_normalize.dart';
import 'package:connectcall/Utilities/contact_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Call_history extends StatefulWidget {
  const Call_history({super.key});

  @override
  State<Call_history> createState() => _Call_historyState();
}

class _Call_historyState extends State<Call_history> {
  bool outgoing = false;
  final contacts = Contacts;
  bool loading = true;

  List<Call_History> call_history = [];



  Future<void> Call() async {
    final data = await UserData.CallHistory();
    if (!mounted) return;
    setState(() {
      call_history = data;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Call history",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Calls",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
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
                                  final Contact = contacts.firstWhere((data) {
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      call_history[index].started_at != null
                                          ? DateFormat('hh:mm a').format(
                                        call_history[index].started_at!.toDate(),
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
                  ],
                ),
              ),
            ),
    );
  }
}
