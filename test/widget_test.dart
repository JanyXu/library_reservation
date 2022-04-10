// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sm_crypto/sm_crypto.dart';

import 'package:library_reservation/main.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
  String key = SM4.createHexKey(key: 'DE9CF236992B4D77');
  String ebctData = 'faAgwpJU8NOAirOEW0dT4Xlk3yFHW5KhKvIShG2cbbmxBz6lgaMAiEUXdbPupgNQqicsagUVW6kADw78+PUqSsjK4n8X3YQ/Uxi+UDWJijs=';
  String ebcDecryptData = SM4.decrypt(
      data: ebctData,
      key: key,
      padding: SM4PaddingMode.PKCS5,
      mode: SM4CryptoMode.ECB,
      iv: key
  );
  print('🔑 EBC DecryptData:\n $ebcDecryptData');
}
