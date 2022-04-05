import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_reservation/provide_model/scan_speed_provide_model.dart';
import 'package:library_reservation/ui/pages/scan/dialog.dart';
import 'package:library_reservation/ui/widgets/code_dialogs.dart';
import 'package:library_reservation/ui/widgets/code_dialogs_main.dart';
import 'package:orientation/orientation.dart';
import 'package:provider/provider.dart';
import 'package:scan/scan.dart';

class ScanPage extends StatefulWidget {
  static const String routeString = 'ScanPage';

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  AudioPlayer advancedPlayer = AudioPlayer();
  String remindVoice =
      'https://cdn-oss.bigdatacq.com/10000003/959405717506691072.mp3';
  String resultVoice =
      'https://cdn-oss.bigdatacq.com/10000003/959405425574744064.mp3';
  bool flag = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    advancedPlayer.onPlayerCompletion.listen((event) {
      if (flag) {
        advancedPlayer.play(resultVoice);
      }
      flag = !flag;
    });
   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
   //  SystemChrome.setPreferredOrientations(
   //    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
   //  );
  }

  ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<TestProviderModel>(builder: (ctx, vm, child) {
            return buildScanStack(vm,context);
            // return OrientationBuilder(
            //     builder: (BuildContext context, Orientation orientation) {
            //   double width = MediaQuery.of(context).size.width;
            //   double height = MediaQuery.of(context).size.height;
            //   bool portraitFlag =
            //       orientation == Orientation.portrait ? true : false;
            //   print('dssssssssssssssssssss========$width');
            //   return Container(
            //     child: portraitFlag
            //         ? buildScanStack(vm, context)
            //         : buildScanStack(vm, context),
            //   );
            //   // return buildScanStack(vm, context);
            // });
          })),
    );
  }

  Widget buildAngleScanStack(BuildContext context, TestProviderModel vm) {
    //- math.pi / 4 向左旋转45度
    return Transform.rotate(
      angle: -90,
      child: buildScanStack(vm, context),
    );
  }

  Widget buildScanStack(TestProviderModel vm, BuildContext context) {
    return ScanView(
      controller: controller,
      scanAreaScale: .7,
      scanLineColor: Colors.green,
      onCapture: (data) {
        controller.pause();
        vm.home_defult = true;
        _openAlertDialog(context);
        play(remindVoice);
        flag = true;
        // Navigator.push(context, MaterialPageRoute(
        //   builder: (BuildContext context) {
        //     return Scaffold(
        //       appBar: AppBar(
        //         title: Text('scan result'),
        //       ),
        //       body: Center(
        //         child: Text(data),
        //       ),
        //     );
        //   },
        // )).then((value) {
        //   controller.resume();
        // });
      },
    );
  }

  Widget buildDialog(Widget widget) {
    //- math.pi / 4 向左旋转45度
    return Transform.rotate(
      angle: -0,
      child: widget,
    );
  }

  Future _openAlertDialog(BuildContext context) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false, //
// user must tap button!

      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return SCDialog();
        // buildDialog(Container(
        //   width: double.infinity,
        //   height: double.infinity,
        //   child: Center(child: SCDialogsDataWidget(isHorizontal:true))));
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
  void dispose() {
    // TODO: implement dispose
    advancedPlayer.dispose();
    super.dispose();
  }
}
