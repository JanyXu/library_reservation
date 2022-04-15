package com.pro.scanqrcode;

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
//    override fun provideSplashScreen(): SplashScreen? {
//        return LottieSplashScreen()
//    }
//    @Override
//    public void configureFlutterEngine(FlutterEngine flutterEngine){
//        super.configureFlutterEngine(flutterEngine)
//        CodeScannerView(flutterEngine.dartExecutor.binaryMessenger)
//    }
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    flutterEngine.plugins.add(CodeScannerPlugin())
}
}
