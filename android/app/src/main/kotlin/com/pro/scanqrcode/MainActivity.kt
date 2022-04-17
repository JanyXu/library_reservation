package com.pro.scanqrcode;

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.pro.scanqrcode.SM4Util;
import io.flutter.plugin.common.MethodChannel
import java.nio.charset.StandardCharsets
import  kotlin.String;
import com.pro.scanqrcode.front.CodeScannerPluginFront;
import com.pro.scanqrcode.back.CodeScannerPluginBack;


class MainActivity : FlutterActivity() {
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

        flutterEngine.plugins.add(CodeScannerPluginBack())
        flutterEngine.plugins.add(CodeScannerPluginFront())

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // 新建一个 Channel 对象
        val channel = MethodChannel(messenger, "encrypt")
// 为 channel 设置回调
        channel.setMethodCallHandler { call, res ->
            // 根据方法名，分发不同的处理
            when(call.method) {

                "encrypt" -> {
                    // 获取传入的参数
                    val data = call.argument<String>("data")
                    val key = call.argument<String>("key")
                    val result = SM4Util.encrypt(data, key,SM4Util.SM4_ECB_PKCS5, null)

                    // 通知执行成功
                    res.success(result)
                }

                else -> {
                    // 如果有未识别的方法名，通知执行失败
                    res.error("error_code", "error_message", null)
                }
            }
        }

    }
}
