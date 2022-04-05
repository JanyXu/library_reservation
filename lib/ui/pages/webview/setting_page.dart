import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_reservation/setting/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  const SettingHomePage({Key? key}) : super(key: key);

  @override
  State<SettingHomePage> createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  late WebViewController _controller;

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
      body: initWebView(context),
    );
  }

  /// 初始化webview
  initWebView(context) {
    return WebView(
      //是否允许js执行
      javascriptMode: JavascriptMode.unrestricted,
      //JS和Flutter通信的Channel
      javascriptChannels: <JavascriptChannel>{
        _toasterJavascriptChannel(context)
      },
      //路由委托（可以通过在此处拦截url实现JS调用Flutter部分）
      navigationDelegate: (NavigationRequest request) {
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      //手势监听
      gestureNavigationEnabled: true,
      initialUrl: "https://www.callmysoft.com/",
      //加载进度
      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
      },
    );
  }

  setSerialNum(JavascriptMessage resp) {}

  //js调用flutter-----通知前端修改序列号并缓存
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'setSerialNum', onMessageReceived: setSerialNum);
  }

  //flutter调用js------设置加密
  void _toasterFlutterChannel(String encryption) {
    if (_controller == null) return;
    _controller.runJavascript('setEncryption($encryption)').then((result) {
      // You can handle JS result here.
    });
  }
}
