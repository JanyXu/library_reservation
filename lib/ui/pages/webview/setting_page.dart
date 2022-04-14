import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_reservation/core/model/token_entity.dart';
import 'package:library_reservation/core/model/update_back_entity.dart';
import 'package:sm_crypto/sm_crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/service/config/api_config.dart';
import '../../../core/service/network/network.dart';
import '../../../core/service/utils/manager_utils.dart';
import '../../../utils/SM4_Util.dart';
import 'dart:convert' as convert;

main() => runApp(SettingPage());

class SettingPage extends StatelessWidget {
  static const String routeString = '/setting';

  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingHomePage();
  }
}

class SettingHomePage extends StatefulWidget {
  //const SettingHomePage({Key? key}) : super(key: key);

  @override
  State<SettingHomePage> createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  late WebViewController _controller;
  String token = '';
  String id = ManagerUtils.instance.getSeriesNumber()!;
  String url = '';

  //获取最新token
  Future<String> _getLatestToken() async {
    //Map<String, dynamic> map = {"codes": Common.dic_code};
    final result = await HttpUtil.instance.get(ApiConfig.getToken);
    //Map<String, dynamic> resultData = result.data['data'][0];
    if (result.data['code'] != 200) {
      Fluttertoast.showToast(msg: '终端无效');
      return '';
    }
    String localKey =
        ManagerUtils.instance.getSeriesNumberKey()!.substring(0, 16);
    String key = SM4.createHexKey(key: localKey);
    String enResult = SM4Utils.getDecryptData(result.data['data'], key);
    print(enResult);
    Map<String, dynamic> map_result = convert.jsonDecode(enResult);
    TokenEntity dataEntity = TokenEntity().fromJson(map_result);
    token = dataEntity.accessToken!;
    id = ManagerUtils.instance.getSeriesNumber()!;
    url = Utils.getSettingUrl()! + '?token=$token&id=$id';
    return enResult;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLatestToken(),
      builder: (BuildContext childContext, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if(token.isEmpty || id.isEmpty) {
            Fluttertoast.showToast(msg: 'token或终端未获取成功');
          }
          return initWebView(context);
        } else {
          return Container();
        }
      },
    );
  }

  /// 初始化webview
  initWebView(context) {
    return SafeArea(
      child: WebView(
        //是否允许js执行
        javascriptMode: JavascriptMode.unrestricted,
        //JS和Flutter通信的Channel
        javascriptChannels: <JavascriptChannel>[
          _goBrowserJavascriptChannel(),
          _goBackJavascriptChannel(),
          _serialJavascriptChannel(), //设置序列号
          _tokenJavascriptChannel(), //token过期
          _speedJavascriptChannel(), //设置速率
          _speedGetJavascriptChannel(),
          _encryptJavascriptChannel(), //加密
          _boundSerialJavascriptChannel(), //绑定序列号
          _copyJavascriptChannel(), //复制内容到剪切板
        ].toSet(),
        //路由委托（可以通过在此处拦截url实现JS调用Flutter部分）
        navigationDelegate: (NavigationRequest request) {
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        //手势监听
        gestureNavigationEnabled: true,
        initialUrl: url,
        //等待token请求完毕在链接后拼接最新token
        //加载进度
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }

  //js调用flutter-----通知前端token过期，或者返回首页
  JavascriptChannel _goBrowserJavascriptChannel() {
    return JavascriptChannel(name: 'goBrowser', onMessageReceived: goBrowser);
  }

  goBrowser(JavascriptMessage resp) async{
    //void _launchURL() async {
      if (!await launch(resp.message)) throw 'Could not launch ${resp.message}';
    //}
  }


  //js调用flutter-----通知前端token过期，或者返回首页
  JavascriptChannel _goBackJavascriptChannel() {
    return JavascriptChannel(name: 'goBack', onMessageReceived: goBack);
  }

  goBack(JavascriptMessage resp) {
    Navigator.of(context).pop();
  }

  //js调用flutter-----通知前端修改序列号并缓存
  JavascriptChannel _serialJavascriptChannel() {
    return JavascriptChannel(
        name: 'setSerialNum', onMessageReceived: setSerialNum);
  }

  //android,ios端设置序列号
  setSerialNum(JavascriptMessage resp) {
    Fluttertoast.showToast(msg: '序列号设置');
    // ManagerUtils.instance.saveSeriesNumber(number);
    // ManagerUtils.instance.saveSeriesNumberKey(number);
  }

  //js调用flutter-----通知前端token过去，重新请求接口获取最新token
  JavascriptChannel _tokenJavascriptChannel() {
    return JavascriptChannel(name: 'setToken', onMessageReceived: setToken);
  }

  //设置token
  setToken(JavascriptMessage resp) {
    Fluttertoast.showToast(msg: 'token已过期');
    Navigator.of(context).pop();
  }

  //js调用flutter-----通知前端修改扫描成功弹窗显示倒计时速度
  JavascriptChannel _speedJavascriptChannel() {

    return JavascriptChannel(name: 'setRate', onMessageReceived: setRate);
  }

  //设置及速率
  setRate(JavascriptMessage resp) {
    print('前端==================');
    int rate = int.parse(resp.message);
    Fluttertoast.showToast(msg: '速率设置成功');
    ManagerUtils.instance.saveRate(rate);
  }

  //js调用flutter-----通知前端修改扫描成功弹窗显示倒计时速度
  JavascriptChannel _speedGetJavascriptChannel() {
    return JavascriptChannel(name: 'getRate', onMessageReceived: getRate);
  }

  //设置及速率
  getRate(JavascriptMessage resp) {
    _controller
        .runJavascript('setRateResult("${ManagerUtils.instance.getRate().toString()}")')
        .then((result) {
      // You can handle JS result here.
    });
  }

  // //js调用flutter
  // JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //       name: 'Print', //这个那么是和js端约定的一个协议名，可以自定义
  //       onMessageReceived: (JavascriptMessage message) {
  //         print(message.message);  //js返回数据
  //         plugin.evalJavascript('想要发送的数据给后端');
  //       });
  // }

  //js调用flutter-----通知前端对参数进行加密操作
  JavascriptChannel _encryptJavascriptChannel() {
    return JavascriptChannel(name: 'setEncrypt', onMessageReceived: setEncrypt);
  }

  //调用SM4设置h5页面的加密操作
  setEncrypt(JavascriptMessage resp) {
    // String encryptResult = SM4Utils.getDecryptData(ebcEncryptData, key);
    // _flutterEncryptJsChannel(encryptResult);
  }

  //flutter调用js------设置加密
  void _flutterEncryptJsChannel(String encrypt) {
    if (_controller == null) return;
    _controller.runJavascript('setEncrypt($encrypt)').then((result) {
      // You can handle JS result here.
    });
  }

  //js调用flutter-----通知前端设置序列号
  JavascriptChannel _boundSerialJavascriptChannel() {
    return JavascriptChannel(
        name: 'boundSerial', onMessageReceived: boundSerial);
  }

  //1.1 数据获取-分类数据
  boundSerial(JavascriptMessage resp) async {
    //Fluttertoast.showToast(msg: resp.message);
    Map<String, dynamic> map = {
      "deviceId": ManagerUtils.instance.deviceId,
      // "deviceId":'12345',
      "terminalKey": resp.message
    };
    UpdateBackEntity backEntity = UpdateBackEntity();
    backEntity.success = 'false';
    Response res = await HttpUtil.instance.post(ApiConfig.activate, data: map);
    if (_controller != null && res.data['data'] != null) {
      ManagerUtils.instance.saveSeriesNumber(res.data['data']['terminalId']);
      ManagerUtils.instance.saveSeriesNumberKey(resp.message);
      backEntity.success = 'true';
      backEntity.token = res.data['data']['token'];
      backEntity.terminalId = res.data['data']['terminalId'];
      _controller
          .runJavascript('getBoundSerialResult($backEntity)')
          .then((result) {
        // You can handle JS result here.
      });
      // final result = await HttpUtil.instance.get(ApiConfig.getToken);
      // //Map<String, dynamic> resultData = result.data['data'][0];
      // if (result.data['code'] == 200) {
      //   String localKey =
      //   ManagerUtils.instance.getSeriesNumberKey()!.substring(0, 16);
      //   String key = SM4.createHexKey(key: localKey);
      //   String enResult = SM4Utils.getDecryptData(result.data['data'], key);
      //   Map<String, dynamic> mapResult = convert.jsonDecode(enResult);
      //   TokenEntity dataEntity = TokenEntity().fromJson(mapResult);
      //   backEntity.success = 'true';
      //   backEntity.token = dataEntity.accessToken!;
      //   backEntity.terminalId = terminalId;
      //   print('backMap ======== ${backEntity.toJson()}');
      //   _controller
      //       .runJavascript('getBoundSerialResult($backEntity)')
      //       .then((result) {
      //     // You can handle JS result here.
      //   });
      //   return;
      // }
    }
      _controller
          .runJavascript('getBoundSerialResult($backEntity)')
          .then((result) {
        // You can handle JS result here.
      });
  }

  //js调用flutter-----通知前端复制
  JavascriptChannel _copyJavascriptChannel() {
    return JavascriptChannel(name: 'copyResult', onMessageReceived: _copyResult);
  }

//复制内容
  _copyResult(JavascriptMessage resp) {
    String data = resp.message;
    if (data != null && data != '') {
      Clipboard.setData(ClipboardData(text: data));
      Fluttertoast.showToast(msg: '复制成功');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
