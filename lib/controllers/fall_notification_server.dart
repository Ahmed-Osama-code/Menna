import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Screens/fall_detection_screen.dart';

class FallNotificationService {
  static final FallNotificationService _instance = FallNotificationService._internal();
  factory FallNotificationService() => _instance;
  FallNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/logo');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showFallDetected({required DateTime time}) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'fall_detection_channel',
      'Fall Detection',
      channelDescription: 'Notifications for fall detection events',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound'),
      fullScreenIntent: true,
      autoCancel: false,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
    );

    // iOS:
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      '🚨 FALL DETECTED!',
      'A fall was detected at ${time.hour}:${time.minute.toString().padLeft(2,'0')}',
      notificationDetails,
      payload: 'fall_detected:${time.toIso8601String()}',
    );

    // Show overlay screen
    Get.to(() => FallDetectionScreen(fallCount: 0, fallTime: time));
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.startsWith('fall_detected')) {
      final parts = payload.split(':');
      final time = DateTime.parse(parts[1]);
      Get.to(() => FallDetectionScreen(fallCount: 0, fallTime: time));
    }
  }
}




/* prevent from spam notification :
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Screens/fall_detection_screen.dart';

class FallNotificationService {
  static final FallNotificationService _instance =
      FallNotificationService._internal();
  factory FallNotificationService() => _instance;
  FallNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ================= Anti-Spam =================
  DateTime? _lastFallNotificationTime;
  bool _fallScreenOpen = false;

  // ⏱️ Cooldown duration
  static const Duration fallCooldown = Duration(seconds: 30);

  // ================= INIT =================
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/logo');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // ================= SHOW FALL =================
  Future<void> showFallDetected({required DateTime time}) async {
    // 🚫 Cooldown check (prevent spam)
    if (_lastFallNotificationTime != null) {
      final diff = time.difference(_lastFallNotificationTime!);
      if (diff < fallCooldown) {
        debugPrint("⏳ Fall notification suppressed (cooldown active)");
        return;
      }
    }
    _lastFallNotificationTime = time;

    // ---------- Android Details ----------
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fall_detection_channel',
      'Fall Detection',
      channelDescription: 'Notifications for fall detection events',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('alert_sound'),
      fullScreenIntent: true,
      autoCancel: false,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
    );

    // ---------- iOS Details ----------
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // ---------- Show Notification ----------
    await flutterLocalNotificationsPlugin.show(
      0,
      '🚨 FALL DETECTED!',
      'A fall was detected at ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
      notificationDetails,
      payload: 'fall_detected:${time.toIso8601String()}',
    );

    // ---------- Open Overlay Screen (once) ----------
    if (_fallScreenOpen) {
      debugPrint("🪟 Fall screen already open, skipping navigation");
    } else {
      _fallScreenOpen = true;
      Get.to(() => FallDetectionScreen(
            fallCount: 0,
            fallTime: time,
          ))?.then((_) {
        _fallScreenOpen = false;
      });
    }
  }

  // ================= HANDLE TAP =================
  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.startsWith('fall_detected')) {
      final parts = payload.split(':');
      final time = DateTime.parse(parts[1]);

      if (_fallScreenOpen) return;

      _fallScreenOpen = true;
      Get.to(() => FallDetectionScreen(
            fallCount: 0,
            fallTime: time,
          ))?.then((_) {
        _fallScreenOpen = false;
      });
    }
  }
}

 */



















