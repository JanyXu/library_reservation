import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_reservation/provide_model/scan_speed_provide_model.dart';
import 'package:library_reservation/setting/theme.dart';
import 'package:provider/provider.dart';

import 'core/router/router.dart';

void main() {
  runApp(MultiProvider(child: MyApp(), providers: [
    ChangeNotifierProvider(create: (ctx) => TestProviderModel())
  ]));
  if(Platform.isAndroid){
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        ///这是设置状态栏的图标和字体的颜色
        ///Brightness.light  一般都是显示为白色
        ///Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ScanTheme.lightTheme,
      darkTheme: ScanTheme.darkTheme,
      title: '扫码助手',
      initialRoute: XBRouter.initialRoute,
      routes: XBRouter.routes,
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
      body:
          Container(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
