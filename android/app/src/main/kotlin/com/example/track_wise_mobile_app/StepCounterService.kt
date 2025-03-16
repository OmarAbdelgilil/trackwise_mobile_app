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

class StepCounterService : Service(), SensorEventListener {

    private lateinit var sensorManager: SensorManager
    private var stepSensor: Sensor? = null
override fun onCreate() {
    super.onCreate()
    Log.d("StepCounterService", "onCreate() called - Service started")
    sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
    stepSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)

    stepSensor?.let {
        sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
    }
    startForegroundService()
     resetStepsAtMidnight()
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
            val stepCount = event.values[0].toInt()
     
            println(stepCount)
            val sharedPreferences = getSharedPreferences("StepData", Context.MODE_PRIVATE)
            sharedPreferences.edit().putInt("lastRecordedSteps", stepCount).apply()
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

 private fun scheduleTestReset() {
           Log.d("StepCounterService", "scheduleTestReset() called")

    val calendar = Calendar.getInstance().apply {
        add(Calendar.MINUTE, 2) // ⏳ Schedule reset in 2 minutes for testing
    }
           println("ss")
    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(this, ResetStepReceiver::class.java)
    val pendingIntent = PendingIntent.getBroadcast(
        this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
           println("ss")
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent
        )
    } else {
        alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent)
    }

    println("🚀 Scheduled reset in 2 minutes") // Debug Log
}

private fun resetStepsAtMidnight() {
    Log.d("StepCounterService", "resetStepsAtMidnight() called")

    val calendar = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 0)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)

        // If it's already past midnight, schedule for the next day
        if (timeInMillis <= System.currentTimeMillis()) {
            add(Calendar.DAY_OF_YEAR, 1)
        }
    }

    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(this, ResetStepReceiver::class.java)
    val pendingIntent = PendingIntent.getBroadcast(
        this, 1001, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    Log.d("StepCounterService", "Reset scheduled for: ${calendar.time}")

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent
        )
    } else {
        alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent)
    }

    Log.d("StepCounterService", "🚀 Midnight reset scheduled")
}


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorManager.unregisterListener(this)
    }
}
