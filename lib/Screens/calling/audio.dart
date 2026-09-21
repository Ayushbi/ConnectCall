import 'package:connectcall/Services/CallService.dart';
import 'package:connectcall/Services/FirebaseSignal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum Call { incoming, outgoing }

class Audio_calling extends StatefulWidget {
  final Call callType = Call.outgoing;

  const Audio_calling({super.key});

  @override
  State<Audio_calling> createState() => _Audio_callingState();
}

class _Audio_callingState extends State<Audio_calling> {
  bool ismute=false;
  bool speaker=false;
  bool isvideo=false;
  @override
  void initState() {
    super.initState();
    Callservice.RemoteMedia((Mediatype){
    print(Mediatype);
    }, (MediaStream){
print(MediaStream);

    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.05),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.call), Text("Calling...")],
            ),

            SizedBox(height: height * 0.02),

            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 70,
                child: Image.asset("assets/calling.png"),
              ),
            ),
            SizedBox(height: height * 0.02),

            Text(
              "Ayush",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: height * 0.3),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ismute?Colors.grey:Colors.white
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            ismute=!ismute;
                          });
                        },
                        icon: Icon(Icons.mic_off),
                      ),
                    ),
                    Text("Mute"),
                  ],
                ),

                Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: speaker?Colors.grey:Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            speaker=!speaker;
                          });
                        },
                        icon: Icon(Icons.volume_up),
                      ),
                    ),
                    Text("Speaker"),
                  ],
                ),

                Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isvideo?Colors.grey:Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isvideo=!isvideo;
                          });
                        },
                        icon: Icon(Icons.videocam),
                      ),
                    ),
                    Text("Video"),
                  ],
                ),
              ],
            ),

            Spacer(),

            widget.callType == Call.incoming
                ? Container(
                    width: 70,
                    height: 70,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.call),
                    ),
                  )
                : Container(
                    width: 70,
                    height: 70,
                    child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.call_end),
                    ),
                  ),

            SizedBox(height: height * 0.08),
          ],
        ),
      ),
    );
  }
}
