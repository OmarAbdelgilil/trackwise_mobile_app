package com.example.track_wise_mobile_app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import java.text.SimpleDateFormat
import android.os.Build
import java.util.*

class ResetStepReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        context?.let {
            val sharedPreferences = it.getSharedPreferences("StepData", Context.MODE_PRIVATE)
            val lastRecordedSteps = sharedPreferences.getInt("lastRecordedSteps2", 0)
            val lastReading = sharedPreferences.getInt("lastReading", 0)

            val yesterday = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, -1)
            }
            val dateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
            val yesterdayDate = dateFormat.format(yesterday.time)

            // Calculate yesterday’s steps correctly
            val stepsYesterday = lastRecordedSteps
            Log.d("StepCounterService", lastReading.toString())

            // Save yesterday's steps and reset for today
            sharedPreferences.edit()
                .putInt(yesterdayDate, stepsYesterday)
                .putInt("initialSteps", lastReading)
                .putInt("lastRecordedSteps2", 0)
                .putBoolean("reboot", false)
                .apply()

            // Schedule the next midnight reset
            scheduleNextMidnightReset(it)
        }
    }

    private fun scheduleNextMidnightReset(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ResetStepReceiver::class.java)

        // Check if an alarm is already set
        val pendingIntentCheck = PendingIntent.getBroadcast(
            context, 1001, intent, PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )

        if (pendingIntentCheck != null) {
            Log.d("StepCounterService", "🚀 Midnight reset alarm already set, skipping reschedule.")
            return
        }

        // Create a new PendingIntent for the alarm
        val pendingIntent = PendingIntent.getBroadcast(
            context, 1001, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
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

        Log.d("StepCounterService", "🕛 Scheduling next midnight reset at: ${calendar.time}")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent
            )
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent)
        }

        Log.d("StepCounterService", "✅ Next midnight reset scheduled successfully.")
    }
}
