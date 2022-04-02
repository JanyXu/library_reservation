import 'package:flutter/material.dart';import 'package:library_reservation/core/service/config/api_config.dart';import 'package:library_reservation/core/service/network/network.dart';class SCMainPage extends StatelessWidget {  const SCMainPage({Key? key}) : super(key: key);  @override  Widget build(BuildContext context) {    _getCategoryData();    return Scaffold(      appBar: AppBar(        title: Text('扫码助手'),      ),      body: Center(        child: Text('内容详情'),      ),    );  }  static Future<dynamic> _getCategoryData() async{    Map<String, dynamic> map = {};    final result = await HttpUtil.instance.get(      ApiConfig.category,      parameters: map    );    print(result);    return result;  }}