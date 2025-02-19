package com.example.track_wise_mobile_app

import io.flutter.embedding.android.FlutterActivity
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar
import android.app.usage.UsageEvents
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.util.Base64
import java.io.ByteArrayOutputStream



class MainActivity: FlutterActivity(){
     private val CHANNEL = "usage_stats"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getUsageStats") {
                 val startTime = call.argument<Long>("startTime") ?: 0
                val endTime = call.argument<Long>("endTime") ?: System.currentTimeMillis()
                val usageStats = getUsageStats(startTime, endTime)
                result.success(usageStats)
            }else if (call.method == "getUsageStatsSam") {
                val startTime = call.argument<Long>("startTime") ?: 0
                val endTime = call.argument<Long>("endTime") ?: System.currentTimeMillis()
                val usageStats = getUsageStatsSam(startTime, endTime)
                result.success(usageStats)
            } 
            else {
                result.notImplemented()
            }

        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun getUsageStats(startTime: Long, endTime: Long): List<Map<String, Any>> {
    val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
    val packageManager = packageManager

    val usageStatsMap = usageStatsManager.queryAndAggregateUsageStats(startTime, endTime)
    val result = mutableListOf<Map<String, Any>>()

    for ((packageName, usageStats) in usageStatsMap) {
        if (usageStats.totalTimeInForeground > 0) {
            try {
                val appInfo = packageManager.getApplicationInfo(packageName, 0)
                val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                if (!isSystemApp) { // Only add user-installed apps
                    val minutes = usageStats.totalTimeInForeground / (1000.0 * 60)
                    val appIcon = getAppIconAsBase64(packageManager, packageName)
                    val appName = packageManager.getApplicationLabel(appInfo).toString()

                    result.add(
                        mapOf(
                            "appName" to appName,
                            "usageMinutes" to minutes,
                            "appIcon" to appIcon
                        )
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
    return result
}



 
   @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
private fun getUsageStatsSam(startTime: Long, endTime: Long): List<Map<String, Any>> {
    val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
    val packageManager = packageManager

    val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
    val result = mutableMapOf<String, Long>() // Store usage time per app
    val icons = mutableMapOf<String, String>() // Store icons per app

    var lastEvent: UsageEvents.Event? = null
    while (usageEvents.hasNextEvent()) {
        val event = UsageEvents.Event()
        usageEvents.getNextEvent(event)

        if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
            lastEvent = event
        } else if (event.eventType == UsageEvents.Event.MOVE_TO_BACKGROUND && lastEvent != null) {
            val packageName = event.packageName
            val usageTime = event.timeStamp - lastEvent.timeStamp

            try {
                val appInfo = packageManager.getApplicationInfo(packageName, 0)
                if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0) { // Exclude system apps
                    val appName = packageManager.getApplicationLabel(appInfo).toString()
                    val appIcon = getAppIconAsBase64(packageManager, packageName)

                    result[appName] = result.getOrDefault(appName, 0) + usageTime
                    icons[appName] = appIcon
                }
            } catch (e: PackageManager.NameNotFoundException) {
                e.printStackTrace()
            }
            lastEvent = null
        }
    }

    // Convert results to a list of maps
    return result.map { (appName, usageTime) ->
        mapOf(
            "appName" to appName,
            "usageMinutes" to usageTime / (1000.0 * 60),
            "appIcon" to (icons[appName] ?: "")
        )
    }
}


    private fun getAppIconAsBase64(packageManager: PackageManager, packageName: String): String {
            return try {
                val drawable = packageManager.getApplicationIcon(packageName)
                val bitmap = (drawable as BitmapDrawable).bitmap
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                val byteArray = stream.toByteArray()
                Base64.encodeToString(byteArray, Base64.DEFAULT)
            } catch (e: Exception) {
                ""
            }
        }
}
