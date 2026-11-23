
import 'package:flutter/material.dart';

enum call { incoming, outgoing }

class Video_calling extends StatefulWidget {
  final call type;

  const Video_calling({super.key, required this.type});

  @override
  State<Video_calling> createState() => _Video_callingState();
}

class _Video_callingState extends State<Video_calling> {
  bool accept = false;
  bool ismuted = false;
  bool speaker = false;
  double videoTop = 30;
  double videoRight = 22;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black,
              ),
            ),

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
                  color: Colors.grey,
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
                      backgroundColor:
                      accept ? Colors.red : Colors.green,
                      onPressed: () {
                        if (!accept) {
                          setState(() {
                            accept = true;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        accept ? Icons.call_end : Icons.call,
                      ),
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
