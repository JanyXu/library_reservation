import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
typedef OnError = void Function(Exception exception);

void main() {
  runApp(MaterialApp(home: ExampleApp()));
}

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  AudioPlayer advancedPlayer = AudioPlayer();
  String remindVoice = 'https://cdn-oss.bigdatacq.com/10000003/959405717506691072.mp3';
  String resultVoice = 'https://cdn-oss.bigdatacq.com/10000003/959405425574744064.mp3';
  bool flag = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    advancedPlayer.onPlayerCompletion.listen((event) {
      if(flag) {
        advancedPlayer.play(resultVoice);
      }
      flag = !flag;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: Text('ddd'),
          onPressed: () async {
            flag = true;
            play(remindVoice);
          },
        ),
      ),
    );
  }


 play(String voice) async {
    int result = await advancedPlayer.play(voice);
    if (result == 1) {
      print('play success');
    } else {
      print('play failed');
    }
    return result;
  }
}
