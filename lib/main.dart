import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_reservation/core/service/utils/common.dart';
import 'package:library_reservation/core/service/utils/manager_utils.dart';
import 'package:library_reservation/provide_model/scan_speed_provide_model.dart';
import 'package:library_reservation/setting/theme.dart';
import 'package:library_reservation/ui/pages/scan/scan_code_main.dart';
import 'package:library_reservation/ui/widgets/dialog_listener.dart';
import 'package:provider/provider.dart';
import 'core/model/dic_data_entity.dart';
import 'dart:async';

import 'core/router/router.dart';
import 'core/service/config/api_config.dart';
import 'core/service/network/network.dart';

import 'package:library_reservation/core/model/dic_data_value_entity.dart';

import 'ui/pages/scan/dialog.dart';

void main() {
  // runApp(MultiProvider(child: MyApp(), providers: [
  //   ChangeNotifierProvider(create: (ctx) => TestProviderModel())
  // ]));
  runApp( MyApp());
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
  bool falg = true;
  @override
  Widget build(BuildContext context) {
    // _getCheckVersion().then((value) {
    //   String dicCode = value['dicCode'];
    //   String version = value['version'];
    //   // if (value['version'] == ManagerUtils.instance.getDicVersion(Common.dic_code)){
    //   //   // String key = '$dicCode$version';
    //   //   // String? dicValue = ManagerUtils.instance.getDicValue(key);
    //   //   print('读取缓存');
    //   //   return;
    //   // }
    //   // _getDicValue().then((value) {
    //   //   ManagerUtils.instance.saveDicValue('$dicCode$version', value.dicValue);
    //   //   ManagerUtils.instance.saveDicVersion(version, dicCode);
    //   //   print('读取接口数据');
    //   // });
    //
    // });


    initPlatformState().then((value) {
      if(null == value) return;
      if(falg) {
        falg = false;
        _getActivityValue();
      }
    });
    // if(falg) {
    //   _getActivityValue().then((value) {
    //     int terminalId= value['terminalId'];
    //     _getScanValue().then((value) {
    //
    //     });
    //   });
    // }

    //_getTest().then((value) => {});
    return MaterialApp(
      theme: ScanTheme.lightTheme,
      darkTheme: ScanTheme.darkTheme,
      title: '扫码助手',
      // initialRoute: XBRouter.initialRoute,
      // routes: XBRouter.routes,
       home: HomePage(),
      // home: MyHomePage(title: '扫码助手',),
    );
  }

  static Future<Map<String, dynamic>> _getCheckVersion() async {
    Map<String, dynamic> map = {
      "codes":Common.dic_code
    };
    final result =
    await HttpUtil.instance.get(ApiConfig.sysDicCheckVersion, parameters: map);
    return result.data['data'][0];
  }

  static Future<DicDataEntity> _getDicValue() async {
    Map<String, dynamic> map = {
      "codes":"ScanCodeAssistantExplain"
    };
    final result =
    await HttpUtil.instance.get(ApiConfig.sysDic, parameters: map);
    // print('result=========$result');
    DicDataEntity dataEntity = DicDataEntity().fromJson(result.data['data'][0]);
    // print('dicData========${dataEntity.dicValue}');

    return dataEntity;
  }

  static Future<String> _getScanValue() async {
    Map<String, dynamic> map = {
      "codes":"ScanCodeAssistantExplain"
    };
    final result =
    await HttpUtil.instance.post(ApiConfig.scan, data: map);
    // print('result=========$result');
    String str = json.encode(result.data);
    //DicDataEntity dataEntity = DicDataEntity().fromJson(result.data['data'][0]);
     print('解密信息========${str}');

    return str;
  }

  static Future<String> _getActivityValue() async {
    print('缓存获取设备信息=========');

    String deviceId = '';//ManagerUtils.instance.deviceMap['device'];
    if(Platform.isAndroid) {
      deviceId = ManagerUtils.instance.deviceMap!['device'];
    } else {
      deviceId = ManagerUtils.instance.deviceMap!['identifierForVendor'];
    }
    Map<String, dynamic> map = {

      "deviceId":ManagerUtils.instance.deviceMap==null?"123":ManagerUtils.instance.deviceMap!['device'],
      "terminalKey":"008ED075261C466E8D9B10739AF3B19B"
    };
    final result =
    await HttpUtil.instance.post(ApiConfig.activate, data: map);
    // print('result=========$result');
    String str = json.encode(result.data);
    //DicDataEntity dataEntity = DicDataEntity().fromJson(result.data['data'][0]);
    print('终端信息========${str}');

    return str;
  }
  static Future<String> _getTest() async {
    Map<String, dynamic> map = {
      "deviceId":"123",
      "terminalKey":"FBC73AD51F5B4FCAA99D9547AF3F51A2"
    };
    final result =
    await HttpUtil.instance.get("/v1/ykm/third-api/terminal/access-token");
    // print('result=========$result');
    String str = json.encode(result.data);
    //DicDataEntity dataEntity = DicDataEntity().fromJson(result.data['data'][0]);
    print('终端信息========${str}');

    return str;
  }



  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //设置设备ID
  Future<Map<String, dynamic>?> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        //print("设备号ios-------${_readIosDeviceInfo(await deviceInfoPlugin.iosInfo)}");
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    ManagerUtils.instance.deviceMap = deviceData;
    print("设备号null-------${ManagerUtils.instance.deviceMap}");
    return ManagerUtils.instance.deviceMap;

  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    print('name========${data.identifierForVendor}-------${data.utsname.machine}');
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}



class MyHomePage extends StatefulWidget{
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  implements OnDialogClickListener{
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};



  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    ManagerUtils.instance.deviceMap = deviceData;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    print('device ====== ${_deviceData['identifierForVendor']}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
          Center(
            child: Container(
              child: ElevatedButton(
                onPressed: (){
                  _openAlertDialog(context);
                },
                child: Text('dadsadsa'),
              ),
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _openAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SCSerialDialog(this);
      },
    );
  }
  @override
  void onCancel() {
    // TODO: implement onCancel
    print('hjjjkk');
    // setState(() {
    //
    // });
    // Future.delayed(Duration(seconds: 2000), () async {
    //   Provider.of<TestProviderModel>(context,listen: false).set_dialog_show(false);
    // });
  }

  @override
  void onOk() {
    // TODO: implement onOk
  }
}
