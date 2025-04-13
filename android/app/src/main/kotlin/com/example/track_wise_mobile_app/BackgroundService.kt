package com.example.track_wise_mobile_app

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import java.util.Date
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import androidx.core.app.NotificationCompat
import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import android.app.AppOpsManager
import android.content.pm.PackageManager
import android.content.pm.ApplicationInfo
import java.util.Calendar
import com.google.gson.Gson
import java.io.IOException
import java.util.*
import java.net.HttpURLConnection
import java.net.URL
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import java.text.SimpleDateFormat
import java.util.Locale
private val CHANNEL_ID = "BackgroundServiceChannel"

class BackgroundService : Service() {
    private val TAG = "BackgroundService"
    private val handler = Handler(Looper.getMainLooper())
    private val interval = 180 * 1000L // 180 seconds interval
    private var counter = 0
    private var userToken: String? = null
    private val runnable = object : Runnable {
        @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
        override fun run() {
            Log.d(TAG, "Running usage stats collection at ${Date()}")
            val usageStats = collectUsageStats()
            getSteps { steps ->
                /////////////////////////notification
                val totalUsageMinutes = usageStats?.sumOf { it["usageMinutes"] as Double } ?: 0.0
                val hours = totalUsageMinutes.toInt() / 60
                val minutes = totalUsageMinutes.toInt() % 60
                val notificationMessage = if (hours > 0) {
                    "Steps today: ${steps?.toInt() ?: 0} Step\nUsage time: ${hours}hr${minutes}mins"
                } else {
                    "Steps today: ${steps?.toInt() ?: 0} Step\nUsage time: ${minutes} mins"
                }
                updateNotification(notificationMessage)
                /////////////////////////
                val sharedPref = getSharedPreferences("MyPrefs", MODE_PRIVATE)
                userToken = sharedPref.getString("USER_TOKEN", null)
                if (!userToken.isNullOrEmpty() && counter >= 3) {
                    Log.d(TAG, "inside for sending data")
                    counter = 0
                    val currentDateFormatted = java.text.SimpleDateFormat("d-M-yyyy", Locale.getDefault()).format(Date())
                    val finalJsonData = Gson().toJson(
                    mapOf(
                        "usage" to mapOf(
                            currentDateFormatted to usageStats
                        ),
                        "steps" to mapOf(
                            currentDateFormatted to steps
                        ),
                        
                    ).filterValues { it != null })
                    sendPostRequest(finalJsonData, userToken)
                }
                counter++
            }
            // Schedule the next execution
            handler.postDelayed(this, interval)
        }
    }
    
  override fun onCreate() {
    super.onCreate()
    createNotificationChannel()
    val notification = createNotification()

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) { // Android 14 (API 34)
        startForeground(
            1,
            notification,
            0x00000101 
        )
    } else {
        startForeground(1, notification)
    }

    Log.d(TAG, "Background service created")
}
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Background Service",
                NotificationManager.IMPORTANCE_MIN
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }
    private fun createNotification(): Notification {
        val pendingIntent = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Keep on the hard work")
            .setContentText("Steps today: 0\nUsage time: 0 mins")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setStyle(NotificationCompat.BigTextStyle().bigText("Steps today: 0\nUsage time: 0 mins"))
            .setContentIntent(createPendingIntent())
            .build()
    }
    private fun updateNotification(steps: String) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Create the updated notification with new step count
        val updatedNotification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Keep on the hard work")
            .setContentText(steps)  // Dynamic message with step count
            .setSmallIcon(R.mipmap.ic_launcher)
            .setStyle(NotificationCompat.BigTextStyle().bigText(steps))
            .setContentIntent(createPendingIntent())
            .build()

        // Update the notification
        notificationManager.notify(1, updatedNotification)
    }
    private fun createPendingIntent(): PendingIntent {
        val intent = Intent(this, MainActivity::class.java)
        return PendingIntent.getActivity(
            this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Background service started")
        userToken = intent?.getStringExtra("TOKEN_KEY")
        // Start the periodic task
        handler.post(runnable)
        
        return START_STICKY
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Remove callbacks to prevent memory leaks
        handler.removeCallbacks(runnable)
        Log.d(TAG, "Background service destroyed")
    }
    
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
    private fun sendPostRequest(jsonData: String, userToken: String?) {
        val urlString = "https://trackwise-backend-3m8o.onrender.com/api/updateUsage-Steps"
        val token = userToken ?: ""
        
        Thread {
            try {
                val url = URL(urlString)
                val connection = url.openConnection() as HttpURLConnection
                connection.requestMethod = "POST"
                connection.doOutput = true
                connection.setRequestProperty("Content-Type", "application/json; charset=utf-8")
                connection.setRequestProperty("Authorization", "Bearer $token")

                // Write data
                val outputStream = connection.outputStream
                outputStream.write(jsonData.toByteArray(Charsets.UTF_8))
                outputStream.flush()
                outputStream.close()

                // Read response
                val responseCode = connection.responseCode
                val response = connection.inputStream.bufferedReader().use { it.readText() }

                //Log.d(TAG, "Server response: $responseCode - $response")

                connection.disconnect()
            } catch (e: IOException) {
                Log.e(TAG, "Failed to send data: ${e.message}")
            }
        }.start()
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun collectUsageStats(): List<Map<String, Any>>? {

        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            packageName
        )

        if (mode != AppOpsManager.MODE_ALLOWED) {
            Log.e(TAG, "No usage stats permission")
            return null
        }
        val endTime = System.currentTimeMillis()
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)

        val startTime = calendar.timeInMillis
        val startDate = calendar.time        
        val stats = getUsageStats(usageStatsManager, startTime, endTime).filter { it["usageMinutes"] as Double >= 1.0 }
        return stats
    }
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    fun getUsageStats(usageStatsManager: UsageStatsManager, startTime: Long, endTime: Long): List<Map<String, Any>> {
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
                        val icon = ""
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
                    "packageName" to packageName,
                    "appIcon" to appIcon
                )
            )
        }

        return resultList
    }
    @RequiresApi(Build.VERSION_CODES.KITKAT)
    fun getSteps(callback: (Float?) -> Unit) {
        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val stepSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        if (stepSensor == null) {
            Log.d(TAG, "Step Counter sensor not available.")
            callback(null)
            return
        }

        var tempListener: SensorEventListener? = null

        val timeoutHandler = Handler(Looper.getMainLooper())
        val timeoutRunnable = Runnable {
            tempListener?.let {
                sensorManager.unregisterListener(it)
                Log.d(TAG, "Sensor timeout: no new data.")
                callback(null)
            }
        }
        tempListener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent?) {
                if (event?.sensor?.type == Sensor.TYPE_STEP_COUNTER) {
                    timeoutHandler.removeCallbacks(timeoutRunnable)
                    val steps = event.values[0]
                    //Log.d(TAG, "Steps since reboot: $steps")
                    ////////////////////////////////////////////////
                    val sharedPreferences = getSharedPreferences("MyPrefs", Context.MODE_PRIVATE)
                    val currentDateSaved = sharedPreferences.getString("currentDateSaved", null)
                    val currentBigNumber = sharedPreferences.getFloat("currentBigNumberSteps", 0f)
                    val currentDateFormatted = java.text.SimpleDateFormat("d-M-yyyy", Locale.getDefault()).format(Date())
                    var finalStepsData: Float? = null
                    if (currentDateSaved != null && currentDateSaved == currentDateFormatted) {
                        val stepsDifference = steps - currentBigNumber
                        if(stepsDifference < 0)
                        {
                            // If a restart happened today, reset the steps data for today
                            finalStepsData = steps
                            sharedPreferences.edit().putFloat("steps:$currentDateFormatted", steps).apply()
                            sharedPreferences.edit().putFloat("currentBigNumberSteps", steps).apply()
                            Log.d(TAG, "Restart detected. Steps data reset for today.")
                        }else{
                            Log.d(TAG, "normal update")
                            finalStepsData = stepsDifference
                            sharedPreferences.edit().putFloat("steps:$currentDateFormatted", stepsDifference).apply()
                        }
                    } else {
                        //update date and bignumber
                        sharedPreferences.edit().putString("currentDateSaved", currentDateFormatted).apply()
                        sharedPreferences.edit().putFloat("currentBigNumberSteps", steps).apply()
                        Log.d(TAG, "date and big number changes")
                    }
                    ////////////////////////////////////////////////

                    // Unregister to avoid keeping listener active
                    sensorManager.unregisterListener(this)
                    callback(finalStepsData)
                }
            }

            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
        }

        sensorManager.registerListener(tempListener, stepSensor, SensorManager.SENSOR_DELAY_NORMAL)
        timeoutHandler.postDelayed(timeoutRunnable, 8000)
    }

    companion object {
        fun isServiceRunning(context: Context): Boolean {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
            for (service in activityManager.getRunningServices(Integer.MAX_VALUE)) {
                if (BackgroundService::class.java.name == service.service.className) {
                    return true
                }
            }
            return false
        }
    }
    // Make sure service restarts if killed
    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        
        val restartServiceIntent = Intent(applicationContext, BackgroundService::class.java)
        restartServiceIntent.setPackage(packageName)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(restartServiceIntent)
        } else {
            startService(restartServiceIntent)
        }
    }
}