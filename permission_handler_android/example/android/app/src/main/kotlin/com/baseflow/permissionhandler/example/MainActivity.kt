package com.baseflow.permissionhandler.example

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "location_granularity")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "status" -> {
                        val fineGranted = isGranted(Manifest.permission.ACCESS_FINE_LOCATION)
                        val coarseGranted = isGranted(Manifest.permission.ACCESS_COARSE_LOCATION)
                        result.success(mapOf("fine" to fineGranted, "coarse" to coarseGranted))
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun isGranted(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
    }
}
