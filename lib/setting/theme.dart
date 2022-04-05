import 'package:flutter/material.dart';

class ScanTheme {
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
      colorScheme: colorScheme,
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      highlightColor: Colors.transparent,
      //去除点击tabbar的过度效果
      // brightness: Brightness.light,//亮度，明亮模式
      primarySwatch: Colors.blue,
      // primaryColor: Colors.red,//主要决定导航和底部bottombar颜色
      //   accentColor: Colors.blue,//button和switch等颜色
      textTheme: textTheme,
      buttonTheme: ButtonThemeData(height: 25, minWidth: 10),
      cardTheme: CardTheme(color: cardColorLight, elevation: 20));

  static final ThemeData darkTheme = ThemeData(
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      highlightColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      //去除点击tabbar的过度效果
      // brightness: Brightness.dark,//亮度，暗黑模式（）
      primarySwatch: Colors.blueGrey,
      // primaryColor: Colors.blueGrey,//主要决定导航和底部bottombar颜色
      // accentColor: Colors.blue,//button和switch等颜色
      textTheme: TextTheme(
          bodyText1:
              TextStyle(fontSize: normalFontSize, color: darkThemeTextColor)
          //可以通过Theme.of(context).textTheme.bodyText2获取
          // bodyText2:
          // headline1:
          // headline2:
          ),
      buttonTheme: ButtonThemeData(height: 25, minWidth: 10),
      cardTheme: CardTheme(color: cardColorDark, elevation: 20));
  static ColorScheme colorScheme = const ColorScheme(
      primary: Colors.white,
      //上方标题栏颜色
      primaryVariant: Colors.white,
      secondary: Colors.white,
      background: Colors.white,
      error: Colors.red,
      brightness: Brightness.light,
      onBackground: Colors.white,
      secondaryVariant: Colors.white,
      onError: Colors.yellow,
      onPrimary: Colors.black,
      //字体颜色
      onSecondary: Colors.white,
      onSurface: Colors.white,
      surface: Colors.white);
  static TextTheme textTheme =
      const TextTheme(headline1: TextStyle(color: Colors.black,fontSize: 12),
          headline2: TextStyle(color: Colors.black,fontSize: 18),
          headline3: TextStyle(color: Colors.black,fontSize: 16), headline4: TextStyle(color: Colors.black,fontSize: 14));
}
