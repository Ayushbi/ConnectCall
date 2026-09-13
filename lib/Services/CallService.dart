import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
class Callservice {
 static RTCPeerConnection ?Calling;
static MediaStream ?media;
 static Future<void>audio()async{
  media=await navigator.mediaDevices.getUserMedia(
    { 'audio': true,}
  );
}
 static Future<void> createConnection() async {
   Calling = await createPeerConnection({});
 }
 static Future<void> addAudio() async {
   final tracks = media!.getAudioTracks();

   for (var track in tracks) {
     await Calling!.addTrack(track, media!);
   }
 }


 static Future<void> createOffer() async {
   final offer = await Calling!.createOffer();

   await Calling!.setLocalDescription(offer);

}
