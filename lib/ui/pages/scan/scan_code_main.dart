import 'package:audioplayers/audioplayers.dart';import 'package:flutter/cupertino.dart';import 'package:flutter/foundation.dart';import 'package:flutter/material.dart';import 'package:flutter/services.dart';import 'package:images_picker/images_picker.dart';import 'package:library_reservation/core/service/config/api_config.dart';import 'package:library_reservation/core/service/network/network.dart';import 'package:library_reservation/provide_model/scan_speed_provide_model.dart';import 'package:library_reservation/ui/pages/scan/scan_page.dart';import 'package:library_reservation/ui/pages/webview/setting_page.dart';import 'package:library_reservation/ui/widgets/code_dialogs.dart';import 'package:orientation/orientation.dart';import 'package:provider/provider.dart';import 'dart:math' as math;import 'code_scan.dart';import 'dialog.dart';class HomePage extends StatefulWidget {  static const String routeString = '/';  const HomePage({Key? key}) : super(key: key);  @override  State<HomePage> createState() => _HomePageState();}class _HomePageState extends State<HomePage> {  @override  void initState() {    // TODO: implement initState    super.initState();    print('initState');    //OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);    SystemChrome.setPreferredOrientations([      DeviceOrientation.portraitUp,      DeviceOrientation.portraitDown      //DeviceOrientation.landscapeRight,    ]);    //SystemChrome.setPreferredOrientations(DeviceOrientation.values);  }  @override  void didChangeDependencies() {    // TODO: implement didChangeDependencies    super.didChangeDependencies();    print('didChangeDependencies');  }  @override  void didUpdateWidget(covariant HomePage oldWidget) {    // TODO: implement didUpdateWidget    super.didUpdateWidget(oldWidget);    print('didUpdateWidget');  }  @override  Widget build(BuildContext context) {    print('build-------Test');   // _getCategoryData();    return Container(      decoration: BoxDecoration(          image: DecorationImage(            image: AssetImage('assets/images/main_ground.png'),            fit: BoxFit.cover,          )),      child:  HomeDefaultPage()        //   OrientationBuilder(        //     builder: (BuildContext context, Orientation orientation) {        //   double width = MediaQuery.of(context).size.width;        //   double height = MediaQuery.of(context).size.height;        //   bool portraitFlag =        //       orientation == Orientation.landscape ? true : false;        //   print('dssssssssssssssssssss========$width');        //   return HomeDefaultPage();//: ScanPage(true);        //   // return buildScanStack(vm, context);        // });    );  }    Widget buildAngleScanStack(Widget widget,bool landscape) {    //- math.pi / 4 向左旋转45度    return Transform.rotate(      angle: landscape? (-math.pi/2):0,      child: widget,    );  }  static Future<dynamic> _getCategoryData() async {    Map<String, dynamic> map = {};    final result =    await HttpUtil.instance.get(ApiConfig.category, parameters: map);    print(result);    return result;  }}class HomeDefaultPage extends StatefulWidget {  const HomeDefaultPage({    Key? key,  }) : super(key: key);  @override  State<HomeDefaultPage> createState() => _HomeDefaultPageState();}class _HomeDefaultPageState extends State<HomeDefaultPage> {  // ScanResult? _scanResult;  // Future<void> scan(BuildContext context) async {  //   _scanResult = await FlutterHmsScanKit.scan;  //  // _openAlertDialog(context);  //   //await Future.delayed(Duration(seconds: 2));  //   SystemChrome.setPreferredOrientations(DeviceOrientation.values).then((value) {  //     Navigator.of(context).pushNamed(SCCodeDialogWidget.routeString);  //   });  //   //  //  // }  @override  Widget build(BuildContext context) {    return Scaffold(        extendBodyBehindAppBar: true,        backgroundColor: Colors.transparent, //把scaffold的背景色改成透明        appBar: AppBar(          elevation: 0,          centerTitle: true,          backgroundColor: Colors.transparent,          //把appbar的背景色改成透明          // elevation: 0,//appbar的阴影          title: Text("扫码助手",              style: Theme.of(context)                  .textTheme                  .headline1!                  .copyWith(color: Colors.white)),          actions: [            GestureDetector(              child: Container(                padding: EdgeInsets.symmetric(horizontal: 16),                child: Icon(                  Icons.settings,                  color: Colors.white,                ),              ),              onTap: () {                //跳转到设置                Navigator.of(context).pushNamed(SettingPage.routeString);              },            )          ],        ),        body: Center(            child: Column(              crossAxisAlignment: CrossAxisAlignment.stretch,              mainAxisSize: MainAxisSize.min,              children: [                Container(                  color: Colors.yellow,                  child: Image(                    image: AssetImage(                      'assets/images/main_head_ground.png',                    ),                    fit: BoxFit.scaleDown,                  ),                ),                Container(                    margin: EdgeInsets.symmetric(horizontal: 16),                    padding: EdgeInsets.symmetric(vertical: 20),                    decoration: BoxDecoration(                        color: Colors.white,                        image: DecorationImage(                          image: AssetImage(                            'assets/images/main_middle_ground.png',                          ),                          fit: BoxFit.fill,                        )),                    child: Column(mainAxisSize: MainAxisSize.min, children: [                      Image(                          image: AssetImage('assets/images/main_scan_ground.png')),                      SizedBox(                        height: 50,                      ),                      // Consumer<TestProviderModel>(builder: (ctx, vm, child) {                      //   return                          MaterialButton(                          child: Image(                            image: AssetImage('assets/images/main_scan_button.png'),                          ),                          onPressed: () {                            print('onPressed');                            //vm.home_defult = false;                            //scan(context);                            //_openAlertDialog(context);                            Navigator.of(context).push(                              MaterialPageRoute(builder: (context) => CodeScannerExample()),                            );                            // print('dd3');                            // Navigator.push(context, MaterialPageRoute(builder: (_) {                            //   return ScanPage();                            // }));                          },                      //   );                      // }                      ),                    ])),                Container(                  margin: EdgeInsets.symmetric(horizontal: 16),                  padding: EdgeInsets.all(16),                  decoration: BoxDecoration(                      color: Colors.red,                      image: DecorationImage(                        image: AssetImage('assets/images/main_bottom_ground.png'),                        fit: BoxFit.fill,                      )),                  child: Text.rich(                    TextSpan(children: [                      TextSpan(                          text: '注意事项：\n',                          style: Theme.of(context)                              .textTheme                              .headline1!                              .copyWith(color: Colors.white)),                      TextSpan(                          text: '1、扫码助手需要使用您的相机功能，请授权使用;\n2、可以识别的码：渝快码、电子社保码等。',                          style: Theme.of(context)                              .textTheme                              .headline1!                              .copyWith(color: Colors.white, fontSize: 14)),                    ]),                  ),                )              ],            )));  }}