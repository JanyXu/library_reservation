import 'package:flutter/material.dart';import 'package:library_reservation/ui/pages/scan/scan_code_main.dart';import 'package:library_reservation/ui/pages/scan/scan_page.dart';import 'package:library_reservation/ui/pages/webview/setting_page.dart';import 'package:library_reservation/ui/widgets/code_dialogs.dart';class XBRouter {  // static final String initialRoute = SCMainPage.routeString;  static final String initialRoute = HomePage.routeString;  static final Map<String ,WidgetBuilder> routes = {    HomePage.routeString : (ctx) => HomePage(),   // ScanPage.routeString :(ctx) => ScanPage(),    SCCodeDialogWidget.routeString : (ctx) => SCCodeDialogWidget(),    SettingPage.routeString : (ctx) => SettingPage(),  };  static final RouteFactory generateRoute = (settings) {    return null;  };  static final RouteFactory unknownRoute = (settings) {    return null;  };}