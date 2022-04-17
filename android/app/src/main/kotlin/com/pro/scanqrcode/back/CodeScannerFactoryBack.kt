package com.pro.scanqrcode.back;
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class CodeScannerFactoryBack (private val messenger: BinaryMessenger): PlatformViewFactory(StandardMessageCodec.INSTANCE){

    override fun create(context: Context?, viewId: Int, args: Any): PlatformView {
        val argument = args as HashMap<String, Any>
        return CodeScannerViewBack(messenger, argument)
    }
}