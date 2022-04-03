import 'package:flutter/material.dart';

class ScanTheme{
  static const double normalFontSize = 15;
  static const double titleFontSize = 20;
  static const double subTitleFontSize = 18;

  static final Color lightThemeTextColor = Colors.black;
  static final Color darkThemeTextColor = Colors.white;

  static final Color cardColorLight = Colors.white;
  static final Color cardColorDark = Colors.blueGrey;




  // primarySwatch包含了 primaryColor 和 accentColor（primaryColor和accentColor也可以单独设置）
  // primarySwatch实际传入的是MaterialColor，不是一个简单的color
  static final ThemeData lightTheme = ThemeData(
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      highlightColor: Colors.transparent,//去除点击tabbar的过度效果
      // brightness: Brightness.light,//亮度，明亮模式
      primarySwatch: Colors.red,
      // primaryColor: Colors.red,//主要决定导航和底部bottombar颜色
      //   accentColor: Colors.blue,//button和switch等颜色
      textTheme: TextTheme(
        bodyText1:TextStyle(fontSize: normalFontSize,color: lightThemeTextColor),// material默认
        //可以通过Theme.of(context).textTheme.bodyText2获取
        // bodyText2:
        // headline1:
        // headline2:
      ),
      buttonTheme: ButtonThemeData(
          height: 25,
          minWidth: 10
      ),
      cardTheme: CardTheme(
          color: cardColorLight,
          elevation: 20
      )
  );

  static final ThemeData darkTheme = ThemeData(
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      highlightColor: Colors.transparent,//去除点击tabbar的过度效果
      // brightness: Brightness.dark,//亮度，暗黑模式（）
      primarySwatch: Colors.blueGrey,
      // primaryColor: Colors.blueGrey,//主要决定导航和底部bottombar颜色
      // accentColor: Colors.blue,//button和switch等颜色
      textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: normalFontSize,color: darkThemeTextColor)
        //可以通过Theme.of(context).textTheme.bodyText2获取
        // bodyText2:
        // headline1:
        // headline2:
      ),
      buttonTheme: ButtonThemeData(
          height: 25,
          minWidth: 10
      ),
      cardTheme: CardTheme(
          color: cardColorDark,
          elevation: 20
      )
  );
}