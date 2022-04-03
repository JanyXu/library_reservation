import 'dart:async';import 'package:flutter/material.dart';import 'package:library_reservation/core/service/config/color_config.dart';import 'package:library_reservation/core/service/utils/assets.dart';import 'code_dialogs_main.dart';class SCCodeDialogWidget extends StatefulWidget {  static const String routeString = '/dialog';  const SCCodeDialogWidget({Key? key}) : super(key: key);  @override  State<SCCodeDialogWidget> createState() => _SCCodeDialogWidgetState();}class _SCCodeDialogWidgetState extends State<SCCodeDialogWidget> {  late Timer _timer;  int _start = 5;  @override  void initState() {    // TODO: implement initState    super.initState();    startTimer();  }  void startTimer() {    const oneSec = const Duration(seconds: 1);//间隔1秒    _timer = new Timer.periodic(oneSec, //每秒调用一次          (Timer timer) => setState(            () {          if (_start < 1) { //如果小于1则停止倒计时            timer.cancel();            Navigator.of(context).pop();          } else {            _start = _start - 1;//自减一          }        },      ),    );  }  @override  Widget build(BuildContext context) {    return Scaffold(      backgroundColor: ColorConfig.colorB3000000,      body: _buildContent(context),    );  }  Widget _buildContent(BuildContext context){    double width = MediaQuery.of(context).size.width;    double height = MediaQuery.of(context).size.height;    return Container(      width: double.infinity,      height: double.infinity,      child: Column(        mainAxisAlignment: MainAxisAlignment.center,        crossAxisAlignment: CrossAxisAlignment.center,        children: [          Container(            width: width > height ? 607:322,            height: 25,            child: Row(              mainAxisAlignment: MainAxisAlignment.end,              children: [                Text(                  '$_start秒后关闭',                  style: TextStyleConfig.textFFFFFF_12,                ),                SizedBox(width: 7.5,),                GestureDetector(                  child: Image.asset(Assets.close,width: 24,height: 24,fit: BoxFit.cover,),                  onTap: (){                    Navigator.of(context).pop();                  },                ),                SizedBox(width: 8,)              ],            ),          ),          // _buildUnKnowWidget(),          Container(            width: width > height ? 607:322,            height: width > height ? 257:574,            child: SCDialogsDataWidget(isHorizontal: width > height),          ),        ],      ),    );  }  Widget _buildUnKnowWidget(){    String text = '5bbc9c6d4a7b61ce531b2002cdb4d906d7c15644468cb62064aa94a6bea7c1d686cb0e028b6c88568a01022390558da2df6471e85a8704347817450b8f5d6dd5c32ffcf9c9b3b71f07128ca6efc71a57';    return Container(      width: 321,      height: 266,      child: Stack(        children: [          Image.asset(            Assets.bg_un_know,            width: 321,            height: 266,            fit: BoxFit.cover,          ),          Container(            width: double.infinity,            padding: EdgeInsets.all(25),            child: Column(              mainAxisAlignment: MainAxisAlignment.center,              children: [                SizedBox(height: 3),                Image.asset(                  Assets.mark_yellow,                ),                SizedBox(height: 14),                Text(text,style: TextStyleConfig.textFFFFFF_12,maxLines: 0,)              ],            ),          )        ],      ),    );  }  @override  void dispose() {    super.dispose();    _timer.cancel();  }}