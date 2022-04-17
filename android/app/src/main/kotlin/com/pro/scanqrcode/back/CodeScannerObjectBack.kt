package com.pro.scanqrcode.back;
import android.app.Activity
import io.flutter.plugin.common.MethodChannel

object CodeScannerObjectBack {
    var channel: MethodChannel? = null
    var activity: Activity? = null
    const val CAMERA_REQUEST_CODE = 200
    var readSuccess: Boolean = false
    var reader: CodeReaderBack = CodeReaderBack()
}