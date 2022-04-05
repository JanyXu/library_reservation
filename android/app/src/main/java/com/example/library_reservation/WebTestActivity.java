package com.example.library_reservation;

import android.os.Build;
import android.os.Bundle;

import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
public class WebTestActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP)
        {//API>21,设置状态栏颜色透明
            getWindow().setStatusBarColor(0);
        }
        //GeneratedPluginRegistrant.registerWith(this);

    }
}