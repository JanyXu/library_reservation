import 'package:flutter/material.dart';import 'code_dialogs_main.dart';class SCCodeDialogWidget extends StatefulWidget {  static const String routeString = '/dialog';  const SCCodeDialogWidget({Key? key}) : super(key: key);  @override  State<SCCodeDialogWidget> createState() => _SCCodeDialogWidgetState();}class _SCCodeDialogWidgetState extends State<SCCodeDialogWidget> {  @override  Widget build(BuildContext context) {    double width = MediaQuery.of(context).size.width;    double height = MediaQuery.of(context).size.height;    return Scaffold(      appBar: AppBar(        title: Text('测试弹窗'),      ),      body: Container(        width: width > height ? 607:322,        height: width > height ? 257:574,        child: SCDialogsDataWidget(isHorizontal: width > height),      ),    );  }}