// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:library_reservation/ui/pages/scan/scan_page.dart';
// import 'package:library_reservation/ui/pages/webview/setting_page.dart';
//
// class HomeDefaultPage extends StatelessWidget {
//   const HomeDefaultPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
//       appBar: AppBar(
//         backgroundColor: Colors.transparent, //把appbar的背景色改成透明
//         // elevation: 0,//appbar的阴影
//         title: Text(""),
//         actions: [
//           GestureDetector(
//             child: Icon(
//               Icons.settings,
//             ),
//             onTap: () {
//               //跳转到设置
//               Navigator.of(context).pushNamed(SettingPage.routeString);
//             },
//           )
//         ],
//       ),
//       body: Center(
//           child: MaterialButton(
//             child: Image(
//               image: AssetImage('assets/images/main_scan_button.png'),
//             ),
//             onPressed: (){
//               print('dd3');
//               Navigator.push(context, MaterialPageRoute(builder: (_) {
//                 return ScanPage(true);
//               }));
//             },
//           )),
//     );
//   }
// }