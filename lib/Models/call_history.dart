import 'package:cloud_firestore/cloud_firestore.dart';

class Call_History {
  final String Direction;
  final String Duration;
  final String user_id;
  final Timestamp? started_at;

  Call_History({required this.Direction, required this.Duration,required this.user_id,required this.started_at});
}
