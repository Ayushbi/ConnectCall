import 'package:connectcall/Screens/calling/video.dart';
import 'package:connectcall/Services/FirebaseSignal.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';


class Callservice {
  //connection
  static RTCPeerConnection? connection;


  static Future<void> Connection(String id) async {
    connection = await createPeerConnection({});
    connection!.onIceCandidate = (call)
   async {
     await FirebaseSignal.candidate(id, call);
      print("ICE Candidate: $call");

    };
    FirebaseSignal.listen_candidate(id);

  }

  //media access
  static MediaStream? media;

  static Future<void> Media() async {
    media = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });
    for (var track in media!.getTracks()) {
      await connection!.addTrack(track, media!);
    }
  }

  //offer and answer
  static Future<void> offer() async {
    var data = await connection!.createOffer();
    await connection!.setLocalDescription(data);
    var id = await FirebaseSignal.signal(data);
    FirebaseSignal.getAnswer(id);
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
static Future<void>addcandidate(RTCIceCandidate cand)async{
await connection!.addCandidate(cand);
}
}
