-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*

-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

-optimizations !method/inlining/*

-keepclasseswithmembers class * {
  public void onPayment*(...);
#-keep class com.dexterous.** { *; }
## Flutter wrapper
 #-keep class io.flutter.app.** { *; }
 #-keep class io.flutter.plugin.** { *; }
 #-keep class io.flutter.util.** { *; }
 #-keep class io.flutter.view.** { *; }
 #-keep class io.flutter.** { *; }
 #-keep class io.flutter.plugins.** { *; }
# -keep class com.google.firebase.** { *; } // uncomment this if you are using firebase in the project
 #-dontwarn io.flutter.embedding.**
 #-ignorewarnings

}