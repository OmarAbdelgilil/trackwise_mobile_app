package com.example.track_wise_mobile_app

import android.app.*
import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import java.text.SimpleDateFormat
import java.util.*
import android.util.Log
import android.os.Handler
import android.os.Looper

class StepCounterService : Service(), SensorEventListener {

    private lateinit var sensorManager: SensorManager
    private var stepSensor: Sensor? = null
    private var initialSteps = -1
    private var lastRecordedSteps = 0
    private var lastRecordedSteps2 = 0

        private val handler = Handler(Looper.getMainLooper())
    private val checkMidnightRunnable = object : Runnable {
        override fun run() {
            checkIfPastMidnight()
            handler.postDelayed(this, 10 * 60 * 1000)
        }
    }

    override fun onCreate() {
    super.onCreate()
    Log.d("StepCounterService", "onCreate() called - Service started")
    handler.post(checkMidnightRunnable)
    val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
    lastRecordedSteps = sharedPreferences.getInt("lastRecordedSteps2", 0)
    lastRecordedSteps2 = lastRecordedSteps
    Handler(Looper.getMainLooper()).postDelayed({
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        stepSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)

        stepSensor?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
        }
           startForegroundService()
    }, 5000) 
}



    private fun startForegroundService() {
        val notificationChannelId = "step_counter_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                notificationChannelId,
                "Step Counter Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, notificationChannelId)
            .setContentTitle("Step Tracking Active")
            .setContentText("Your steps are being tracked continuously.")
            .build()

        startForeground(1, notification)
    }


override fun onSensorChanged(event: SensorEvent?) {
            if (event?.sensor?.type == Sensor.TYPE_STEP_COUNTER) {
                val currentSteps = event.values[0].toInt()
                val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
                initialSteps = sharedPreferences.getInt("initialSteps", -1)
                // If first time setting initialSteps today, store it
                if (initialSteps == -1) {
                    initialSteps = currentSteps

                    // Save it persistently
                    
                    sharedPreferences.edit()
                        .putInt("initialSteps", initialSteps)
                        .apply()
                }
                val isRebooted = sharedPreferences.getBoolean("reboot", false)
                 Log.d("StepCounterService", isRebooted.toString())
                if(isRebooted)
                {
                    lastRecordedSteps = lastRecordedSteps2 + (currentSteps - initialSteps)
                }
                else{
                    lastRecordedSteps = currentSteps - initialSteps
                }
                
                sharedPreferences.edit()
                    .putInt("lastRecordedSteps2", lastRecordedSteps).putInt("lastReading", currentSteps)
                    .apply()
            }
        }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}


    private fun checkIfPastMidnight() {
        val calendar = Calendar.getInstance()
        val currentHour = calendar.get(Calendar.HOUR_OF_DAY)

        val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
        val hasRunToday = sharedPreferences.getBoolean("hasRunToday", false)

        if (currentHour == 0 && !hasRunToday) { 

            val lastRecordedSteps = sharedPreferences.getInt("lastRecordedSteps2", 0)
            val lastReading = sharedPreferences.getInt("lastReading", 0)

            val yesterday = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, -1)
            }
            val dateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
            val yesterdayDate = dateFormat.format(yesterday.time)

            sharedPreferences.edit()
                .putInt(yesterdayDate, lastRecordedSteps) 
                .putInt("initialSteps", lastReading) 
                .putInt("lastRecordedSteps2", 0) 
                .putBoolean("reboot", false)
                .putBoolean("hasRunToday", true) 
                .apply()

            Log.d("StepCounterService", "Steps reset at midnight")
        }
        if (currentHour == 1) {
            sharedPreferences.edit().putBoolean("hasRunToday", false).apply()
            Log.d("StepCounterService", "hasRunToday reset")
        }
}


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorManager.unregisterListener(this)
    }
}
