import 'package:connectcall/Screens/Riverpod/call_provider.dart';
import 'package:connectcall/Screens/calling/audio.dart';
import 'package:connectcall/Services/FirebaseSignal.dart';
import 'package:connectcall/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Callservice {
  static MediaStream? audio;
  static RTCPeerConnection? connection;

  static Future<MediaStream> MediaPermission() async {
    audio = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });
    return audio!;
  }

  static Future<void> CreateConnection({
    required String callid,
    required bool isCaller,
  }) async {
    connection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:global.stun.twilio.com:3478'},
        {'urls': 'stun:stun.cloudflare.com:3478'},
      ],
    });
    connection!.onIceCandidate = (candidates) async {
      await Signaling().SaveCandidates(
        callid: callid,
        candidates: candidates,
        CollectionName: isCaller ? "callerCandidates" : "receiverCandidates",
      );
    };
    connection!.onIceConnectionState = (state) async{
      print("ICE CONNECTION STATE: $state");
      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
          container.read(isconnected.notifier).state = true;
          if (isCaller) {
            await Signaling().CallStarted(id: callid);
          }
          break;

        case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
          container.read(isconnected.notifier).state = false;
          break;

        case RTCIceConnectionState.RTCIceConnectionStateFailed:
        case RTCIceConnectionState.RTCIceConnectionStateClosed:
          container.read(isconnected.notifier).state = false;
          break;

        default:
          break;
      }
    };
  }

  static Future<void> AudioTrack() async {
    await connection!.addTrack(audio!.getAudioTracks().first, audio!);
  }

  static void Mute(bool mute) {
    audio!.getAudioTracks().first.enabled = !mute;
  }

  static Future<void> Speaker(bool speaker) async {
    await Helper.setSpeakerphoneOn(speaker);
  }

  static Future<RTCSessionDescription> CreateOffer() async {
    RTCSessionDescription offer = await connection!.createOffer();
    await connection!.setLocalDescription(offer);
    return offer;
  }

  static Future<RTCSessionDescription> CreateAnswer() async {
    final answer = await connection!.createAnswer();

    return answer;
  }
}
