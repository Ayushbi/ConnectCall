import 'package:connectcall/Screens/calling/video.dart';
import 'package:connectcall/Services/FirebaseSignal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Callservice {
  //connection
  static RTCPeerConnection? connection;
  static String? call_id;

  static Future<void> Connection() async {
    var call = FirebaseSignal.db.collection("calls").doc();
    Callservice.call_id = call.id;
    connection = await createPeerConnection({});
    connection!.onIceCandidate = (call) async {
      await FirebaseSignal.candidate(call_id!, call);
      print("ICE Candidate: $call");
    };
    FirebaseSignal.listen_candidate(call_id!);
  }

  //media access
  static MediaStream? media;

  static Future<void> Media(bool type) async {
    media = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': type,
    });
    for (var track in media!.getTracks()) {
      await connection!.addTrack(track, media!);
    }
  }

  static Future<void> RemoteMedia(
    Function(String) MediaType,
    Function(MediaStream) media,
  ) async {
    connection!.onTrack = (event) {
      if (event.track.kind == "audio") {
        if (event.streams.isNotEmpty) {
          MediaType("audio");
        media(event.streams[0]);
        }
      }
      if (event.track.kind == "video") {
        if (event.streams.isNotEmpty) {
          MediaType("video");
          media(event.streams[0]);

        }
      }
    };
  }

  //offer and answer
  static Future<void> offer() async {
    var data = await connection!.createOffer();
    await connection!.setLocalDescription(data);
    var id = Callservice.call_id;
    await FirebaseSignal.signal(id!, data);
  }

  //reciver
  static Future<RTCSessionDescription> answer(
    RTCSessionDescription data,
  ) async {
    await connection!.setRemoteDescription(data);
    var answer = await connection!.createAnswer();
    await connection!.setLocalDescription(answer);
    return answer;
  }

  // caller receives answer from receiver
  static Future<void> getAnswer(RTCSessionDescription data) async {
    await connection!.setRemoteDescription(data);
  }

  // add candidate from other user
  static Future<void> addcandidate(RTCIceCandidate cand) async {
    await connection!.addCandidate(cand);
  }
}
