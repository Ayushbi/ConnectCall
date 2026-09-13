
import 'package:connectcall/Screens/Contact/contact.dart';
import 'package:connectcall/Screens/history/calling_history.dart';
import 'package:connectcall/Screens/profile/Profile.dart';

import 'package:flutter/material.dart';

class Homecontent extends StatefulWidget {
  const Homecontent({super.key});

  @override
  State<Homecontent> createState() => _HomecontentState();
}

class _HomecontentState extends State<Homecontent> {
  bool search = false;
  bool outgoing = false;
TextEditingController Number=TextEditingController();


  Widget dialButton(String value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(80, 80),
      ),
      onPressed: () {
        setState(() {
          Number.text+=value;
        });
      },
      child: Text(value, style: TextStyle(fontSize: 25)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Connect call",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                search = !search;

              });
            },
            icon: Icon(Icons.search),
          ),
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
      body: SafeArea(
        child: Column(
          children: [
            if (search)
              TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                          MaterialPageRoute(builder: (context) => Contact()),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(),
                    title: Text("ayush"),
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
                              ),
                      ],
                    ),
                    trailing: Text("10:00AM"),
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
                        color: Theme.of(context).cardColor,
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
                                  controller: Number,
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
                                  if (Number.text.isNotEmpty) {
                                    Number.text = Number.text.substring(
                                      0,
                                      Number.text.length - 1,
                                    );
                                  }
                                });
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),

                          SizedBox(height: height*0.02,),
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
                              icon: const Icon(Icons.call, color: Colors.white),
                              onPressed: () {},
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
            SizedBox(height: height*0.01,)
          ],
        ),
      ),
    );
  }
}
