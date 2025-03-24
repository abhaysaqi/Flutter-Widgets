import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 1.  add firebase_core, firebase_messanging, flutter_local_notifications
// 2.  add followin in android/app/build.gradle---
// compileOptions {
//         coreLibraryDesugaringEnabled true
//         sourceCompatibility = JavaVersion.VERSION_1_8
//         targetCompatibility = JavaVersion.VERSION_1_8
//     }

//     defaultConfig {
//         minSdk = 23
//         targetSdk = 34
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//         multiDexEnabled=true
//     }


// dependencies {
//     coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
// }


// 3. Add these Following lines in AndroiManifest.xml
// <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
// <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

// 4. add followin lines in same file after activity in applicatin section -- 
// <meta-data
//             android:name="flutterEmbedding"
//             android:value="2" />
//             <meta-data android:name="com.google.firebase.messaging.default_notification_icon" android:resource="@mipmap/ic_launcher" />


class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initializeNotification() async {
    // Register background handler first
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final requestPer = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (requestPer.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        await _showFlutterNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // handle notification tap route (Background)
        print("Tapped on Notification: ${message.notification?.title}");
        // TODO: Add your navigation logic here
      });

      await _getFcmToken();
      await _initializeLocalNotification();
      await _getInitialNotification();
    }
  }

  static Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    // TODO: Save this token to your server for targeted push notifications
  }

  static Future<void> _initializeLocalNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // handle notification tap route (Foreground)
        print("Notification tapped: ${details.payload}");
        // TODO: Add your navigation logic here
      },
    );
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification == null) {
      return;
    }

    AndroidNotificationDetails android = const AndroidNotificationDetails(
      'CHANNEL ID',
      'CHANNEL NAME',
      priority: Priority.high,
      importance: Importance.high,
    );

    DarwinNotificationDetails iOS = const DarwinNotificationDetails(
      presentSound: true,
      presentBanner: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  static Future<void> _getInitialNotification() async {
    RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (remoteMessage != null) {
      // handle notification tap route (Kill mode)
      print(
          "App opened from terminated state by notification: ${remoteMessage.notification?.title}");
      // TODO: Add your navigation logic here
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // No need to initialize plugins in background handler now
    // This is already done in main.dart
    debugPrint("Handling background message: ${message.notification?.title}");
    // Note: Don't perform heavy tasks here as it runs in background
  }

  static Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    print("FCM token deleted");
  }
}
