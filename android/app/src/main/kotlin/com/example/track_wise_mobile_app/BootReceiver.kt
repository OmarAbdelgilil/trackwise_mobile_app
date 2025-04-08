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


}
