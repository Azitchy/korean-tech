package com.example.mobile

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "examverse/backend_url"
    private val prefsName = "examverse_settings"
    private val backendKey = "backend_url"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            when (call.method) {
                "load" -> result.success(prefs.getString(backendKey, null))
                "save" -> {
                    val value = call.argument<String>("value")
                    prefs.edit().putString(backendKey, value).apply()
                    result.success(null)
                }
                "clear" -> {
                    prefs.edit().remove(backendKey).apply()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
