package com.example.track_wise_mobile_app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import java.util.*
import android.util.Log

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            Log.d("StepCounterService", "Boot completed - receiver triggered")
            context?.let {
                setRebootvalue(it)
                scheduleMidnightReset(it)
                startStepCounterService(it)
            }
        }
    }

    private fun startStepCounterService(context: Context) {
    val serviceIntent = Intent(context, StepCounterService::class.java)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        context.startForegroundService(serviceIntent)
    } else {
        context.startService(serviceIntent)
    }
}

    private fun setRebootvalue(context: Context) {
        val sharedPreferences = context.getSharedPreferences("StepData", Context.MODE_PRIVATE)
            sharedPreferences.edit()
            .putBoolean("reboot", true).putInt("initialSteps", -1)
            .apply()
           
            Log.d("StepCounterService",  sharedPreferences.getInt("initialSteps",0).toString())
        
    }

        private fun scheduleMidnightReset(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ResetStepReceiver::class.java)
        
        // Check if the alarm is already set
        val pendingIntentCheck = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        
        if (pendingIntentCheck != null) {
            Log.d("StepCounterService", "🚀 Midnight reset alarm already set, skipping reschedule.")
            return
        }

        // Create a new PendingIntent for the alarm
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)

            // If midnight has already passed, schedule for the next day
            if (timeInMillis <= System.currentTimeMillis()) {
                add(Calendar.DAY_OF_YEAR, 1)
            }
        }

        Log.d("StepCounterService", "🕛 Scheduling midnight reset at: ${calendar.time}")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                pendingIntent
            )
        } else {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                pendingIntent
            )
        }

        Log.d("StepCounterService", "✅ Midnight reset scheduled successfully.")
    }

}
