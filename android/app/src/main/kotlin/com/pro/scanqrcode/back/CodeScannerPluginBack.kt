package com.pro.scanqrcode.back;
import android.app.Activity.RESULT_OK
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


/** CodeScannerPlugin */
class CodeScannerPluginBack : FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener {


    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val factory = CodeScannerFactoryBack(binding.binaryMessenger)
        CodeScannerObjectBack.channel = MethodChannel(binding.binaryMessenger, "code_scanner_back")
        binding.platformViewRegistry.registerViewFactory("code_scanner_view_back", factory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        CodeScannerObjectBack.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        CodeScannerObjectBack.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        CodeScannerObjectBack.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        CodeScannerObjectBack.activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        // CodeReader process: pick up from gallery
        if (resultCode == RESULT_OK && requestCode == CodeScannerObjectBack.CAMERA_REQUEST_CODE) {
            try {
                val uri = data?.data
                val bitmap = CodeScannerObjectBack.reader.getBitmapFromUri(uri)
                CodeScannerObjectBack.reader.sendReadResult(bitmap)
                return true
            } catch (e: Exception) {
                CodeScannerObjectBack.reader.sendReadResult(null)
                return false
            }
        }
        return false
    }


}

