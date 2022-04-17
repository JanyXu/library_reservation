package com.pro.scanqrcode.front;
import android.app.Activity
import com.pro.scanqrcode.back.CodeReaderBack
import io.flutter.plugin.common.MethodChannel

object CodeScannerObjectFront {
    var channel: MethodChannel? = null
    var activity: Activity? = null
    const val CAMERA_REQUEST_CODE = 200
    var readSuccess: Boolean = false
    var reader: CodeReaderFront = CodeReaderFront()
}