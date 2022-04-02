import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '设置',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
      ),
      home: MyHomePage(title: '设置'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        leading: Icon(CupertinoIcons.left_chevron),
      ),
      body:
          buildSetting(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Column buildSetting() {
    return Column(
      children: [
        buildTransplantCode(),
        buildScanRecord(),
        buildScanRemind()
      ],
    );
  }

  //乘车码
  Widget buildTransplantCode() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: ListTile(
        title: Text("乘车码"),
        dense: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '重庆城市通卡支付有限责任公司',
              style: TextStyle(color: Colors.black),
            ),
            Text('序列号：*********************',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: Icon(CupertinoIcons.right_chevron),
        onTap: (){

        },
      ),
    );

    ;
  }

  Widget buildScanRecord() {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text('扫码记录'),
        trailing: Icon(CupertinoIcons.right_chevron),
        onTap: (){

        },
      ),
    );
  }
  Widget buildScanRemind() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      color: Colors.white,
      child: ListTile(
        title: Text('扫码提示'),
        trailing:
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('中速'),
            Icon(CupertinoIcons.right_chevron),
          ],
        ),
        onTap: (){

        },
      ),
    );
  }
}
