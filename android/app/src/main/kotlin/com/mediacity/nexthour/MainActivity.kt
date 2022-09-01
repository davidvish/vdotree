package com.vdotree.vdotree

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import android.view.WindowManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
// my
//import android.view.WindowManager.LayoutParams;

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
       // super.configureFlutterEngine(flutterEngine)
        //getWindow().addFlags(LayoutParams.FLAG_SECURE);
    }
}


