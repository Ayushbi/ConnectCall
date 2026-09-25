import 'package:connectcall/Screens/calling/audio.dart';
import 'package:connectcall/Screens/calling/video.dart';
import 'package:connectcall/Services/CallService.dart';
import 'package:flutter/material.dart';

class CallType extends StatefulWidget {
  const CallType({super.key});

  @override
  State<CallType> createState() => _CallTypeState();
}

class _CallTypeState extends State<CallType> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Future<void> Calling(String type) async {
    await Callservice.Connection();

    if (type == "audio") {
      await Callservice.Media(false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Audio_calling(callType: Call.incoming,)),
        (route) => false,
      );
    } else if (type == "video") {
      await Callservice.Media(true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Video_calling()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
