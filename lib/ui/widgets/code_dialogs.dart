import 'dart:async';import 'package:flutter/material.dart';import 'package:flutter/services.dart';import 'package:library_reservation/core/service/config/color_config.dart';import 'package:library_reservation/core/service/utils/assets.dart';import 'package:library_reservation/core/service/utils/common.dart';import 'package:library_reservation/core/service/utils/manager_utils.dart';import 'code_dialogs_main.dart';import 'dart:math' as math;class SCCodeDialogWidget extends StatefulWidget {  static const String routeString = '/dialog';  const SCCodeDialogWidget({Key? key}) : super(key: key);  @override  State<SCCodeDialogWidget> createState() => _SCCodeDialogWidgetState();}class _SCCodeDialogWidgetState extends State<SCCodeDialogWidget> {  @override  void initState() {    // TODO: implement initState    super.initState();    String version = ManagerUtils.instance.getDicVersion(Common.dic_code)!;    String dicValue = ManagerUtils.instance.getDicValue('${Common.dic_code}$version')!;    print('dic_code-------------$dicValue');    SystemChrome.setPreferredOrientations(DeviceOrientation.values);  }  @override  Widget build(BuildContext context) {    return Scaffold(        backgroundColor: ColorConfig.colorB3000000,        body: Stack(          children:[            // Image.asset(Assets.ground,fit: BoxFit.cover,),            _buildContent(context)          ],        )    );  }  Widget buildAngleScanStack(Widget widget,bool landscape) {    //- math.pi / 4 向左旋转45度    return Transform.rotate(      angle: landscape? (-math.pi/2):0,      child: widget,    );  }  Widget _buildContent(BuildContext context) {    double width = MediaQuery        .of(context)        .size        .width;    double height = MediaQuery        .of(context)        .size        .height;    return Container(      width: double.infinity,      height: double.infinity,      child: Column(        mainAxisAlignment: MainAxisAlignment.center,        crossAxisAlignment: CrossAxisAlignment.center,        children: [          SCDialogsHeadWidget(),          // _buildUnKnowWidget(),          Container(            width: width > height ? 607 : 322,            height: width > height ? 257 : 574,            child: SCDialogsDataWidget(isHorizontal: width > height),          ),        ],      ),    );  }  Widget _buildUnKnowWidget() {    String text = '5bbc9c6d4a7b61ce531b2002cdb4d906d7c15644468cb62064aa94a6bea7c1d686cb0e028b6c88568a01022390558da2df6471e85a8704347817450b8f5d6dd5c32ffcf9c9b3b71f07128ca6efc71a57';    return Container(      width: 321,      height: 266,      child: Stack(        children: [          Image.asset(            Assets.bg_un_know,            width: 321,            height: 266,            fit: BoxFit.cover,          ),          Container(            width: double.infinity,            padding: EdgeInsets.all(25),            child: Column(              mainAxisAlignment: MainAxisAlignment.center,              children: [                SizedBox(height: 3),                Image.asset(                  Assets.mark_yellow,                ),                SizedBox(height: 14),                Text(text,                  style: TextStyleConfig.textFFFFFF_12.copyWith(height: 2),)              ],            ),          )        ],      ),    );  }  @override  Future<void> dispose() async {    SystemChrome.setPreferredOrientations([      DeviceOrientation.portraitUp,      DeviceOrientation.portraitDown      //DeviceOrientation.landscapeRight,    ]).then((value) {      super.dispose();    });  }}class SCDialogsHeadWidget extends StatefulWidget {  const SCDialogsHeadWidget({Key? key}) : super(key: key);  @override  _SCDialogsHeadWidgetState createState() => _SCDialogsHeadWidgetState();}class _SCDialogsHeadWidgetState extends State<SCDialogsHeadWidget> {  late Timer _timer;  int _start = 5;  @override  void initState() {    // TODO: implement initState    super.initState();    startTimer();  }  @override  Widget build(BuildContext context) {    double width = MediaQuery        .of(context)        .size        .width;    double height = MediaQuery        .of(context)        .size        .height;    return Container(      width: width > height ? 607 : 322,      height: 25,      child: Row(        mainAxisAlignment: MainAxisAlignment.end,        children: [          Text(            '$_start秒后关闭',            style: TextStyleConfig.textFFFFFF_12,          ),          SizedBox(width: 7.5,),          GestureDetector(            child: Image.asset(              Assets.close, width: 24, height: 24, fit: BoxFit.cover,),            onTap: () {              Navigator.of(context).pop();            },          ),          SizedBox(width: 8,)        ],      ),    );  }  void startTimer() {    const oneSec = const Duration(seconds: 1); //间隔1秒    _timer = new Timer.periodic(//每秒调用一次      oneSec,          (Timer timer) =>          setState(                () {              if (_start < 1) { //如果小于1则停止倒计时                timer.cancel();                // Navigator.of(context).pop();              } else {                _start = _start - 1; //自减一              }            },          ),    );  }  @override  void dispose() {    // TODO: implement dispose    super.dispose();    _timer.cancel();  }}