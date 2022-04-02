import 'package:flutter/material.dart';
import 'dart:ui';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          buildDetail('用户姓名',"姓名","",false),
          buildDetail('身份证号',"姓名","",false),
          buildDetail('手机号码',"姓名","",false),
          buildDetail('健康状态',"姓名","",true),
          buildDetail('核酸检测记录',"姓名","阴性cxxxxxxxxxxxxxxxxx",false),
          buildDetail('新冠疫苗',"姓名","",false),
          buildDetail('新冠疫苗加强针',"姓名","",false),
          buildDetail('行程核验',"新冠疫苗加强针ndjnsssssssssssssdnscdddddddddddsdcdscs","",false),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildDetail(String key,String value,String valueAdd,bool recordMark) {
    print("${window.physicalSize.width}");
    double widthTemp = window.physicalSize.width;
    return ListTile(
      title: Text(key),
      trailing: Container(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              valueAdd.isEmpty?"":valueAdd,style: TextStyle(color: Colors.green),),
            SizedBox(width: 10,),
            Expanded(
              child: Text(value,style: TextStyle(color: recordMark?Colors.green:Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,),
            )
            ,
          ],
        ),
      ),


    );
  }
}
