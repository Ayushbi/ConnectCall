import 'package:connectcall/Services/CallService.dart';
import 'package:connectcall/Services/FirebaseSignal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum Call { incoming, outgoing }

class Audio_calling extends StatefulWidget {
  final Call callType;

  const Audio_calling({super.key, required this.callType});

  @override
  State<Audio_calling> createState() => _Audio_callingState();
}

class _Audio_callingState extends State<Audio_calling> {
  MediaStream? Audio;
  bool ismute = false;
  bool speaker = false;
  bool isvideo = false;
  bool accepted = false;

  Future<void> mute(ismute) async {
    var track = Callservice.media!.getAudioTracks();
    for (var tracks in track) {
      tracks.enabled = ismute;
    }
  }

  Future<void> Outgoing_call() async {
    await Callservice.Connection();
    await Callservice.Media(false);
    await Callservice.offer();
    await FirebaseSignal.getAnswer(Callservice.call_id!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.callType == Call.outgoing) {
      Outgoing_call();
    }
  }
  Widget IncomingUI(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!accepted)
          Container(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () async {
                var id = await FirebaseSignal.Accept_id();

                await Callservice.Connection(id);
                await Callservice.Media(false);

                await Callservice.RemoteMedia("audio", (stream) {
                  Audio = stream;
                });

                await FirebaseSignal.answer(id);

                setState(() {
                  accepted = true;
                });
              },
              child: const Icon(Icons.call),
            ),
          ),

        if (!accepted)
          SizedBox(width: width * 0.3),

        Container(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () async {
              await Callservice.connection?.close();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.call_end),
          ),
        ),
      ],
    );
  }
  Widget OutgoingUI() {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () async {
        await Callservice.connection?.close();

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      child: const Icon(Icons.call_end),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                        color: ismute ? Colors.grey : Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            ismute = !ismute;
                          });
                          mute(ismute);
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
                        color: speaker ? Colors.grey : Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          setState(() {
                            speaker = !speaker;
                          });
                          await Helper.setSpeakerphoneOn(speaker);
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
                        color: isvideo ? Colors.grey : Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isvideo = !isvideo;
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
            widget.callType==Call.incoming?
                IncomingUI(width):
                OutgoingUI()

          ],
        ),
      ),
    );
  }
}

