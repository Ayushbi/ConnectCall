import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/Controller/Call_Controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<String> FirestoreDb({
    required String caller,
    required String receiver,
  }) async {
    final id = db.collection("calls").doc();
    await id.set({
      'caller': caller,
      'receiver': receiver,
      'callType': 'audio',
      'status': 'ringing',
      'createdAt': FieldValue.serverTimestamp(),
      'startedAt': null,
      'endedAt': null,
      'offer': null,
      'answer': null,
      'endedBy': null,
      "rejectedBy": null,
      'offerReceived': false,
    });
    return id.id;
  }

  Future<void> sendOffer({
    required String callId,
    required RTCSessionDescription offer,
  }) async {
    await db.collection("calls").doc(callId).update({
      "offer": {"sdp": offer.sdp, "type": offer.type},
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> receiveOffer() {
    final id = FirebaseAuth.instance.currentUser!.uid;
    return db
        .collection("calls")
        .where("receiver", isEqualTo: id)
        .where("status", isEqualTo: "ringing")
        .snapshots();
  }

  Future<void> sendAnswer({
    required String callId,
    required RTCSessionDescription answer,
    required String status
  }) async {
    await db.collection("calls").doc(callId).update({
      "answer": {"sdp": answer.sdp, "type": answer.type},
      "status":status
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> receiveAnswer({
    required String callId,
  }) {
    return db.collection("calls").doc(callId).snapshots();
  }

  Future<void> SaveCandidates({
    required String callid,
    required RTCIceCandidate candidates,
    required String CollectionName,
  }) async {
    await db.collection("calls").doc(callid).collection(CollectionName).add({
      "candidate": candidates.candidate,
      "sdpMid": candidates.sdpMid,
      "sdpMLineIndex": candidates.sdpMLineIndex,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> RecieveCandidates({
    required String callid,
    required String CollectionName,
  }) {
    return db
        .collection("calls")
        .doc(callid)
        .collection(CollectionName)
        .snapshots();
  }

  Future<void> Callstatus({required String status, required String id,   String? endedBy, String? rejectedBy}) async {
    await FirebaseFirestore.instance.collection("calls").doc(id).update({
      'status': status,
      'endedAt': FieldValue.serverTimestamp(),
      if (endedBy != null) 'endedBy': endedBy,
      if (rejectedBy != null) 'rejectedBy': rejectedBy,

    });
  }

  Future<void> CallStarted({required String id}) async {
    await FirebaseFirestore.instance.collection("calls").doc(id).update({
      "status": "accepted",
      "startedAt": FieldValue.serverTimestamp(),
    });
  }


  static Stream ListenForCallEnd({required String callId}) {
    return db.collection('calls').doc(callId).snapshots();
  }
}
