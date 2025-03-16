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
            val lastRecordedSteps = sharedPreferences.getInt("lastRecordedSteps", 0)
            val initialSteps = sharedPreferences.getInt("initialSteps", -1)

            val yesterday = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, -1)
            }
            val dateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
            val yesterdayDate = dateFormat.format(yesterday.time)
            
            // Calculate yesterday’s steps correctly
            val stepsYesterday = if (initialSteps >= 0) lastRecordedSteps - initialSteps else 0
            Log.d("Date", yesterdayDate)
            // Save yesterday's steps and reset for today
            sharedPreferences.edit()
                .putInt(yesterdayDate, stepsYesterday)
                .putInt("initialSteps", lastRecordedSteps)
                .apply()
        }
    }
}
