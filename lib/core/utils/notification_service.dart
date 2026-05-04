import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/weather.dart';
import 'weather_helper.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // 알림 채널 ID
  static const String _weatherChannelId = 'weather_channel';
  static const String _weatherChannelName = '날씨 알림';
  static const String _alertChannelId = 'weather_alert';
  static const String _alertChannelName = '날씨 경고';

  // 임계값 설정
  static const double _highWindThreshold = 50.0; // km/h
  static const double _lowTempThreshold = -10.0; // °C
  static const double _highTempThreshold = 35.0; // °C
  static const double _heavyRainThreshold = 80.0; // mm/h

  Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin.initialize(initializationSettings);

      // 채널을 명시적으로 생성 (runApp 이전 시점에서는 권한 요청 안 함)
      await _createChannels();
    } catch (e) {
      debugPrint('Notification Service 초기화 실패: $e');
    }
  }

  // 알림 채널 명시적 생성 (Android 8+에서 필수)
  Future<void> _createChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _weatherChannelId,
        _weatherChannelName,
        description: '현재 날씨 정보를 상태바에 표시합니다.',
        importance: Importance.low, // 상태바 아이콘 표시를 위한 최소 중요도
        showBadge: false,
        playSound: false,
        enableVibration: false,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _alertChannelId,
        _alertChannelName,
        description: '날씨 경고 알림을 표시합니다.',
        importance: Importance.high,
      ),
    );
  }

  // Android 13+ 알림 권한 요청
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return true;
      
      final granted = await androidPlugin.requestNotificationsPermission();
      debugPrint('Notification Permission Granted: $granted');
      return granted ?? false;
    } catch (e) {
      debugPrint('Permission Request Error: $e');
      return false;
    }
  }

  // 현재 알림 권한 여부 확인
  Future<bool> areNotificationsEnabled() async {
    if (!Platform.isAndroid) return true;
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return true;
      
      final enabled = await androidPlugin.areNotificationsEnabled();
      return enabled ?? false;
    } catch (e) {
      debugPrint('Check Permission Error: $e');
      return false;
    }
  }

  Future<void> showWeatherNotification(Weather weather) async {
    try {
      // 권한 확인 (Android 13+)
      final hasPermission = await areNotificationsEnabled();
      if (!hasPermission) {
        debugPrint('알림 권한 없음: 상태바 알림을 표시할 수 없습니다.');
        return;
      }

      final String contentTitle = '${weather.locationName} (${WeatherHelper.getDescription(weather.weatherCode)})';
      final String contentText =
          '현재: ${weather.temperature.round()}° (최저: ${weather.minTemp.round()}° / 최고: ${weather.maxTemp.round()}°)';

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        _weatherChannelId,
        _weatherChannelName,
        channelDescription: '현재 날씨 정보를 상태바에 표시합니다.',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        showWhen: false,
        onlyAlertOnce: true,
        icon: '@mipmap/ic_launcher',
        // 알림 클릭 시 앱으로 이동하도록 설정 (필요시 추가)
        category: AndroidNotificationCategory.status,
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        0,
        contentTitle,
        contentText,
        platformChannelSpecifics,
      );
      
      // 날씨 경고 체크
      await _checkAndShowWeatherAlerts(weather);
    } catch (e) {
      debugPrint('알림 표시 실패: $e');
    }
  }

  // 날씨 경고 체크 및 표시
  Future<void> _checkAndShowWeatherAlerts(Weather weather) async {
    final List<String> alerts = [];
    
    // 강한 바람 경고
    if (weather.windSpeed >= _highWindThreshold) {
      alerts.add('💨 강한 바람 (${weather.windSpeed.round()}km/h)');
    }
    
    // 한파 경고
    if (weather.minTemp <= _lowTempThreshold) {
      alerts.add('❄️ 한파 경보 (${weather.minTemp.round()}°)');
    }
    
    // 고온 경고
    if (weather.maxTemp >= _highTempThreshold) {
      alerts.add('🔥 한열 경보 (${weather.maxTemp.round()}°)');
    }
    
    // 강수 확률이 높은 경우
    if (weather.precipitationProbability != null && weather.precipitationProbability! >= 70) {
      alerts.add('🌧️ 강수 확률 높음 (${weather.precipitationProbability!.round()}%)');
    }
    
    // 대기질 경고
    if (weather.airQualityIndex != null && weather.airQualityIndex! > 100) {
      alerts.add('🌬️ 대기질 ${weather.airQualityLevel} (AQI: ${weather.airQualityIndex})');
    }
    
    // 자외선 경고
    if (weather.uvIndex != null && weather.uvIndex! >= 7) {
      alerts.add('☀️ 자외선 ${weather.uvRiskLevel} (UV: ${weather.uvIndex!.toStringAsFixed(1)})');
    }
    
    // 경고가 있으면 표시
    if (alerts.isNotEmpty) {
      await _showAlertNotification(alerts);
    }
  }

  Future<void> _showAlertNotification(List<String> alerts) async {
    try {
      // 날씨 경고 알림 햅틱 피드백
      HapticFeedback.mediumImpact();
      
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        _alertChannelId,
        _alertChannelName,
        channelDescription: '날씨 경고 알림을 표시합니다.',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        category: AndroidNotificationCategory.alarm,
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        1,
        '⚠️ 날씨 경고',
        alerts.join('\n'),
        platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('경고 알림 표시 실패: $e');
    }
  }

  Future<void> cancelNotification() async {
    await _notificationsPlugin.cancel(0);
  }
  
  Future<void> cancelAlertNotification() async {
    await _notificationsPlugin.cancel(1);
  }
}
