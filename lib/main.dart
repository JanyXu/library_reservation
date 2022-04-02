import 'package:flutter/material.dart';
import 'package:library_reservation/ui/pages/scan_code_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '扫码助手',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SCMainPage(),
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
      body: Container(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
