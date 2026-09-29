import 'package:connectcall/Services/CallService.dart';
import 'package:connectcall/Services/FirebaseSignal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum call { incoming, outgoing }

class Video_calling extends StatefulWidget {
  final call type;

  const Video_calling({super.key, required this.type});

  @override
  State<Video_calling> createState() => _Video_callingState();
}

class _Video_callingState extends State<Video_calling> {
  MediaStream? Video;
  final RTCVideoRenderer video = RTCVideoRenderer();
  final RTCVideoRenderer LocalVideo = RTCVideoRenderer();
  bool accept = false;
  bool ismuted = false;
  bool speaker = false;
  double videoTop = 30;
  double videoRight = 22;

  @override
  void initState() {
    super.initState();
    setup();
  }
  Future<void> setup() async {
    await video.initialize();
    await LocalVideo.initialize();

    if (widget.type == call.outgoing) {
      await Outgoing();
    }
  }

  Future<void> accepted() async {
    var id = await FirebaseSignal.Accept_id();
    await Callservice.Connection(id);
    await Callservice.Media(true);
    LocalVideo.srcObject = Callservice.media;
    await FirebaseSignal.answer(id);
    await Incoming();
    setState(() {
      accept = true;
    });
  }


  Future<void> Outgoing() async {
    await Callservice.Connection();
    await Callservice.Media(true);
    LocalVideo.srcObject = Callservice.media;
    await Callservice.offer();
    await FirebaseSignal.getAnswer(Callservice.call_id!);
  }
  Future<void> Incoming() async {
    await Callservice.RemoteMedia("video", (stream) {
      setState(() {
        Video = stream;
        video.srcObject = Video;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: Container(child: RTCVideoView(video))),
            Positioned(
              top: videoTop,
              right: videoRight,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    videoTop += details.delta.dy;
                    videoRight -= details.delta.dx;
                  });
                },
                child: Container(
                  height: height * 0.2,
                  width: width * 0.3,
                  child: RTCVideoView(LocalVideo),
                ),
              ),
            ),
            Column(
              children: [
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (accept)
                      Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ismuted ? Colors.grey : Colors.white,
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  ismuted = !ismuted;
                                });
                              },
                              icon: Icon(Icons.mic_off),
                            ),
                          ),
                          Text("Mute"),
                        ],
                      ),
                    if (accept)
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
                              onPressed: () {
                                setState(() {
                                  speaker = !speaker;
                                });
                              },
                              icon: Icon(Icons.volume_up),
                            ),
                          ),
                          Text("Speaker"),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: height * 0.02),

                widget.type == call.incoming
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            backgroundColor: accept ? Colors.red : Colors.green,
                            onPressed: accepted,
                            child: Icon(accept ? Icons.call_end : Icons.call),
                          ),
                        ],
                      )
                    : FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.call_end),
                      ),
                SizedBox(height: height * 0.05),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
