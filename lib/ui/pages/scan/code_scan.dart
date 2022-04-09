import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:code_scanner/code_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_reservation/provide_model/scan_speed_provide_model.dart';
import 'package:library_reservation/ui/widgets/dialog_listener.dart';
import 'package:library_reservation/utils/SM4Util.dart';
import 'package:provider/provider.dart';
import 'package:sm_crypto/sm_crypto.dart';

import '../../../core/service/config/api_config.dart';
import '../../../core/service/network/network.dart';
import 'dialog.dart';

void main() {
  runApp(MaterialApp(home: CodeScannerHome()));
}

class CodeScannerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scanner example'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CodeScannerExample()),
            );
          },
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}

class CodeScannerExample extends StatefulWidget {

  @override
  _CodeScannerExampleState createState() => _CodeScannerExampleState();
}

class _CodeScannerExampleState extends State<CodeScannerExample> implements OnDialogClickListener{
  late CodeScannerController controller;
  bool dialogFlag = false;
  String en = "";
  AudioPlayer advancedPlayer = AudioPlayer();
  String remindVoice =
      'https://cdn-oss.bigdatacq.com/10000003/959405717506691072.mp3';
  String resultVoice =
      'https://cdn-oss.bigdatacq.com/10000003/959405425574744064.mp3';
  bool audioFlag = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    this.controller = CodeScannerController();
        advancedPlayer.onPlayerCompletion.listen((event) {
          print('声音=============$audioFlag');
      if (audioFlag) {
        advancedPlayer.play(resultVoice);
        audioFlag = !audioFlag;
      }

    });
    //controller.lightON();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('QR Scanner'),
        leading: IconButton(
          key: Key('closeButton'),
          icon: const Icon(CupertinoIcons.left_chevron,color: Colors.black,),
          onPressed: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown
              //DeviceOrientation.landscapeRight,
            ]).then((value) {
              Navigator.pop(context, '');
            });

          },
        ),
      ),
      body:
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CodeScanner(
            controller: controller,
            isScanFrame: true,
            frameWidth: 2,
            scanFrameSize: Size(200,200),
            frameColor: Colors.green,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 500),
            padding: const EdgeInsets.all(5.0),
            width: 300,
            decoration: BoxDecoration(
              color: Color(0xcc222222),
              border: Border.all(color: Color(0xcc222222)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Scan code',
              style: TextStyle(color: Colors.white, fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 350),
            padding: const EdgeInsets.all(5.0),
            width: 300,
            decoration: BoxDecoration(
              color: Color(0xcc222222),
              border: Border.all(color: Color(0xcc222222)),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            // Consumer<TestProviderModel>(builder: (ctx, vm, child) {
            //   return
                StreamBuilder<String>(
                stream: controller.scanDataStream,
                builder: (context1, snapshot) {
                  // if(snapshot.data!=null) {
                  //   print('test=======');
                  //   _openAlertDialog(context);
                  // }
                  // print('jjj');
                  if(snapshot.hasData && !dialogFlag) {
                    print('test=======${snapshot.data}');
                    //vm.set_dialog_show(true);
                    Future.delayed(Duration(seconds: 0), () async {
                      dialogFlag = true;
                      en = snapshot.data!;
                     // controller.stopScan();
                       _getScanValue();
                       _openAlertDialog(context);
                       play(remindVoice);
                      audioFlag = true;
                    });

                    // controller.stopScan();
                  } else {
                    //print('test=====false');
                  }
                  return Text(
                    'Scan Data: ',
                    style: TextStyle(color: Colors.green, fontSize: 17),
                    textAlign: TextAlign.center,
                  );
                },
            //   );
            // }
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 450),
            padding: const EdgeInsets.all(5.0),
            width: 300,
            decoration: BoxDecoration(
              color: Color(0xcc222222),
              border: Border.all(color: Color(0xcc222222)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder<String>(
                stream: controller.readDataStream,
                builder: (context, snapshot) {
                 // _openAlertDialog(context);
                  return (snapshot.hasData)
                      ?
                  Text(
                    'Read Data: ${snapshot.data}',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    textAlign: TextAlign.center,
                  )
                      : Text(
                    'Read Failure',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    textAlign: TextAlign.center,
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 600),
                child: FloatingActionButton(
                  heroTag: "hero1",
                  child: Icon(Icons.lightbulb_outline),
                  backgroundColor: Color(0xcc222222),
                  onPressed: () async {
                    await controller.toggleLight();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 600),
                child: FloatingActionButton(
                  heroTag: "hero2",
                  child: Icon(Icons.photo_library),
                  backgroundColor: Color(0xcc222222),
                  onPressed: () async {
                    await controller.readDataFromGallery();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



   Future<String> _getScanValue() async {
    if(!en.isEmpty) {
      print('源码======' + en);
      String key = SM4.createHexKey(key: 'DE9CF236992B4D77');
      print('👇 ECB Encrypt Mode:');
      String ebcEncryptData = SM4.encrypt(data: en, key: key);
      print('🔒 EBC EncryptptData:\n $ebcEncryptData');
      Map<String, dynamic> map = {
        "code": ebcEncryptData
      };
      final result =
      await HttpUtil.instance.post(ApiConfig.scan,data: map);
      // print('result=========$result');
      String str = json.encode(result.data);
      //DicDataEntity dataEntity = DicDataEntity().fromJson(result.data['data'][0]);
      print('解密信息========${str}');

      return str;
    }
    return "";
  }
  Future _openAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SCDialog();
      },
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
  @override
  void onCancel() {
    // TODO: implement onCancel
    print('hjjjkk');
    dialogFlag = false;
    // setState(() {
    //
    // });
    // Future.delayed(Duration(seconds: 2000), () async {
    //   Provider.of<TestProviderModel>(context,listen: false).set_dialog_show(false);
    // });
  }

  @override
  void onOk() {
    // TODO: implement onOk
  }
}
