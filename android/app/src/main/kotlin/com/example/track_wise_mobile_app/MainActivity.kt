package com.example.track_wise_mobile_app

import android.Manifest
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
import android.graphics.Canvas
import android.graphics.drawable.AdaptiveIconDrawable
import android.app.AppOpsManager
import android.content.Intent
import android.os.Binder
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.content.SharedPreferences
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.util.Log
import android.net.Uri
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings



class MainActivity: FlutterActivity(),SensorEventListener {
     private val CHANNEL = "usage_stats"
    companion object {
        private var instance: MainActivity? = null
        
        fun getInstance(): MainActivity? {
            return instance
        }
    }
    private lateinit var sensorManager: SensorManager
    private var stepSensor: Sensor? = null
    private var initialSteps = -1
    private var lastRecordedSteps = 0

    
    // ADDED: Set instance in onCreate
override fun onCreate(savedInstanceState: android.os.Bundle?) {
    super.onCreate(savedInstanceState)
    instance = this
    val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
    initialSteps = sharedPreferences.getInt("initialSteps", -1)
    lastRecordedSteps = sharedPreferences.getInt("lastRecordedSteps2", 0)

    // Initialize sensor manager
    sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
    stepSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)

    if (stepSensor != null) {
        sensorManager.registerListener(this, stepSensor, SensorManager.SENSOR_DELAY_UI)
    }

    // 🔹 Check for ACTIVITY_RECOGNITION permission (Android 10+)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        if (checkSelfPermission(Manifest.permission.ACTIVITY_RECOGNITION) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.ACTIVITY_RECOGNITION), 1001)
        }
    }

    val serviceIntent = Intent(this, StepCounterService::class.java)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        startForegroundService(serviceIntent)
    } else {
        startService(serviceIntent)
    }

    // Check for exact alarm permission (Android 12+)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        if (checkSelfPermission(android.Manifest.permission.SCHEDULE_EXACT_ALARM) == PackageManager.PERMISSION_GRANTED) {
        } else {
            requestExactAlarmPermission()
        }
    } 
}

    override fun onResume() {
    super.onResume()
}
    
    // ADDED: Clear instance in onDestroy
    override fun onDestroy() {
        super.onDestroy()
        if (instance == this) {
            instance = null
        }
        sensorManager.unregisterListener(this)
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getUsageStats") {
                 val startTime = call.argument<Long>("startTime") ?: 0
                val endTime = call.argument<Long>("endTime") ?: System.currentTimeMillis()
                val usageStats = getUsageStats(startTime, endTime)
                result.success(usageStats)
            }
            else if (call.method == "checkUsageAccess") {
                    result.success(hasUsageAccessPermission())
                }
            else if (call.method == "openUsageAccessSettings"){
                    openUsageAccessSettings()
                    result.success(null)
                }
            else if (call.method == "startBackgroundService") {
                val token = call.argument<String>("token") ?: ""
                startBackgroundService(token)
                result.success("Background service started")
            }
            else if (call.method == "stopBackgroundService") {
                stopBackgroundService()
                result.success("Background service stopped")
            }else if (call.method == "isBackgroundServiceRunning") {
                val isRunning = BackgroundService.isServiceRunning(this)
                result.success(isRunning)
            }
            else if (call.method == "getSteps") {
                val date = call.argument<String>("date") ?: ""
                val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
     
                val todayDate = Calendar.getInstance().let {
                    "${String.format("%02d", it.get(Calendar.DAY_OF_MONTH))}-${String.format("%02d", it.get(Calendar.MONTH) + 1)}-${it.get(Calendar.YEAR)}"
                }
                
                if (date == todayDate) {
                    result.success(lastRecordedSteps)
                } else {
                    val storedSteps = sharedPreferences.getInt(date, 0)
                    result.success(storedSteps)
                }
            }
            else {
                result.notImplemented()
            }

        }
    }
    private fun startBackgroundService(token: String) {
        val serviceIntent = Intent(this, BackgroundService::class.java)
        serviceIntent.putExtra("TOKEN_KEY", token) 
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }
    
    private fun stopBackgroundService() {
        val serviceIntent = Intent(this, BackgroundService::class.java)
        stopService(serviceIntent)
    }

override fun onSensorChanged(event: SensorEvent?) {
            if (event?.sensor?.type == Sensor.TYPE_STEP_COUNTER) {
                val currentSteps = event.values[0].toInt()

                // If first time setting initialSteps today, store it
                if (initialSteps == -1) {
                    initialSteps = currentSteps

                    // Save it persistently
                    val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
                    sharedPreferences.edit()
                        .putInt("initialSteps", initialSteps)
                        .apply()
                }

                lastRecordedSteps = currentSteps - initialSteps
   
                // Save updated steps
                val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
                 Log.d("tttt", sharedPreferences.getInt("15-03-2025", 0).toString())

                sharedPreferences.edit()
                    .putInt("lastRecordedSteps2", lastRecordedSteps)
                    .apply()
            }
        }

       override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed
    }
private fun requestExactAlarmPermission() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {  // API 31+ (Android 12+)
        val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
        if (!alarmManager.canScheduleExactAlarms()) {
            val intent = Intent(android.provider.Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
            startActivity(intent)
        }
    }
}



    fun hasUsageAccessPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Binder.getCallingUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun openUsageAccessSettings() {
        val intent = Intent(android.provider.Settings.ACTION_USAGE_ACCESS_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    fun getUsageStats(startTime: Long, endTime: Long): List<Map<String, Any>> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val packageManager = packageManager

        val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
        val usageTimeMap = mutableMapOf<String, Long>()  
        val appInfoCache = mutableMapOf<String, Pair<String, String>>()  
        val lastEventMap = mutableMapOf<String, Long>()  

        val event = UsageEvents.Event()
        while (usageEvents.hasNextEvent()) {
            usageEvents.getNextEvent(event)

            val packageName = event.packageName
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastEventMap[packageName] = event.timeStamp
            } else if (event.eventType == UsageEvents.Event.MOVE_TO_BACKGROUND) {
                val startTimestamp = lastEventMap.remove(packageName)
                if (startTimestamp != null) {
                    val usageTime = event.timeStamp - startTimestamp
                    usageTimeMap[packageName] = usageTimeMap.getOrDefault(packageName, 0L) + usageTime
                }
            }
        }

        // Retrieve app names and icons only once per app
        val resultList = mutableListOf<Map<String, Any>>()
        usageTimeMap.forEach { (packageName, usageTime) ->
            val (appName, appIcon) = appInfoCache.getOrPut(packageName) {
                try {
                    val appInfo = packageManager.getApplicationInfo(packageName, 0)
                    val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                    val isGoogleApp = packageName.startsWith("com.google.") || (packageName == "com.android.chrome") || (packageName == "com.android.settings")
                     if (!isSystemApp || isGoogleApp) { 
                        val name = packageManager.getApplicationLabel(appInfo).toString()
                        val icon = getAppIconAsBase64(packageName)
                        name to icon
                    } else null
                } catch (e: PackageManager.NameNotFoundException) {
                    null
                } ?: return@forEach
            }

            resultList.add(
                mapOf(
                    "appName" to appName,
                    "usageMinutes" to usageTime / (1000.0 * 60), // Convert to minutes
                    "appIcon" to appIcon
                )
            )
        }

        return resultList
    }



    private fun getAppIconAsBase64(packageName: String): String {
    return try {
        val pm: PackageManager = applicationContext.packageManager
        val drawable = pm.getApplicationIcon(packageName)

        val bitmap = when (drawable) {
            is BitmapDrawable -> drawable.bitmap
            is AdaptiveIconDrawable -> {
                val size = 108 // Adjust size if needed
                val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, size, size)
                drawable.draw(canvas)
                bitmap
            }
            else -> return ""
        }

        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val byteArray = stream.toByteArray()
        Base64.encodeToString(byteArray, Base64.DEFAULT)
    } catch (e: PackageManager.NameNotFoundException) {
        ""
    }
}


}
