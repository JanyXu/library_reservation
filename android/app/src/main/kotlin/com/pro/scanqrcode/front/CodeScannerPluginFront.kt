package com.pro.scanqrcode.front;
import android.app.Activity.RESULT_OK
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


/** CodeScannerPlugin */
class CodeScannerPluginFront : FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener {


    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val factory = CodeScannerFactoryFront(binding.binaryMessenger)
        CodeScannerObjectFront.channel = MethodChannel(binding.binaryMessenger, "code_scanner_front")
        binding.platformViewRegistry.registerViewFactory("code_scanner_view_front", factory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        CodeScannerObjectFront.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        CodeScannerObjectFront.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        CodeScannerObjectFront.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        CodeScannerObjectFront.activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        // CodeReader process: pick up from gallery
        if (resultCode == RESULT_OK && requestCode == CodeScannerObjectFront.CAMERA_REQUEST_CODE) {
            try {
                val uri = data?.data
                val bitmap = CodeScannerObjectFront.reader.getBitmapFromUri(uri)
                CodeScannerObjectFront.reader.sendReadResult(bitmap)
                return true
            } catch (e: Exception) {
                CodeScannerObjectFront.reader.sendReadResult(null)
                return false
            }
        }
        return false
    }


}

