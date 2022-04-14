import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_reservation/setting/theme.dart';
import 'package:library_reservation/ui/pages/home/home_page.dart';

import 'core/model/dic_data_entity.dart';
import 'core/service/config/api_config.dart';
import 'core/service/config/color_config.dart';
import 'core/service/network/network.dart';
import 'core/service/utils/common.dart';
import 'core/service/utils/manager_utils.dart';
import 'dart:convert' as convert;

class SCMyApp extends StatelessWidget {
  static const String routeString = '/';
  const SCMyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initPlatformState();
    return

      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/main_ground.png'),
              fit: BoxFit.cover,
            )),
        child: FutureBuilder<DicDataEntity>(
              future: _getDicValue(),
              builder: (ctx , snapshot) {
                if (!snapshot.hasData) return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text("扫码助手"),
                  ),
                  body: Container(),
                );
                return OrientationBuilder(
                    builder: (BuildContext context, Orientation orientation) {
                      return orientation == Orientation.portrait ? HomePage() : Container(child: Image.asset('assets/images/main_ground.png'));
                    }
                );
                   // child: HomePage());
                // return MyHomePage(title: '扫码助手',);
              }
          ),
      );
  }

  //判断版本号
  static Future<Map<String, dynamic>> _getCheckVersion() async {
    Map<String, dynamic> map = {
      "codes":Common.dic_code
    };
    final result =
    await HttpUtil.instance.get(ApiConfig.sysDicCheckVersion, parameters: map);
    Map<String, dynamic> resultData = result.data['data'][0];
    return resultData;
  }

  //获取字典数据
  static Future<DicDataEntity> _getDicValue() async {
    Map<String, dynamic> map = {
      "codes":Common.dic_code
    };

    final value = await _getCheckVersion();
    String dicCode = value['dicCode'];
    String version = value['version'];
    if (value['version'] == ManagerUtils.instance.getDicVersion(Common.dic_code)){
      String key = '$dicCode$version';
      String dicValue = ManagerUtils.instance.getDicValue(key)!;
      Map<String, dynamic> dic = convert.jsonDecode(dicValue);
      print('缓存数据====$dic');
      return DicDataEntity().fromJson(dic);
    }
    final result =
    await HttpUtil.instance.get(ApiConfig.sysDic, parameters: map);
    DicDataEntity dataEntity = DicDataEntity().fromJson(result.data['data'][0]);
    ManagerUtils.instance.saveDicValue('$dicCode$version', dataEntity.dicValue);
    ManagerUtils.instance.saveDicVersion(version, dicCode);
    return dataEntity;
  }


  //获取设备信息
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //设置设备ID
  Future<Map<String, dynamic>?> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        ManagerUtils.instance.deviceId = deviceData['androidId'];
      } else if (Platform.isIOS) {
        //print("设备号ios-------${_readIosDeviceInfo(await deviceInfoPlugin.iosInfo)}");
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        ManagerUtils.instance.deviceId = deviceData['identifierForVendor'];
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
