import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/weather.dart';
import 'weather_helper.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin.initialize(initializationSettings);

      // Android 13 이상에서 알림 권한 요청
      if (Platform.isAndroid) {
        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
    } catch (e) {
      debugPrint('Notification Service 초기화 실패: $e');
    }
  }

  Future<void> showWeatherNotification(Weather weather) async {
    try {
      final String contentTitle = '${weather.locationName} (${WeatherHelper.getDescription(weather.weatherCode)})';
      final String contentText = 
          '현재: ${weather.temperature.round()}° (최저: ${weather.minTemp.round()}° / 최고: ${weather.maxTemp.round()}°)';

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'weather_channel',
        '날씨 알림',
        channelDescription: '현재 날씨 정보를 상태바에 표시합니다.',
        importance: Importance.low, // 소리 없이 조용히 표시
        priority: Priority.low,
        ongoing: true, // 사용자가 지울 수 없는 지속 알림
        showWhen: false,
        onlyAlertOnce: true,
        icon: '@mipmap/ic_launcher',
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        0,
        contentTitle,
        contentText,
        platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('알림 표시 실패: $e');
    }
  }

  Future<void> cancelNotification() async {
    await _notificationsPlugin.cancel(0);
  }
}
