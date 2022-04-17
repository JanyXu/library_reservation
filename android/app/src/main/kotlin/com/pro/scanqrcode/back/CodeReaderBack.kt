package com.pro.scanqrcode.back;
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import com.google.zxing.BinaryBitmap
import com.google.zxing.MultiFormatReader
import com.google.zxing.RGBLuminanceSource
import com.google.zxing.common.HybridBinarizer

class CodeReaderBack {

    fun getImage() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.type = "image/*"

        CodeScannerObjectBack.activity?.startActivityForResult(intent, CodeScannerObjectBack.CAMERA_REQUEST_CODE)
    }

    fun getBitmapFromUri(uri: Uri?): Bitmap? {
        var bitmap: Bitmap? = null

        if (uri != null && CodeScannerObjectBack.activity != null) {
            bitmap = if (Build.VERSION.SDK_INT < 28) {
                MediaStore.Images.Media.getBitmap(CodeScannerObjectBack.activity!!.contentResolver, uri)
            } else {
                val source = ImageDecoder.createSource(CodeScannerObjectBack.activity!!.contentResolver, uri)
                ImageDecoder.decodeBitmap(source)
            }
        }
        return bitmap
    }

    private fun readCodeFromBitmap(bitmap: Bitmap): String? = with(bitmap) {
        val pixels = IntArray(width * height)
        getPixels(pixels, 0, width, 0, 0, width, height)
        val source = RGBLuminanceSource(width, height, pixels)
        val binaryBitmap = BinaryBitmap(HybridBinarizer(source))

        return MultiFormatReader().decode(binaryBitmap).text
    }

    fun sendReadResult(bitmap: Bitmap?) {
        var readData: String? = null
        if (bitmap != null) {
            readData = readCodeFromBitmap(bitmap)
        }
        CodeScannerObjectBack.channel?.invokeMethod("receiveReadData", listOf(readData != null, readData))
    }
}