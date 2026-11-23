import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/Controller/Call_Controller.dart';
import 'package:connectcall/Screens/Riverpod/call_provider.dart';
import 'package:connectcall/Services/CallService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Call { incoming, outgoing }

class Audio_calling extends ConsumerStatefulWidget {
  final Call callType;
  final String name;
  final call_id;
  final Map<String, dynamic>? offer;

  const Audio_calling({
    super.key,
    required this.callType,
    required this.call_id,
    this.offer,
    required this.name,
  });

  @override
  ConsumerState<Audio_calling> createState() => _Audio_callingState();
}

class _Audio_callingState extends ConsumerState<Audio_calling> {
  final Audio = AudioPlayer();
  final AudioPlayer connectingAudio = AudioPlayer();
  final AudioPlayer connectedAudio = AudioPlayer();

  Future<void> Ringtone() async {
    await Audio.setReleaseMode(ReleaseMode.loop);
    await Audio.play(AssetSource('Incoming_audio.mp3'));
  }

  Future<void> Connecting() async {
    await connectingAudio.setReleaseMode(ReleaseMode.loop);
    await connectingAudio.setVolume(0.1);
    await connectingAudio.play(AssetSource('connecting.mp3'));
  }

  Future<void> Connected() async {
    await connectedAudio.setVolume(0.1);
    await connectedAudio.setReleaseMode(ReleaseMode.loop);
    await connectedAudio.play(AssetSource('connected.wav'));
  }
  Future<void> StopOutgoingSounds() async {
    await connectingAudio.stop();
    await connectedAudio.stop();
  }

  void ListenForOfferReceived() {
    FirebaseFirestore.instance
        .collection('calls')
        .doc(widget.call_id)
        .snapshots()
        .listen((snapshot) async {
          if (!snapshot.exists) return;

          final data = snapshot.data();

          if (data?['offerReceived'] == true &&
              data?['status'] == 'ringing') {
            await connectingAudio.stop();
            await Connected();
          }

          if (data?['status'] == 'ended' ||
              data?['status'] == 'cancelled') {
            await StopOutgoingSounds();
          }
          if (data?['status'] == 'accepted') {
            await StopOutgoingSounds();
          }
        });
  }

  Timer? time;
  int callSeconds = 0;
  bool ismute = false;
  bool speaker = false;
  bool isvideo = false;
  bool accepted = false;
  StreamSubscription? remoteCallSubscription;

  @override
  void initState() {
    super.initState();
    remoteCallSubscription = Controller.RemoteCallEnd(callId: widget.call_id);
    if (widget.callType == Call.incoming) {
      Ringtone();
    }
    if (widget.callType == Call.outgoing) {
      Connecting();
      ListenForOfferReceived();
    }

    Callservice.Speaker(false);
  }

  @override
  void dispose() {
    time?.cancel();

    remoteCallSubscription?.cancel();
    Audio.stop();
    connectedAudio.stop();
    connectingAudio.stop();
    super.dispose();
  }

  void callDuration() {
    if (time != null && time!.isActive) return;
    time = Timer.periodic(Duration(seconds: 1), (sec) {
      if (!mounted) {
        sec.cancel();
        return;
      }
      setState(() {
        callSeconds++;
      });
    });
  }

  String FormatTimer() {
    final minutes = callSeconds ~/ 60;
    final second = callSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:"
        "${second.toString().padLeft(2, '0')}";
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
                await Controller.AcceptCall(
                  video: false,
                  id: widget.call_id,
                  offer: widget.offer!,
                  status: "accepted",
                );
                await Audio.stop();

                if (!mounted) return;
                setState(() {
                  accepted = true;
                });
              },
              child: const Icon(Icons.call),
            ),
          ),

        if (!accepted) SizedBox(width: width * 0.3),

        Container(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () async {
              if (accepted) {
                await Controller.LocalEndcall(
                  callId: widget.call_id,
                  status: "ended",
                );
                await StopOutgoingSounds();
              } else {
                await Controller.RejectCall(
                  callId: widget.call_id,
                  status: "rejected",
                );
                await StopOutgoingSounds();
              }

              if (!mounted) return;
              Navigator.pop(context);
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
        await StopOutgoingSounds();
        await Controller.LocalEndcall(callId: widget.call_id, status: "ended");
        if (!mounted) return;
        Navigator.pop(context);
      },
      child: const Icon(Icons.call_end),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(isconnected);
    ref.listen(isconnected, (previous, next) {
      if (next == true) {
        callDuration();
      }
    });
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call),
                  Text(
                    connected
                        ? "Connected"
                        : widget.callType == Call.incoming
                        ? "Incoming Calling..."
                        : "Calling...",
                  ),
                  SizedBox(width: width * 0.03),
                  if (connected)
                    Text(
                      FormatTimer(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
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
                widget.name,
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
                            Callservice.Mute(ismute);
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
                            await Callservice.Speaker(speaker);
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text('not available right now'),
                              ),
                            );
                          },
                          icon: Icon(Icons.videocam),
                        ),
                      ),
                      Text("Video"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),

              widget.callType == Call.incoming
                  ? IncomingUI(width)
                  : OutgoingUI(),
            ],
          ),
        ),
      ),
    );
  }
}
