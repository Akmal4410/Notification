import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationServices {
  LocalNotificationServices();

  // initialise the flutter_local_notification
  final localNotificationServices = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  // create a method to initialize (localNotification)
  Future<void> initilize() async {
    tz.initializeTimeZones();
    // initialise android settings
    const AndroidInitializationSettings androidInitializationSetting =
        AndroidInitializationSettings('@drawable/icon');

    // initialise ios settings
    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    // initialize settinh
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSettings,
    );

    await localNotificationServices.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    log('id : $id');
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    log(details.payload.toString());
    if (details.payload != null && details.payload!.isEmpty) {
      onNotificationClick.add(details.payload);
    }
  }

  /////////////////////////////////////////////////////////////////////

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await localNotificationServices.show(id, title, body, details);
  }

  Future<void> showPayloadNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = await _notificationDetails();
    await localNotificationServices.show(id, title, body, details,
        payload: payload);
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final details = await _notificationDetails();
    await localNotificationServices.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
          DateTime.now().add(Duration(seconds: seconds)), tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
