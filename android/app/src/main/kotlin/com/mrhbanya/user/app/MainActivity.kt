package com.mrhbanya.user.app

import io.flutter.embedding.android.FlutterActivity
import com.pusher.pushnotifications.PushNotifications
import android.os.Bundle

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize Pusher Push Notifications
        PushNotifications.start(applicationContext, "26f1217e-7f7a-403f-8bc4-e3f5d994f42e")
        PushNotifications.addDeviceInterest("hello")
    }
}