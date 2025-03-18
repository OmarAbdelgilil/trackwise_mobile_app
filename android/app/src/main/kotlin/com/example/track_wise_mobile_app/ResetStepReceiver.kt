package com.example.track_wise_mobile_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import java.text.SimpleDateFormat
import java.util.*
import android.util.Log
class ResetStepReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        context?.let {
            val sharedPreferences = it.getSharedPreferences("StepData", Context.MODE_PRIVATE)
            val lastRecordedSteps = sharedPreferences.getInt("lastRecordedSteps2", 0)
            val lastReading =  sharedPreferences.getInt("lastReading", 0)
            val yesterday = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, -1)
            }
            val dateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
            val yesterdayDate = dateFormat.format(yesterday.time)
            
            // Calculate yesterday’s steps correctly
            val stepsYesterday = lastRecordedSteps
            Log.d("StepCounterService",lastReading.toString())
            // Save yesterday's steps and reset for today
            sharedPreferences.edit()
                .putInt(yesterdayDate, stepsYesterday)
                .putInt("initialSteps", lastReading)
                .putInt("lastRecordedSteps2", 0)
                .putBoolean("reboot", false)
                .apply()
        }
    }
}
