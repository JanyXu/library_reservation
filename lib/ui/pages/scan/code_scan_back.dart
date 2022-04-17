import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_reservation/core/service/utils/manager_utils.dart';
import 'package:library_reservation/ui/pages/scan/src/CodeScannerBack.dart';
import 'package:library_reservation/ui/widgets/dialog_listener.dart';
import 'package:library_reservation/utils/SM4_Util.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:sm_crypto/sm_crypto.dart';
import '../../../core/model/scan_result_entity.dart';
import '../../../core/service/config/api_config.dart';
import '../../../core/service/network/network.dart';
import '../../widgets/dialog.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:convert' as convert;

import 'code_scan.dart';
import 'code_scanner.dart';
void main() {
  runApp(MaterialApp(home: CodeScannerHome()));
}

class CodeScannerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('扫一扫'),
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            child: Icon(CupertinoIcons.left_chevron),
            onTap: (){
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown
                //DeviceOrientation.landscapeRight,
              ]).then((value) {
                Navigator.of(context).pop();
              });
            },
          ),
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

class CodeScannerExampleBack extends StatefulWidget {
  static const String routeString = 'CodeScannerExampleBack';
  @override
  _CodeScannerExampleState createState() => _CodeScannerExampleState();
}

class _CodeScannerExampleState extends State<CodeScannerExampleBack>
    implements OnDialogClickListener {
  //late CodeScannerController controller;
  late CodeScannerControllerBack controller_back;
  bool dialogFlag = false;
  String en = "";
  AudioPlayer advancedPlayer = AudioPlayer();
  String remindVoice = Utils.getScanCodeSound()!;
  String resultVoice = Utils.getTotalResultVoice('risky')!;
  bool audioFlag = false;
  bool turnAroundScan = false;
  var volume = 0.1;
  bool showScanner = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //this.controller = CodeScannerController();
    controller_back = CodeScannerControllerBack();
    PerfectVolumeControl.hideUI = true;
    advancedPlayer.onPlayerCompletion.listen((event) {
      print('声音=============$audioFlag');
      if (audioFlag) {
        PerfectVolumeControl.hideUI = true;
        PerfectVolumeControl.setVolume(1.0).then((value) {
          advancedPlayer.play(resultVoice);
          audioFlag = !audioFlag;
        });
        // advancedPlayer.setVolume(10000).then((value) {
        //   Fluttertoast.showToast(msg: '$value');
        //   advancedPlayer.play(resultVoice);
        //   audioFlag = !audioFlag;
        // });

      }
    });
    setState(() {
      Wakelock.enable();
      // You could also use Wakelock.toggle(on: true);
    });
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   print('打开灯====================');
    //   _load();
    // });
    //controller.lightON();
    // Future.delayed(Duration.zero, () => setState(() {
    //   _load();
    // }));
    delay();
  }

  // _load() async {
  //   await controller.toggleLight();
  // }

  @override
  void dispose() {
    super.dispose();
    controller_back.dispose();
    PerfectVolumeControl.setVolume(volume);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.blue,
          //   elevation: 0,
          //   centerTitle: true,
          //   title: Text('扫一扫'),
          //   leading:
          // ),
            body:
            WillPopScope(
              onWillPop: () async{
                return false;
              },
              child:
              Stack(
                //  alignment: AlignmentDirectional.center,
                children: [
                 //showScanner?
                 CodeScannerBack(
                    controller: controller_back,
                    isScanFrame: true,
                    frameWidth: 2,
                    scanFrameSize: Size(200, 200),
                    frameColor: Colors.green,
                  )
                   //   : Container(
                   // width: double.infinity,
                   // height: double.infinity,
                   // color: Colors.black,)
                  ,
                  Container(
                    // margin: const EdgeInsets.only(top: 350),
                    // padding: const EdgeInsets.all(5.0),
                    // width: 300,
                    // decoration: BoxDecoration(
                    //   color: Color(0xcc222222),
                    //   border: Border.all(color: Color(0xcc222222)),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                      child:
                      // Consumer<TestProviderModel>(builder: (ctx, vm, child) {
                      //   return
                      StreamBuilder<String>(
                        stream: controller_back.scanDataStream,
                        builder: (context1, snapshot) {
                          // if(snapshot.data!=null) {
                          //   print('test=======');
                          //   _openAlertDialog(context);
                          // }
                          // print('jjj');
                          if (snapshot.hasData && !dialogFlag) {
                            print('test=======${snapshot.data}');
                            //vm.set_dialog_show(true);
                            Future.delayed(Duration(seconds: 0), () async {
                              dialogFlag = true;
                              en = snapshot.data!;
                              // controller.stopScan();
                              _getScanValue().then((value) {
                                ScanResultEntity? scanResult= value;
                                if(scanResult!=null && scanResult.userName!=null) {
                                  if (scanResult.phone == '400'){
                                    dialogFlag = false;
                                    Fluttertoast.showToast(msg: scanResult.userName!);
                                    return;
                                  }
                                  play(remindVoice);
                                  audioFlag = true;
                                  _openAlertDialog(context, value!);
                                } else {
                                  // controller.prepareSetMethodHandler();
                                  // controller.startScan();
                                  dialogFlag = false;
                                  Fluttertoast.showToast(msg: '网络错误');
                                }
                              });
                              ;

                            });

                            // controller.stopScan();
                          } else {
                            //print('test=====false');
                          }
                          return Text(
                            '',
                            style: TextStyle(color: Colors.green, fontSize: 17),
                            textAlign: TextAlign.center,
                          );
                        },
                        //   );
                        // }
                      )),
                  // Center(
                  //   child: MaterialButton(
                  //       child: Text('dddddddddd'),
                  //       onPressed: (){
                  //         // controller.lightOFF().then((value) {
                  //         // setState(() {
                  //         //   turnAroundScan = !turnAroundScan;
                  //         // });
                  //         Navigator.popAndPushNamed(context, CodeScannerExample.routeString);
                  //         //delay();
                  //         //Navigator.pop(context,false);
                  //         //跳转并关闭当前页面
                  //         // Navigator.pushAndRemoveUntil(
                  //         //   context,
                  //         //   new MaterialPageRoute(builder: (context) => new CodeScannerExample()),
                  //         //       (route) => route == null,
                  //         // );
                  //         //Navigator.of(context).pop();
                  //         // });
                  //       }),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 450),
                  //   padding: const EdgeInsets.all(5.0),
                  //   width: 300,
                  //   decoration: BoxDecoration(
                  //     color: Color(0xcc222222),
                  //     border: Border.all(color: Color(0xcc222222)),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: StreamBuilder<String>(
                  //       stream: controller.readDataStream,
                  //       builder: (context, snapshot) {
                  //         // _openAlertDialog(context);
                  //         return (snapshot.hasData)
                  //             ? Text(
                  //                 'Read Data: ${snapshot.data}',
                  //                 style: TextStyle(color: Colors.white, fontSize: 17),
                  //                 textAlign: TextAlign.center,
                  //               )
                  //             : Text(
                  //                 'Read Failure',
                  //                 style: TextStyle(color: Colors.white, fontSize: 17),
                  //                 textAlign: TextAlign.center,
                  //               );
                  //       }),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.only(top: 600),
                  //       child: FloatingActionButton(
                  //         heroTag: "hero1",
                  //         child: Icon(Icons.lightbulb_outline),
                  //         backgroundColor: Color(0xcc222222),
                  //         onPressed: () async {
                  //           await controller.toggleLight();
                  //         },
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.only(top: 600),
                  //       child: FloatingActionButton(
                  //         heroTag: "hero2",
                  //         child: Icon(Icons.photo_library),
                  //         backgroundColor: Color(0xcc222222),
                  //         onPressed: () async {
                  //           await controller.readDataFromGallery();
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(left: 25, top: 20),
                          child: Image.asset('assets/images/scan_back.png'),
                        ),
                        onTap: () {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown
                            //DeviceOrientation.landscapeRight,
                          ]).then((value) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              Navigator.of(context).pop();
                            });
                          });
                        },
                      ),
                      // GestureDetector(
                      //   child: Icon(
                      //       CupertinoIcons.camera_rotate,color: Colors.white,),
                      //   onTap: () {
                      //     Navigator.popAndPushNamed(
                      //         context, CodeScannerExample.routeString);
                      //   },
                      // ),
                    ],
                  )

                ],
              ),)
        )
    );
  }
  Future delay() async {
    await new Future.delayed(new Duration(milliseconds: 500), () {
      showScanner = true;
      setState(() {

      });
      // Navigator.popAndPushNamed(
      //     context, CodeScannerExample.routeString);
    });
  }
  Future<ScanResultEntity?> _getScanValue() async {
    // en = '6000001010644929.YKM11649330125V01.02.1156D755EB429E2AB7777CD43A01C2D4';
    if (!en.isEmpty) {
      print('原生加密测试======' + en);
      String localKey = ManagerUtils.instance.getSeriesNumberKey()!.substring(0,16);
      print('原生加密测试======' + localKey);
      String key = SM4.createHexKey(key: localKey);
      print('👇 ECB Encrypt Mode:');
      String? resultEN = await SM4Utils.getEncryptDataFromPlatform(en,
          localKey);
      print('原生加密测试结果：=======' +resultEN!);

      String ebcEncryptData = SM4Utils.getEncryptptData(en, localKey);
      print('🔒 EBC EncryptptData:\n $ebcEncryptData');
      Map<String, dynamic> map = {"code": resultEN};
      print('原生加密测试结果：=======${map}');
      final result = await HttpUtil.instance.post(ApiConfig.scan, data: map);

      if(result.statusCode !=200) {
        return ScanResultEntity();
      }
      if(result.data == null) {
        return ScanResultEntity();
      }

      if (result.data['code'].toString() == '400' ||result.data['code'].toString() == '10001' || result.data['code'].toString() == '10009'){

        ScanResultEntity resultEntity = ScanResultEntity();
        resultEntity.userName = result.data['msg'];
        resultEntity.certNo = en;
        resultEntity.resultDicCode = 'other';
        resultEntity.phone = result.data['code'].toString();
        //print('num======' + result.data['msg']+"------" + SM4Utils.getDecryptData(ebcEncryptData, key));
        resultVoice = Utils.getTotalResultVoice(resultEntity.resultDicCode)!;
        //Fluttertoast.showToast(msg: resultEntity.userName!);
        return resultEntity;
      }
      if(result.data['data'] == null) {
        ScanResultEntity resultEntity = ScanResultEntity();
        resultEntity.userName = result.data['msg'];
        resultEntity.certNo = ebcEncryptData;
        resultEntity.resultDicCode = 'other';
        //print('num======' + result.data['msg']+"------" + SM4Utils.getDecryptData(ebcEncryptData, key));
        resultVoice = Utils.getTotalResultVoice(resultEntity.resultDicCode)!;
        return resultEntity;
      }
      String enResult = SM4Utils.getDecryptData(result.data['data'], key);

      Map<String, dynamic> user = convert.jsonDecode(enResult);
      final data = ScanResultEntity().fromJson(user);
      resultVoice = Utils.getTotalResultVoice(data.resultDicCode)!;
      print('enResult=========${enResult}');
      // //String str = json.encode(result.data);
      // //DicDataEntity dataEntity = DicDataEntity().fromJson(result.data['data'][0]);
      // print('解密信息========${SM4Utils.getDecryptData(result.data['data'], key)}');

      return data;
    }

    return ScanResultEntity();
  }

  Future _openAlertDialog(BuildContext context,ScanResultEntity scanResultEntity) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SCDialog(this,scanResultEntity);
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
    // controller.prepareSetMethodHandler();
    // controller.startScan();
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
