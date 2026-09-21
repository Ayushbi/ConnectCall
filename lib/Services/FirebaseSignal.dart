import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/Screens/calling/video.dart';
import 'package:connectcall/Services/CallService.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class FirebaseSignal {
  static final FirebaseFirestore db = FirebaseFirestore.instance;



  static Future<dynamic> signal(String id,RTCSessionDescription offer) async {
    var call=await db.collection("calls").doc(id);
    await call.set({
      "offer": {"type": offer.type, "sdp": offer.sdp},
      "createdAt": FieldValue.serverTimestamp(),
    });

  }



  static Future<dynamic> Get_id() async {
    var data = db.collection("calls").snapshots();
    data.listen((item) {
      for (var data in item.docChanges) {
        if (data.type == DocumentChangeType.added) {
          String id = data.doc.id;
          answer(id);
        }
      }
    });
  }

  static Future<void> answer(String id) async {
    var Id = id;
    var data = await db.collection("calls").doc(Id).get();
    var offer = data.data()?['offer'];
    var remoteOffer = RTCSessionDescription(offer['sdp'], offer['type']);
    var values = await Callservice.answer(remoteOffer);
    await db.collection("calls").doc(Id).update({
      "answer": {"type": values.type, "sdp": values.sdp},
    });
  }

  // user a
  static Future<void> getAnswer(String id) async {
    var data = db.collection("calls").doc(id).snapshots();
    data.listen((item) {
      var answer = item.data()?['answer'];
      if (answer != null) {
        var remoteOffer = RTCSessionDescription(answer['sdp'], answer['type']);
        Callservice.getAnswer(remoteOffer);
      }
    });
  }

  static Future<void> candidate(String id, RTCIceCandidate candidate) async {
    var update = await db
        .collection("calls")
        .doc(id)
        .collection("candidates")
        .add({
          "candidate": {
            "candidate": candidate.candidate,
            "sdpMid": candidate.sdpMid,
            "sdpMLineIndex": candidate.sdpMLineIndex,
          },
        });
  }

  // user 2 (candidate)
  static Future<void> listen_candidate(String id) async {
    var candidate = db
        .collection("calls")
        .doc(id)
        .collection("candidates")
        .snapshots();
    var data = candidate.listen((data) {
      for (var item in data.docChanges) {
        if (item.type == DocumentChangeType.added) {
          var candidate_data = item.doc.data()?['candidate'];
          var Rtc_candidate = RTCIceCandidate(
            candidate_data['candidate'],
            candidate_data['sdpMid'],
            candidate_data['sdpMLineIndex'],
          );
          Callservice.addcandidate(Rtc_candidate);
        }
      }
    });
  }
}
