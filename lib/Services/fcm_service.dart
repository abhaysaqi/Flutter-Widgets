import 'dart:convert';
import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initializeNotification() async {
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
        if (message.data['type'] == 'call') {
          String callerName = message.data['callerName']!;
          String channelId = message.data['channelId']!;
          await showIncomingCall(message);
        } // CallKit-style incoming call UI
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("Notification tapped: ${message.notification?.title}");
        // Handle navigation here if needed
      });
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   if (message.data['type'] == 'call') {
      //     String callerName = message.data['callerName']!;
      //     String channelId = message.data['channelId']!;

      //     // Show your incoming call UI or use FlutterCallkitIncoming
      //     showIncomingCallUI(callerName, channelId);
      //   }
      // });

      await _getInitialNotification();

      // CallKit Event Listener
      FlutterCallkitIncoming.onEvent.listen((event) {
        if (event == null) return;
        switch (event.event) {
          case Event.actionCallAccept:
            debugPrint("Call Accepted");
            break;
          case Event.actionCallDecline:
            debugPrint("Call Declined");
            break;
          case Event.actionCallEnded:
            debugPrint("Call Ended");
            break;
          case Event.actionCallIncoming:
            debugPrint("Notification Clicked");

            final channelId = event.body['channelId'];

            // Navigate to screen with Accept/Decline buttons

            break;
          default:
            debugPrint("Unhandled CallKit Event: ${event.event}");
            break;
        }
      });
    }
  }

  static Future<void> _getInitialNotification() async {
    RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      debugPrint(
        "App opened via terminated state notification: ${remoteMessage.notification?.title}",
      );
      if (remoteMessage.data['type'] == 'call') {
        await showIncomingCall(remoteMessage);
      }
    }
  }

  static Future<void> showIncomingCall(RemoteMessage message) async {
    CallKitParams callKitParams = CallKitParams(
      id: Uuid().v4(),
      nameCaller: message.data['callerName']! ?? 'Unknown Caller',
      appName: 'Your App Name',
      avatar: 'https://i.pravatar.cc/100',
      handle: 'Caller ID',
      type: 1, // 0 = audio, 1 = video
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Calling...',
        callbackText: 'Hang Up',
      ),
      extra: <String, dynamic>{'userId': message.data['userId'] ?? 'unknown'},
      headers: <String, dynamic>{'apiKey': 'abc123', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        logoUrl: 'https://i.pravatar.cc/100',
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'https://i.pravatar.cc/500',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "Incoming Call",
        missedCallNotificationChannelName: "Missed Call",
        isShowCallID: false,
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint(
      "Background notification received: ${message.notification?.title}",
    );
    if (message.data['type'] == 'call') {
      await showIncomingCall(message);
    }
  }

  static Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    debugPrint("FCM token deleted");
  }

  static const _url =
      "https://fcm.googleapis.com/v1/projects/simpletest-d20ad/messages:send";
  static late String _accessToken;

  static const _clientEmail =
      'firebase-adminsdk-1sypx@simpletest-d20ad.iam.gserviceaccount.com';
  static const _privateKey =
      "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCmm5x2dTmzAyPl\neMQGkeDacWLi+pPWqvbTOG/PCaGMFpcOQ4/VtAtE0pC7feEumWiyz6uVgWmDLu3z\nhuMBWaZO1+tlzewwLiWSPd6BCo6QOcb5+7Txd91OArVI5+T87rsVpxz532JUJy1c\n/YAXeMVCjPrzW4gwvw3/UvtGcR5ZaFMRWtU1oxUxZsvdoUix5kX9KfAxHNYsjM//\nmRe7oFe+2yhIgO2Q+czqbAxT0rY3cdnc8TIAmKkz69Jh0GT4zJznuCfzWuOmd+xj\nUcqV88NLL0LrNcCKHXJ/9eGhufQ9rJC6AOxG3be/un4wr6hIg6zBPmQiq8K3yvyY\nSz/shO57AgMBAAECggEAFXlTFlWPpUoPU2FYarxcresVYsoHShDpFVpd1uKX5tV2\njMkafeHh3fIB45ia8IWnX/yyUefHMLhYxR2qnp7ud5UO6yU6fw9DmnDM//bbXy2D\nPu85aDIZ3RcuRIJXGl6u0GCktHQdWVlfWG/4FY5kZmqDYeB3Ukkdxb3tUyv7TGyX\nnIIuXEhwapECWi2o6/Fiy2Ku2tOWT3hgCGH17vv+8PzdmzihUAXL0GkJ6qWSK2OT\nN6aLt/l5Dp6xN4iyr+z2nMZG2zND9tjBADhq0ZSc0XfRNWpvlVcUQsKVbRl4vD8P\npjGfPNmUXEUrhOCegfrpgNO1N35FqftuDeQvfP0zUQKBgQDVNtcBTTFZRq77vCpN\nes1+bTMNI/Mmc6DH7OsxJxnvhrPRNhghC+gBNpfeLgzW2TOAE2IGKgUcJ/L//A4X\nFXArpn/Av8KU4dWwyzvygubiDEYaAzPb9+yHNrpP4i2D8fVb8FEmljCkpQ2HjM2Z\nAdqXUvzuZouTrkxo2JeM9oKSGQKBgQDICobkiEHUEjHUdXlu4JemqANtNC8ytLBI\nLcYLpZb8sSS+/ZyjKWtECzUPhGAbxTuyGA+CMj+Cf0vWLdDIu3U3h1Ko7BFRKK81\naY1PwVxkcM54Lmuh9sI4mmYF9BKztMt8B+2dbbv6prybqIQJcGFFztYkkVFlnJHS\nHDDDUj3fswKBgC1a1g+z0PyRuaVZGJKUvePX7NUtwYp7bEc7EajKDY1TVSr629Uj\nyD2B1Hpxx09osrja5q4zABVGNj3X61NjvxG6AFELOaQcCi3qfZ0P1XdebwcXiU+Q\nhKMatDVMAqyfqrbc/xY7Oqu7ZI5iGFYk+8/W2nEIJUbL+/sNn+dfhNT5AoGAIw2V\nLZ6iymKV0MD1EnTQnid60jv+uUfoS/2ZYpkVqBnycnVGaWDspvO/zIRJwxQAreiB\nbzMW5esggttsZoBSvfQ8i9UyA6K5cQaZ+IvNgNwzkeOwgKUYy4pirlBippLbxVQu\nUxPTiMyG6E/TM0Q6B12DMM02EjQpaUP/V3ql1PkCgYA2TR/oqkWpl3+HQ1y/AXR3\nNRKTurpkQZiACgZ5Si4XMqxeaxMF1QAD7koS8hV7bqtMfm/7IK3k65HPybLXXkKn\nFexI272A2NNf/z4xuWI1wbocLa0ODdMtLK9NuMkPoi08CLc8U3iDkGPmWh18w3wY\nc4uqsL1ZFlwjeVTzlj2wbg==\n-----END PRIVATE KEY-----\n";

  /// Get OAuth2 Access Token using Service Account
  static Future<void> getAccessToken() async {
    final iat = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final exp = iat + 3600;

    final jwt = JWT({
      'iss': _clientEmail,
      'sub': _clientEmail,
      'aud': 'https://oauth2.googleapis.com/token',
      'iat': iat,
      'exp': exp,
      'scope': 'https://www.googleapis.com/auth/firebase.messaging',
    });

    final token = jwt.sign(
      RSAPrivateKey(_privateKey),
      algorithm: JWTAlgorithm.RS256,
    );

    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': token,
      },
    );

    if (response.statusCode == 200) {
      // log("RESPONSE" + json.decode(response.body));
      _accessToken = json.decode(response.body)['access_token'];
      log('OAuth2 Token: $_accessToken');
    } else {
      log('Token Error: ${response.body}');
      throw Exception(
        'Failed to get OAuth2 token. Status code: ${response.statusCode}',
      );
    }
  }

  /// Send Push Notification
  static Future<void> sendNotification({
    required String token,
    required String callerName,
    required String channelId,
  }) async {
    await getAccessToken();

    final uri = Uri.parse(_url);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    final body = jsonEncode({
      "message": {
        "token": token,
        "notification": {
          "title": "Incoming Call",
          "body": "$callerName is calling you...",
        },
        "data": {
          "type": "call",
          "callerName": callerName,
          "channelId": channelId,
        },
        "android": {"priority": "HIGH"},
      },
    });

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      log('Notification sent!');
    } else {
      log('Notification failed: ${response.body}');
    }
  }
}
