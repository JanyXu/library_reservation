import 'dart:async';import 'package:flutter/material.dart';import 'package:library_reservation/ui/widgets/code_dialog/code_dialogs.dart';import 'package:library_reservation/ui/widgets/dialog_listener.dart';class SCDialog extends Dialog{  OnDialogClickListener callBack;  SCDialog(this.callBack);  // late Timer _timer;  // int _start = 5;  //  // void _startTimer(BuildContext context) {  //   const oneSec = const Duration(seconds: 1);//间隔1秒  //   _timer = new Timer.periodic(  //     oneSec, //每秒调用一次  //     (Timer timer){  //       if (_start < 1) { //如果小于1则停止倒计时  //         timer.cancel();  //         Navigator.of(context).pop();  //       } else {  //         _start = _start - 1;//自减一  //       }  //     }  //   );  // }  @override  Widget build(BuildContext context) {    // TODO: implement build    // _startTimer(context);    return SCCodeDialogWidget();  }}