import 'dart:async';
import 'package:connectcall/Screens/Contact/contact.dart';
import 'package:connectcall/Screens/Home/Homcontent.dart';
import 'package:connectcall/Utilities/Phone_normalize.dart';
import 'package:connectcall/Utilities/contact_name.dart';
import 'package:connectcall/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/Navigator/GlobalNav.dart';
import 'package:connectcall/Screens/Riverpod/call_provider.dart';
import 'package:connectcall/Screens/calling/audio.dart';
import 'package:connectcall/Services/CallService.dart';
import 'package:connectcall/Services/FirebaseSignal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class Controller {
  static StreamSubscription? callEndSubscription;

  static Future<void> Startcall({
    required String reciver_id,
    required String name,
  }) async {
    container.read(isconnected.notifier).state = false;

    await callEndSubscription?.cancel();
    callEndSubscription = null;
    final sender_id = FirebaseAuth.instance.currentUser!.uid;
    if (sender_id == reciver_id) {
      final context = navigation.currentContext!;
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Check your number"),
            content: const Text("You cannot call yourself."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }
    final callId = await Signaling.FirestoreDb(
      caller: sender_id,
      receiver: reciver_id,
    );

    await Callservice.MediaPermission();
    await Callservice.CreateConnection(callid: callId, isCaller: true);
    receiveAnswer(callId: callId);
    Controller.ListenForReceiverCandidates(callid: callId);
    await Callservice.AudioTrack();
    final Offer = await Callservice.CreateOffer();
    await Signaling().sendOffer(callId: callId, offer: Offer);
    navigation.currentState!.push(
      MaterialPageRoute(
        builder: (context) =>
            Audio_calling(callType: Call.outgoing, call_id: callId, name: name),
      ),
    );
  }

  static final Set<String> ongoing = {};

  static void receiveOffer() {
    Signaling().receiveOffer().listen((data) async {
      final Userid = FirebaseAuth.instance.currentUser!.uid;
      for (var doc in data.docs) {
        final data = doc.data();
        final offer = data['offer'];
        final caller = data['caller'];
        final receiver = data['receiver'];
        final status = data['status'];
        if (caller == null || caller == Userid) continue;
        if (receiver != Userid) continue;
        if (status != 'ringing') continue;
        if (offer != null) {
          final id = doc.id;
          if (ongoing.contains(id)) {
            continue;
          }

          ongoing.add(id);

          callEndSubscription = RemoteCallEnd(callId: id);

          await FirebaseFirestore.instance.collection('calls').doc(id).update({
            'offerReceived': true,
          });
          //phone number
          final phone = await Contactname(caller);
          final normalizePhone = NormalizePhone(phone);
          String callerName = phone;
          try {
            final contact = Contacts.firstWhere((data) {
              return data.phones.any((p) {
                return NormalizePhone(p.number) == normalizePhone;
              });
            });

            callerName = contact.displayName ?? phone;
          } catch (e) {}

          navigation.currentState?.push(
            MaterialPageRoute(
              builder: (context) => Audio_calling(
                callType: Call.incoming,
                offer: offer,
                call_id: id,
                name: callerName,
              ),
            ),
          );
        }
      }
    });
  }

  static Future<void> AcceptCall({
    required bool video,
    required String id,
    required Map<String, dynamic> offer,
    required String status,
  }) async {
    container.read(isconnected.notifier).state = false;
    await Signaling().CallStarted(id: id);
    final description = RTCSessionDescription(offer['sdp'], offer['type']);
    await Callservice.CreateConnection(callid: id, isCaller: false);
    Callservice.connection!.onTrack = (RTCTrackEvent event) {};
    await Callservice.MediaPermission();
    await Callservice.AudioTrack();
    await Callservice.connection!.setRemoteDescription(description);
    Controller.ListenForCallerCandidates(callid: id);
    final answer = await Callservice.CreateAnswer();
    await Callservice.connection!.setLocalDescription(answer);
    await Signaling().sendAnswer(callId: id, answer: answer, status: status);
  }

  static Future<void> RejectCall({
    required String callId,
    required String status,
  }) async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    await Signaling().Callstatus(id: callId, status: status, rejectedBy: id);
  }

  static Future<void> LocalEndcall({
    required String callId,
    required String status,
  }) async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    await Signaling().Callstatus(status: status, id: callId, endedBy: id);
    if (Callservice.audio != null) {
      for (var track in Callservice.audio!.getTracks()) {
        await track.stop();
      }
      await Callservice.audio!.dispose();
      Callservice.audio = null;
    }
    if (Callservice.connection != null) {
      await Callservice.connection!.close();
      Callservice.connection = null;
    }
  }

  static StreamSubscription RemoteCallEnd({required String callId}) {
    StreamSubscription? status;
    status = Signaling.ListenForCallEnd(callId: callId).listen((data) async {
      final status = data.data()?['status'];
      final endedBy = data.data()?["endedBy"];
      final rejectedBy = data.data()?["rejectedBy"];
      final currentUid = FirebaseAuth.instance.currentUser?.uid;

      if (status == "ended") {
        if (Callservice.audio != null) {
          for (var track in Callservice.audio!.getTracks()) {
            await track.stop();
          }
          await Callservice.audio!.dispose();
          Callservice.audio = null;
        }
        if (Callservice.connection != null) {
          await Callservice.connection!.close();
          await Callservice.connection!.dispose();
          Callservice.connection = null;
        }
        if (endedBy != null && endedBy != currentUid) {
          final context = navigation.currentContext;
          if (context != null) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                    navigation.currentState?.pop();
                  },
                  child: AlertDialog(
                    title: const Text("Call Ended"),
                    content: const Text("The other person has ended the call."),
                  ),
                );
              },
            );
          }
        }
      } else if (status == "rejected" &&
          rejectedBy != null &&
          rejectedBy != currentUid) {
        if (Callservice.audio != null) {
          for (var track in Callservice.audio!.getTracks()) {
            await track.stop();
          }
          await Callservice.audio!.dispose();
          Callservice.audio = null;
        }
        if (Callservice.connection != null) {
          await Callservice.connection!.close();
          await Callservice.connection!.dispose();
          Callservice.connection = null;
        }
        final context = navigation.currentContext;

        if (context != null) {
          navigation.currentState?.pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Other person is busy right now"),
            ),
          );
        }
      }
    });
    return status;
  }

  static void receiveAnswer({required String callId}) {
    Signaling().receiveAnswer(callId: callId).listen((snapshot) async {
      final data = snapshot.data();

      if (data == null) return;

      final answerData = data['answer'];

      if (answerData != null) {
        final answer = RTCSessionDescription(
          answerData['sdp'],
          answerData['type'],
        );

        await Callservice.connection!.setRemoteDescription(answer);
      }
    });
  }

  static StreamSubscription? candidateSubscription;

  static void ListenForCallerCandidates({required String callid}) {
    candidateSubscription = Signaling()
        .RecieveCandidates(callid: callid, CollectionName: "callerCandidates")
        .listen((data) async {
          for (var change in data.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data();

              if (data != null) {
                final iceCandidate = RTCIceCandidate(
                  data['candidate'],
                  data['sdpMid'],
                  data['sdpMLineIndex'],
                );
                await Callservice.connection!.addCandidate(iceCandidate);
              }
            }
          }
        });
  }

  static void ListenForReceiverCandidates({required String callid}) {
    candidateSubscription = Signaling()
        .RecieveCandidates(callid: callid, CollectionName: "receiverCandidates")
        .listen((data) async {
          for (var data in data.docChanges) {
            if (data.type == DocumentChangeType.added) {
              final candidateInfo = data.doc.data();

              if (candidateInfo != null) {
                final iceCandidate = RTCIceCandidate(
                  candidateInfo['candidate'],
                  candidateInfo['sdpMid'],
                  candidateInfo['sdpMLineIndex'],
                );
                await Callservice.connection!.addCandidate(iceCandidate);
              }
            }
          }
        });
  }
}
