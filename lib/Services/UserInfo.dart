import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/Models/call_history.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<String?> Checkuser(String Phone) async {
    final data = await db
        .collection("Phone")
        .where("phone", isEqualTo: Phone)
        .limit(1)
        .get();
    if (data.docs.isNotEmpty) {
      final id = data.docs.first.id;
      return id;
    } else {
      return null;
    }
  }

  static Future<List<Call_History>> CallHistory() async {
    List<Call_History> history = [];
    final CurrentUser = FirebaseAuth.instance.currentUser?.uid;
    final outgoing = await db
        .collection("calls")
        .where("caller", isEqualTo: CurrentUser)
        .get();
    final incoming = await db
        .collection("calls")
        .where("receiver", isEqualTo: CurrentUser)
        .get();
    for (var doc in outgoing.docs) {
      final String userId = doc.data()["receiver"];
      final Timestamp? StartingTime = doc.data()["startedAt"];
      final Timestamp? EndingTime = doc.data()["endedAt"];
      final DateTime? startTime = StartingTime?.toDate();
      final DateTime? endTime = EndingTime?.toDate();
      int duration = 0;

      if (startTime != null && endTime != null) {
        duration = endTime.difference(startTime).inSeconds;
      }
      final call_outgoing = Call_History(
        Direction: "outgoing",
        Duration: duration.toString(),
        user_id: userId,
        started_at:  doc.data()["createdAt"]
      );

      history.add(call_outgoing);
    }
    for (var doc in incoming.docs) {
      final String userId = doc.data()["caller"];

      final Timestamp? StartingTime = doc.data()["startedAt"];
      final Timestamp? EndingTime = doc.data()["endedAt"];

      final Timestamp? createdAt = doc.data()["createdAt"];
      final DateTime? startTime = StartingTime?.toDate();
      final DateTime? endTime = EndingTime?.toDate();
      int duration = 0;

      if (startTime != null && endTime != null) {
        duration = endTime.difference(startTime).inSeconds;
      }
      final call_incoming = Call_History(
        Direction: "incoming",
        Duration: duration.toString(),
        user_id: userId,
        started_at: createdAt

      );
      history.add(call_incoming);
    }
    history.sort((a, b) {
      return b.started_at!.compareTo(a.started_at!);
    });
    return history;
  }
}
