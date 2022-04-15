import 'dart:async';import 'package:amap_flutter_location/amap_flutter_location.dart';import 'package:amap_flutter_location/amap_location_option.dart';import 'package:flutter/cupertino.dart';import 'package:flutter/foundation.dart';import 'package:flutter/material.dart';import 'package:flutter/services.dart';import 'package:library_reservation/core/service/config/api_config.dart';import 'package:library_reservation/core/service/config/color_config.dart';import 'package:library_reservation/core/service/network/network.dart';import 'package:library_reservation/core/service/utils/manager_utils.dart';import 'package:library_reservation/provide_model/scan_speed_provide_model.dart';import 'package:library_reservation/ui/pages/scan/scan_page.dart';import 'package:library_reservation/ui/pages/webview/setting_page.dart';import 'package:library_reservation/ui/widgets/code_dialog/code_dialogs.dart';import 'package:library_reservation/ui/widgets/dialog_listener.dart';import 'package:permission_handler/permission_handler.dart';import 'dart:math' as math;import '../scan/code_scan.dart';import 'dart:io';import '../../widgets/dialog.dart';class HomePage extends StatefulWidget {  static const String routeString = '/';  const HomePage({Key? key}) : super(key: key);  @override  State<HomePage> createState() => _HomePageState();}class _HomePageState extends State<HomePage> {  @override  void initState() {    // TODO: implement initState    super.initState();    print('initState');    //OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);    SystemChrome.setPreferredOrientations([      DeviceOrientation.portraitUp,      DeviceOrientation.portraitDown      //DeviceOrientation.landscapeRight,    ]);    //SystemChrome.setPreferredOrientations(DeviceOrientation.values);  }  @override  void didChangeDependencies() {    // TODO: implement didChangeDependencies    super.didChangeDependencies();    print('didChangeDependencies');  }  @override  void didUpdateWidget(covariant HomePage oldWidget) {    // TODO: implement didUpdateWidget    super.didUpdateWidget(oldWidget);    print('didUpdateWidget');  }  @override  Widget build(BuildContext context) {    print('build-------Test');    // _getCategoryData();    return ClipRect(        child: Container(            decoration: BoxDecoration(                image: DecorationImage(                  image: AssetImage('assets/images/main_ground.png'),                  fit: BoxFit.cover,                )),            child: HomeDefaultPage()          //   OrientationBuilder(          //     builder: (BuildContext context, Orientation orientation) {          //   double width = MediaQuery.of(context).size.width;          //   double height = MediaQuery.of(context).size.height;          //   bool portraitFlag =          //       orientation == Orientation.landscape ? true : false;          //   print('dssssssssssssssssssss========$width');          //   return HomeDefaultPage();//: ScanPage(true);          //   // return buildScanStack(vm, context);          // });        ));  }  Widget buildAngleScanStack(Widget widget, bool landscape) {    //- math.pi / 4 向左旋转45度    return Transform.rotate(      angle: landscape ? (-math.pi / 2) : 0,      child: widget,    );  }  static Future<dynamic> _getCategoryData() async {    Map<String, dynamic> map = {};    final result =    await HttpUtil.instance.get(ApiConfig.category, parameters: map);    print(result);    return result;  }}class HomeDefaultPage extends StatefulWidget {  const HomeDefaultPage({    Key? key,  }) : super(key: key);  @override  State<HomeDefaultPage> createState() => _HomeDefaultPageState();}class _HomeDefaultPageState extends State<HomeDefaultPage>    implements OnDialogClickListener {  // ScanResult? _scanResult;  // Future<void> scan(BuildContext context) async {  //   _scanResult = await FlutterHmsScanKit.scan;  //  // _openAlertDialog(context);  //   //await Future.delayed(Duration(seconds: 2));  //   SystemChrome.setPreferredOrientations(DeviceOrientation.values).then((value) {  //     Navigator.of(context).pushNamed(SCCodeDialogWidget.routeString);  //   });  //   //  //  // }  bool dialogFlag = false;  Map<String, Object>? _locationResult;  double? longitude = 0.1;  double? latitude = 0.1;  List noticeArray = Utils.getNoticeText()!.split('\n');  StreamSubscription<Map<String, Object>>? _locationListener;  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();  @override  void initState() {    // TODO: implement initState    super.initState();    AMapFlutterLocation.updatePrivacyShow(true, true);    AMapFlutterLocation.updatePrivacyAgree(true);    AMapFlutterLocation.setApiKey(        "0f8e601301a78270292ca9f308228815", "ios ApiKey");    if (Platform.isAndroid) {      ///注册定位结果监听      _locationListener = _locationPlugin          .onLocationChanged()          .listen((Map<String, Object> result) {        //  setState(() {        _locationResult = result;        longitude = _locationResult!['longitude'] as double?;        latitude = _locationResult!['latitude'] as double?;        ManagerUtils.instance.longitude = longitude!;        ManagerUtils.instance.latitude = latitude!;        print('经纬度=========$longitude-----$result');// + longitude + latitude);        // });      });      requestCalendarPermission(Permission.location).then((value) {        if (value) {          _startLocation();        } else {          Navigator.of(context).pop();        }      });    }  }  @override  void dispose() {    // TODO: implement dispose    super.dispose();    ///移除定位监听    if (null != _locationListener) {      _locationListener?.cancel();    }    ///销毁定位    _locationPlugin.destroy();  }  ///开始定位  void _startLocation() {    ///开始定位之前设置定位参数    _setLocationOption();    _locationPlugin.startLocation();  }  ///停止定位  void _stopLocation() {    _locationPlugin.stopLocation();  }  ///设置定位参数  void _setLocationOption() {    AMapLocationOption locationOption = new AMapLocationOption();    ///是否单次定位    locationOption.onceLocation = false;    ///是否需要返回逆地理信息    locationOption.needAddress = true;    ///逆地理信息的语言类型    locationOption.geoLanguage = GeoLanguage.DEFAULT;    locationOption.desiredLocationAccuracyAuthorizationMode =        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";    ///设置Android端连续定位的定位间隔    locationOption.locationInterval = 2000;    ///设置Android端的定位模式<br>    ///可选值：<br>    ///<li>[AMapLocationMode.Battery_Saving]</li>    ///<li>[AMapLocationMode.Device_Sensors]</li>    ///<li>[AMapLocationMode.Hight_Accuracy]</li>    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;    ///设置iOS端的定位最小更新距离<br>    locationOption.distanceFilter = -1;    ///设置iOS端期望的定位精度    /// 可选值：<br>    /// <li>[DesiredAccuracy.Best] 最高精度</li>    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>    locationOption.desiredAccuracy = DesiredAccuracy.Best;    ///设置iOS端是否允许系统暂停定位    locationOption.pausesLocationUpdatesAutomatically = false;    try {      ///将定位参数设置给定位插件      _locationPlugin.setLocationOption(locationOption);    } catch( e) {      print('地图报错=======');    }  }  @override  Widget build(BuildContext context) {    return Scaffold(      extendBodyBehindAppBar: true,      backgroundColor: Colors.transparent, //把scaffold的背景色改成透明      appBar: AppBar(        elevation: 0,        centerTitle: true,        backgroundColor: Colors.transparent,        //把appbar的背景色改成透明        // elevation: 0,//appbar的阴影        title: Text("扫码助手", style: TextStyleConfig.textFFFFFF_14_bold),        actions: [          GestureDetector(            child: Container(              padding: EdgeInsets.symmetric(horizontal: 16),              child: Icon(                Icons.settings,                color: Colors.white,              ),            ),            onTap: () {              //跳转到设置              _starSettring(context);            },          )        ],      ),      body: Center(          child: Column(            // crossAxisAlignment: CrossAxisAlignment.stretch,            mainAxisSize: MainAxisSize.min,            children: [              Container(                  height: 470,                  width: 351,                  //margin: EdgeInsets.symmetric(horizontal: 12),                  padding: EdgeInsets.only(                    top: 152,                    bottom: 40,                  ),                  decoration: BoxDecoration(                      image: DecorationImage(                        image: AssetImage(                          'assets/images/main_middle_head_ground.png',                        ),                        fit: BoxFit.fill,                      )),                  child: Column(mainAxisSize: MainAxisSize.min, children: [                    Container(                      width: 189,                      height: 189,                      child: Image(                          image:                          AssetImage('assets/images/main_scan_ground.png')),                    ),                    SizedBox(height: 37,),                    // Consumer<TestProviderModel>(builder: (ctx, vm, child) {                    //   return                    MaterialButton(                      child: Image(                        image: AssetImage('assets/images/main_scan_button.png'),                      ),                      onPressed: () {                        _starScan(context);                        print('onPressed');                        //vm.home_defult = false;                        //scan(context);                        //_openAlertDialog(context);                        // print('dd3');                        // Navigator.push(context, MaterialPageRoute(builder: (_) {                        //   return ScanPage();                        // }));                      },                      //   );                      // }                    ),                  ])),              Container(                  width: 351,                  height: 131,                  //margin: EdgeInsets.symmetric(horizontal: 16),                  padding: EdgeInsets.only(top: 32,left: 25,right: 25),                  //margin: EdgeInsets.all(12),                  decoration: BoxDecoration(                      image: DecorationImage(                        image: AssetImage('assets/images/main_bottom_ground.png'),                        fit: BoxFit.fill,                      )),                  child: Column(                    crossAxisAlignment: CrossAxisAlignment.start,                    children: [                      Text(                        noticeArray.length > 0 ? noticeArray[0] : '',                        style: TextStyleConfig.textFFFFFF_14_bold,                      ),                      SizedBox(                        height: 12,                      ),                      Text(                        noticeArray.length > 1 ? noticeArray[1] : '',                        style: TextStyleConfig.textFFFFFF_12,                      ),                      Text(                        noticeArray.length > 2 ? noticeArray[2] : '',                        style: TextStyleConfig.textFFFFFF_12,                      ),                    ],                  ))            ],          )),      resizeToAvoidBottomInset: false,    );  }  void _starSettring(BuildContext context) {    if (ManagerUtils.instance.getSeriesNumber()!.length == 0) {      _openAlertDialog(context);      return;    }    Navigator.of(context).pushNamed(SettingPage.routeString);  }  void _starScan(BuildContext context) {    if (ManagerUtils.instance.getSeriesNumber()!.length == 0) {      _openAlertDialog(context);      return;    }    if(Platform.isIOS) {      Navigator.of(context).push(        MaterialPageRoute(builder: (context) => CodeScannerExample()),      );    } else {      requestCalendarPermission(Permission.camera).then((value) {        if (value) {          Navigator.of(context).push(            MaterialPageRoute(builder: (context) => CodeScannerExample()),          );        }      });    }  }  Future _openAlertDialog(BuildContext context) async {    return showDialog(      context: context,      barrierDismissible: false,      builder: (BuildContext context) {        return SCSerialDialog(this);      },    );  }  @override  void onCancel() {    // TODO: implement onCancel    dialogFlag = false;  }  @override  void onOk() {    // TODO: implement onOk  }  Future<bool> requestCalendarPermission(Permission permission) async {    //获取当前的权限    var status = await permission.status;    if (status == PermissionStatus.granted) {//已经授权      return true;    } else {      //未授权则发起一次申请      status = await permission.request();      if (status == PermissionStatus.granted) {        return true;      } else {        return false;      }    }  }}