import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_reservation/core/service/utils/manager_utils.dart';
import 'package:library_reservation/ui/widgets/dialog_listener.dart';
import 'package:library_reservation/utils/SM4_Util.dart';
import 'package:sm_crypto/sm_crypto.dart';
import '../../../core/model/scan_result_entity.dart';
import '../../../core/service/config/api_config.dart';
import '../../../core/service/network/network.dart';
import '../../widgets/dialog.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:convert' as convert;

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

class CodeScannerExample extends StatefulWidget {
  @override
  _CodeScannerExampleState createState() => _CodeScannerExampleState();
}

class _CodeScannerExampleState extends State<CodeScannerExample>
    implements OnDialogClickListener {
  late CodeScannerController controller;
  bool dialogFlag = false;
  String en = "";
  AudioPlayer advancedPlayer = AudioPlayer();
  String remindVoice = Utils.getScanCodeSound()!;
  String resultVoice = Utils.getTotalResultVoice('risky')!;
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
  }

  // _load() async {
  //   await controller.toggleLight();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                CodeScanner(
                  controller: controller,
                  isScanFrame: true,
                  frameWidth: 2,
                  scanFrameSize: Size(200, 200),
                  frameColor: Colors.green,
                ),
                // Container(
                //   margin: const EdgeInsets.only(bottom: 500),
                //   padding: const EdgeInsets.all(5.0),
                //   width: 300,
                //   decoration: BoxDecoration(
                //     color: Color(0xcc222222),
                //     border: Border.all(color: Color(0xcc222222)),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
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
                      stream: controller.scanDataStream,
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

                GestureDetector(
                  child: Container(

                    margin: EdgeInsets.only(left: 25,top: 20),
                    child: Image.asset('assets/images/scan_back.png'),
                  ),
                  onTap: (){
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown
                      //DeviceOrientation.landscapeRight,
                    ]).then((value) {
                      Future.delayed(Duration(milliseconds: 500),(){
                        Navigator.of(context).pop();
                      });
                    });
                  },
                ),
              ],
            ),)
          )
    );
  }

  Future<ScanResultEntity?> _getScanValue() async {
    // en = '6000001010644929.YKM11649330125V01.02.1156D755EB429E2AB7777CD43A01C2D4';
    if (!en.isEmpty) {
      print('源码======' + en);
      String localKey = ManagerUtils.instance.getSeriesNumberKey()!.substring(0,16);
      print('num======' + localKey);
      String key = SM4.createHexKey(key: localKey);
      print('👇 ECB Encrypt Mode:');
      String ebcEncryptData = SM4Utils.getEncryptptData(en, localKey);
      print('🔒 EBC EncryptptData:\n $ebcEncryptData');
      Map<String, dynamic> map = {"code": ebcEncryptData};
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
        resultEntity.certNo = ebcEncryptData;
        resultEntity.resultDicCode = 'other';
        //print('num======' + result.data['msg']+"------" + SM4Utils.getDecryptData(ebcEncryptData, key));
        resultVoice = Utils.getTotalResultVoice(resultEntity.resultDicCode)!;
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
