import 'package:flutter/material.dart';import 'code_dialogs_main.dart';class SCCodeDialogWidget extends StatefulWidget {  static const String routeString = '/dialog';  const SCCodeDialogWidget({Key? key}) : super(key: key);  @override  State<SCCodeDialogWidget> createState() => _SCCodeDialogWidgetState();}class _SCCodeDialogWidgetState extends State<SCCodeDialogWidget> {  @override  Widget build(BuildContext context) {    return Scaffold(      appBar: AppBar(        title: Text('测试弹窗'),      ),      body: Container(        width: 322,        height: 574,        child: SCDialogsDataWidget(),      ),    );  }}