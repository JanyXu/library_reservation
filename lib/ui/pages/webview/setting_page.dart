import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_reservation/core/model/token_entity.dart';
import 'package:sm_crypto/sm_crypto.dart';
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
  String url ='';
  //获取最新token
  Future<String> _getLatestToken() async {
    //Map<String, dynamic> map = {"codes": Common.dic_code};
    final result = await HttpUtil.instance.get(ApiConfig.getToken);
    //Map<String, dynamic> resultData = result.data['data'][0];
    if(result.data['code']!= 200) {
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
    print('token========' +
        dataEntity.accessToken! +
        "-----");
    token = dataEntity.accessToken!;
    id = ManagerUtils.instance.getSeriesNumber()!;
    url =  Utils.getSettingUrl()! + '?token=$token&id=$id';
    print('num======' + url);
    return enResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(CupertinoIcons.left_chevron),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text('设置'),
        ),
        body: FutureBuilder(
          future: _getLatestToken(),
          builder:
              (BuildContext childContext, AsyncSnapshot<dynamic> snapshot) {
            return initWebView(context);
          },
        )
        // initWebView(context),
        );
  }

  /// 初始化webview
  initWebView(context) {
    return WebView(
      //是否允许js执行
      javascriptMode: JavascriptMode.unrestricted,
      //JS和Flutter通信的Channel
      javascriptChannels: <JavascriptChannel>[
        _serialJavascriptChannel(),
        _tokenJavascriptChannel(),
        _speedJavascriptChannel(),
        _encryptJavascriptChannel(),
      ].toSet(),
      //路由委托（可以通过在此处拦截url实现JS调用Flutter部分）
      navigationDelegate: (NavigationRequest request) {
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      //手势监听
      gestureNavigationEnabled: true,
      initialUrl: Utils.getSettingUrl()! + '?token=$token&id=$id',
      //等待token请求完毕在链接后拼接最新token
      //加载进度
      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
      },
    );
  }
//调用SM4设置h5页面的加密操作
  goBack(JavascriptMessage resp) {
    // String encryptResult = SM4Utils.getDecryptData(ebcEncryptData, key);
    // _flutterEncryptJsChannel(encryptResult);
    Navigator.of(context).pop();
  }
  //android,ios端设置序列号
  setSerialNum(JavascriptMessage resp) {
    // ManagerUtils.instance.saveSeriesNumber(number);
    // ManagerUtils.instance.saveSeriesNumberKey(number);
  }

  //设置token
  setToken(JavascriptMessage resp) {}

  //设置及速率
  setSpeed(JavascriptMessage resp) {
    //ManagerUtils.instance.saveRate(rate);
  }

  //调用SM4设置h5页面的加密操作
  setEncrypt(JavascriptMessage resp) {
    // String encryptResult = SM4Utils.getDecryptData(ebcEncryptData, key);
    // _flutterEncryptJsChannel(encryptResult);

  }

  //js调用flutter-----通知前端token过期，或者返回首页
  JavascriptChannel _goBackJavascriptChannel() {
    return JavascriptChannel(
        name: 'goBack', onMessageReceived: setSerialNum);
  }
  //js调用flutter-----通知前端修改序列号并缓存
  JavascriptChannel _serialJavascriptChannel() {
    return JavascriptChannel(
        name: 'setSerialNum', onMessageReceived: setSerialNum);
  }
  //js调用flutter-----通知前端token过去，重新请求接口获取最新token
  JavascriptChannel _tokenJavascriptChannel() {
    return JavascriptChannel(name: 'setToken', onMessageReceived: setSerialNum);
  }
  //js调用flutter-----通知前端修改扫描成功弹窗显示倒计时速度
  JavascriptChannel _speedJavascriptChannel() {
    return JavascriptChannel(name: 'setSpeed', onMessageReceived: setSerialNum);
  }
  //js调用flutter-----通知前端对参数进行加密操作
  JavascriptChannel _encryptJavascriptChannel() {
    return JavascriptChannel(
        name: 'setEncrypt', onMessageReceived: setSerialNum);
  }
  //flutter调用js------设置加密
  void _flutterEncryptJsChannel(String encrypt) {
    if (_controller == null) return;
    _controller.runJavascript('setEncrypt($encrypt)').then((result) {
      // You can handle JS result here.
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
