package com.pro.scanqrcode.front;
import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.pm.PackageManager
import android.hardware.Camera
import android.os.Bundle
import com.journeyapps.barcodescanner.BarcodeView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class CodeScannerViewFront(messenger: BinaryMessenger?, args: HashMap<String, Any>)
    : PlatformView, MethodChannel.MethodCallHandler {

    private var scanner: BarcodeView? = null
    private var isFlash: Boolean = false
    private var isPaused: Boolean = false
    private var reload:Boolean = false;


    init {
        CodeScannerObjectFront.channel?.setMethodCallHandler(this)
        CodeScannerObjectFront.activity?.application?.registerActivityLifecycleCallbacks(object : Application.ActivityLifecycleCallbacks {
            override fun onActivityPaused(act: Activity) {
                if (act == CodeScannerObjectFront.activity && !isPaused && isCameraPermissionGranted()) {
                    scanner?.pause()
                }
            }

            override fun onActivityStopped(act: Activity) {
            }

            override fun onActivitySaveInstanceState(act: Activity, outState: Bundle) {
            }

            override fun onActivityDestroyed(act: Activity) {
            }

            override fun onActivityCreated(act: Activity, savedInstanceState: Bundle?) {
            }

            override fun onActivityStarted(act: Activity) {
            }

            override fun onActivityResumed(act: Activity) {
                if (act == CodeScannerObjectFront.activity && !isPaused && isCameraPermissionGranted()) {
                    scanner?.resume()
                }
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startScan" -> startScan(result)
            "stopScan" -> stopScan(result)
            "turnOnLight" -> turnOnLight(result)
            "turnOffLight" -> turnOffLight(result)
            "toggleLight" -> toggleLight(result)
            "readDataFromGallery" -> CodeScannerObjectFront.reader.getImage()
            "changeFrontBackScan" -> changeFrontBackScan(result)
            else -> result.notImplemented()
        }
    }

    override fun getView(): BarcodeView? {
        return initCodeScannerView().apply { }
    }

    private fun initCodeScannerView(): BarcodeView? {
        if (scanner == null) {
            scanner = BarcodeView(CodeScannerObjectFront.activity)
            scanner?.cameraSettings?.requestedCameraId = Camera.CameraInfo.CAMERA_FACING_FRONT

        } else {
            if (isCameraPermissionGranted()) {
//                if(reload) {
//                    scanner = BarcodeView(CodeScannerObjectFront.activity)
//                    scanner?.cameraSettings?.requestedCameraId =
//                        Camera.CameraInfo.CAMERA_FACING_BACK
//                } else {
//                    scanner = BarcodeView(CodeScannerObjectFront.activity)
//                    scanner?.cameraSettings?.requestedCameraId =
//                        Camera.CameraInfo.CAMERA_FACING_FRONT
//                }
                if (!isPaused) {
                    scanner!!.resume()

                }
            } else {
                requestCameraPermission()
            }
        }

        return scanner
    }


    override fun dispose() {
        scanner?.pause()
        scanner = null
    }
    private fun changeFrontBackScan(result: MethodChannel.Result) {
        if(scanner?.cameraSettings?.requestedCameraId == Camera.CameraInfo.CAMERA_FACING_FRONT){
            scanner?.cameraSettings?.requestedCameraId == Camera.CameraInfo.CAMERA_FACING_BACK
        } else {
            scanner?.cameraSettings?.requestedCameraId == Camera.CameraInfo.CAMERA_FACING_BACK
        }
    }

    private fun startScan(result: MethodChannel.Result) {
        if (isCameraPermissionGranted()) {
            try {
                scanner?.decodeContinuous { scanData ->
                    CodeScannerObjectFront.channel?.invokeMethod("receiveScanData", scanData.text)
                }
            } catch (e: Exception) {
                result.error("UNKNOWN", "Unable to start scanning.", "")
            }
        } else {
            result.error("PERMISSION_DENIED", "Camera permission denied.", "")
        }
    }

    private fun stopScan(result: MethodChannel.Result){
        scanner?.stopDecoding()
    }

    private fun turnOnLight(result: MethodChannel.Result) {
        if (CodeScannerObjectFront.activity!!.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
            scanner?.setTorch(true)
            result.success(true)
        } else {
            result.error("NOT_HAS_LIGHT", "Light is not available.", "")
        }
    }

    private fun turnOffLight(result: MethodChannel.Result) {
        if (CodeScannerObjectFront.activity!!.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
            scanner?.setTorch(false)
            result.success(false)
        } else {
            result.error("NOT_HAS_LIGHT", "Light is not available.", "")
        }
        reload = !reload;
        initCodeScannerView();
    }

    private fun toggleLight(result: MethodChannel.Result) {
        if (CodeScannerObjectFront.activity!!.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
            isFlash = !isFlash
            scanner?.setTorch(isFlash)
            result.success(isFlash)
        } else {
            result.error("NOT_HAS_LIGHT", "Light is not available.", "")
        }
    }

    private fun isCameraPermissionGranted(): Boolean {
        return CodeScannerObjectFront.activity?.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestCameraPermission() {
        CodeScannerObjectFront.activity?.requestPermissions(arrayOf(Manifest.permission.CAMERA), CodeScannerObjectFront.CAMERA_REQUEST_CODE)
    }
}

