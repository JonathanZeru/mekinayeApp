import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

import '../config/config_preference.dart';
import '../controller/firebase/fcm_token_controller.dart';
import '../model/user.dart';
import '../screen/message/message_screen.dart';
import '../util/app_constants.dart';
import 'api_service.dart';

class FirebaseService {
  /// Using firebase doc
  ///https://firebase.google.com/docs/flutter/setup?platform=android
  ///https://firebase.google.com/docs/cli#setup_update_cli
  ///https://firebase.google.com/docs/cloud-messaging/flutter/receive
  ///https://www.youtube.com/watch?v=BVZ160KG5Kc&list=PLFyjjoCMAPtzvnHnby5Yu9idvwqXI-ujn&index=6
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
      "high_importance_channel", 'High Importance Notifications',
      description: "This channel is used for important notifications",
      importance: Importance.high);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future init(bool isLoggedIn) async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    // Logger().i('User granted permission: ${settings.authorizationStatus}');

    /// Handle background messages by registering a onBackgroundMessage handler.
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    ///initialize local notification before using it
    initLocalNotifications();
    print("Foreground");

    /// To handle messages while your application is in the foreground, listen to the onMessage stream.
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      Logger().i("Foreground Notification ${notification?.title}");
      if (notification == null) return;
      Logger().i("Foreground Notification IS NOT NULL}");

      Future.delayed(Duration.zero, () {
        _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              // android: AndroidNotificationDetails(
              //     _androidChannel.id, _androidChannel.name,
              //     channelDescription: _androidChannel.description,
              //     importance: Importance.high,
              //     priority: Priority.max,
              //     icon: '@drawable/ic_launcher',),

              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                importance: Importance.high,
                priority: Priority.max,
                icon: '@mipmap/ic_launcher',
                sound: RawResourceAndroidNotificationSound(
                    'notification_sound'), // Custom sound
                playSound: true,
                enableVibration: true, // Enable vibration
                vibrationPattern: Int64List.fromList(
                    [0, 500, 500, 500]), // Custom vibration pattern
              ),
            ),
            payload: jsonEncode(message.toMap()));
      });
    });

    /// If your app is opened via a notification whilst the app is terminated,
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    /// If the application has been opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.instance.getToken().then((token) {
      Logger().i("FCM Token: $token");
      print("FCM Token: $token");
      if (isLoggedIn) {
        final userProfile = ConfigPreference.getUserProfile();
        registerFCMToken(userProfile['id']);
      }

      /// Store the token on your server for sending targeted messages
    });
  }

  Future initLocalNotifications() async {
    // Android initialization settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // Combine both Android and iOS initialization settings
    const setting = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    // Initialize local notifications
    await _localNotifications.initialize(
      setting,
      onDidReceiveNotificationResponse: (payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload as String));
        handleMessage(message);
      },
    );

    // Request notifications permission on iOS
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.requestNotificationsPermission();

    // Create the notification channel for Android
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<String> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  void registerFCMToken(int userId) async {
    final fcmToken = await getFCMToken();
    Map<String, dynamic> body = {"userId": userId, "fcmToken": fcmToken};

    await ApiService.safeApiCall(
      "${AppConstants.url}/users/update-token",
      RequestType.post,
      data: body,
      onLoading: () {},
      onSuccess: (response) {},
      onError: (error) {},
    );
  }
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  Logger().i("Handling a background message: ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

///for opening app from push notification
@pragma('vm:entry-point')
void handleMessage(RemoteMessage? message) {
  print("========== push notification");
  print("========== message = $message");
  if (message == null) return;
  Logger().i("Opening app form message = ${message.data}");
  // Extract relevant data from the message payload to pass to the message screen

  // Get.to(() => MessagingScreen(ownerId: message.data['senderId'], owner: User()));
  // final messageId = message.data['messageId']; // Adjust this key based on your payload
  // // Navigate to the MessageScreen or appropriate screen
  final data = message.data;
  print(message.data);
  final arguments = {
    'ownerId': data['senderId'],
    'owner': UserModel(),
    'text': data['text'],
    'imageUrl': data['imageUrl'],
    'audioUrl': data['audioUrl'],
    'senderId': data['senderId'],
    'receiverId': data['receiverId'],
    'senderUsername': data['senderUsername'],
    'receiverUsername': data['receiverUsername'],
    'createdAt': DateTime.parse(data['createdAt']),
    'updatedAt': DateTime.parse(data['updatedAt']),
    'isFromNotification': true
  };

  navigatorKey.currentState?.pushNamed(
    '/messageScreen',
    arguments: arguments,
  );

  // navigatorKey.currentState?.pushNamed(AppRoutes.splash);
}
