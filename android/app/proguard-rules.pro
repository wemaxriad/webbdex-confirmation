# Twilio Voice
-keep class com.twilio.** { *; }
-dontwarn com.twilio.**

# Twilio WebRTC
-keep class tvi.webrtc.** { *; }
-dontwarn tvi.webrtc.**

# Kotlin
-keep class kotlin.Metadata { *; }

# OkHttp (used by Twilio)
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Firebase Messaging
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**