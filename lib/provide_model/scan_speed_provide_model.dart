// import 'package:flutter/material.dart';
// //注：
// // 模型层添加变量
// // 生成getter 和 setter方法 （选中类名快捷键cmd+n)
// // set方法中添加监听
// class TestProviderModel extends ChangeNotifier{
//   int _scan_speed = 0;
//   bool _home_defult = true;
//   bool _dialog_show = false;
//
//   bool get dialog_show => _dialog_show;
//
//
//   bool get home_defult => _home_defult;
//
//   set home_defult(bool value) {
//     _home_defult = value;
//     notifyListeners();
//   }
//
//   int get scan_speed => _scan_speed;
//
//   set scan_speed(int value) {
//     _scan_speed = value;
//     notifyListeners();
//   }
//
//   Future set_dialog_show(bool bool) async{
//     _dialog_show = bool;
//     notifyListeners();
//   }
// }