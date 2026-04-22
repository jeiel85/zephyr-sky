import 'package:flutter/material.dart';
import '../../core/utils/weather_helper.dart';

class Weather {
  final double temperature;
  final int weatherCode;
  final double humidity;
  final double windSpeed;
  final double apparentTemperature;
  final bool isDay;
  final double maxTemp;
  final double minTemp;
  final String locationName;
  final DateTime time;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;
  
  // 확장 날씨 데이터
  final int? airQualityIndex;       // AQI (대기질 지수)
  final double? uvIndex;            // 자외선 지수
  final double? precipitationProbability; // 강수 확률 (%)
  final DateTime? sunrise;          // 일출 시간
  final DateTime? sunset;           // 일몰 시간
  final double? pressure;           // 기압 (hPa)
  final double? visibility;         // 시정 (km)
  final double? dewPoint;           // 이슬점 (°C)
  final int? cloudCover;            // 구름량 (%)

  Weather({
    required this.temperature,
    required this.weatherCode,
    required this.humidity,
    required this.windSpeed,
    required this.apparentTemperature,
    required this.isDay,
    required this.maxTemp,
    required this.minTemp,
    required this.locationName,
    required this.time,
    required this.hourlyForecast,
    required this.dailyForecast,
    this.airQualityIndex,
    this.uvIndex,
    this.precipitationProbability,
    this.sunrise,
    this.sunset,
    this.pressure,
    this.visibility,
    this.dewPoint,
    this.cloudCover,
  });

  String get weatherDescription => WeatherHelper.getDescription(weatherCode);
  IconData get weatherIcon => WeatherHelper.getIcon(weatherCode, isDay: isDay);

  /// AQI 등급 반환 (0-500)
  String get airQualityLevel {
    if (airQualityIndex == null) return '알 수 없음';
    final aqi = airQualityIndex!;
    if (aqi <= 50) return '좋음';
    if (aqi <= 100) return '보통';
    if (aqi <= 150) return '민감군 불쾌';
    if (aqi <= 200) return '불건강';
    if (aqi <= 300) return '매우 불건강';
    return '위험';
  }

  /// 자외선 위험 등급 반환
  String get uvRiskLevel {
    if (uvIndex == null) return '알 수 없음';
    final uv = uvIndex!;
    if (uv <= 2) return '낮음';
    if (uv <= 5) return '보통';
    if (uv <= 7) return '높음';
    if (uv <= 10) return '매우 높음';
    return '위험';
  }

  /// 야외 활동 지수 (0-100, 높을수록 좋음)
  int get outdoorActivityScore {
    int score = 100;
    
    // 온도 점수 (-10°C ~ 35°C 최적)
    if (temperature < 0) score -= 40;
    else if (temperature < 10) score -= 20;
    else if (temperature > 35) score -= 40;
    else if (temperature > 30) score -= 20;
    
    // 강수 확률
    if (precipitationProbability != null) {
      score -= (precipitationProbability! * 0.5).round();
    }
    
    // 자외선
    if (uvIndex != null) {
      if (uvIndex! >= 8) score -= 30;
      else if (uvIndex! >= 6) score -= 15;
      else if (uvIndex! >= 3) score -= 5;
    }
    
    // 풍속 (50km/h 이상이면 위험)
    if (windSpeed >= 50) score -= 30;
    else if (windSpeed >= 30) score -= 15;
    
    // 대기질
    if (airQualityIndex != null) {
      if (airQualityIndex! > 150) score -= 30;
      else if (airQualityIndex! > 100) score -= 15;
      else if (airQualityIndex! > 50) score -= 5;
    }
    
    return score.clamp(0, 100);
  }

/// 야외 활동 권장 등급
  String get outdoorActivityLevel {
    final score = outdoorActivityScore;
    if (score >= 80) return '최상';
    if (score >= 60) return '양호';
    if (score >= 40) return '보통';
    if (score >= 20) return '나쁨';
    return '위험';
  }

  /// 야외 활동 추천 메시지
  String get outdoorActivityMessage {
    final score = outdoorActivityScore;
    if (score >= 80) return '야외 활동하기 좋은 날씨입니다!';
    if (score >= 60) return '평소보다 양호합니다';
    if (score >= 40) return '야외 활동 시 주의가 필요합니다';
    if (score >= 20) return '야외 활동에 권장하지 않습니다';
    return '야외 활동을 자제해 주세요';
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'weatherCode': weatherCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'apparentTemperature': apparentTemperature,
      'isDay': isDay,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'locationName': locationName,
      'time': time.toIso8601String(),
      'hourlyForecast': hourlyForecast.map((x) => x.toMap()).toList(),
      'dailyForecast': dailyForecast.map((x) => x.toMap()).toList(),
      'airQualityIndex': airQualityIndex,
      'uvIndex': uvIndex,
      'precipitationProbability': precipitationProbability,
      'sunrise': sunrise?.toIso8601String(),
      'sunset': sunset?.toIso8601String(),
      'pressure': pressure,
      'visibility': visibility,
      'dewPoint': dewPoint,
      'cloudCover': cloudCover,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      temperature: map['temperature']?.toDouble() ?? 0.0,
      weatherCode: map['weatherCode']?.toInt() ?? 0,
      humidity: map['humidity']?.toDouble() ?? 0.0,
      windSpeed: map['windSpeed']?.toDouble() ?? 0.0,
      apparentTemperature: map['apparentTemperature']?.toDouble() ?? 0.0,
      isDay: map['isDay'] ?? true,
      maxTemp: map['maxTemp']?.toDouble() ?? 0.0,
      minTemp: map['minTemp']?.toDouble() ?? 0.0,
      locationName: map['locationName'] ?? '',
      time: DateTime.parse(map['time']),
      hourlyForecast: List<HourlyWeather>.from(
        map['hourlyForecast']?.map((x) => HourlyWeather.fromMap(x)) ?? [],
      ),
      dailyForecast: List<DailyWeather>.from(
        map['dailyForecast']?.map((x) => DailyWeather.fromMap(x)) ?? [],
      ),
      airQualityIndex: map['airQualityIndex']?.toInt(),
      uvIndex: map['uvIndex']?.toDouble(),
      precipitationProbability: map['precipitationProbability']?.toDouble(),
      sunrise: map['sunrise'] != null ? DateTime.parse(map['sunrise']) : null,
      sunset: map['sunset'] != null ? DateTime.parse(map['sunset']) : null,
      pressure: map['pressure']?.toDouble(),
      visibility: map['visibility']?.toDouble(),
      dewPoint: map['dewPoint']?.toDouble(),
      cloudCover: map['cloudCover']?.toInt(),
    );
  }
}

class HourlyWeather {
  final DateTime time;
  final double temperature;
  final int weatherCode;
  final double? precipitationProbability; // 시간대별 강수 확률

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    this.precipitationProbability,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'temperature': temperature,
      'weatherCode': weatherCode,
      'precipitationProbability': precipitationProbability,
    };
  }

  factory HourlyWeather.fromMap(Map<String, dynamic> map) {
    return HourlyWeather(
      time: DateTime.parse(map['time']),
      temperature: map['temperature']?.toDouble() ?? 0.0,
      weatherCode: map['weatherCode']?.toInt() ?? 0,
      precipitationProbability: map['precipitationProbability']?.toDouble(),
    );
  }
}

class DailyWeather {
  final DateTime time;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;
  final double? precipitationProbability; // 일별 강수 확률
  final double? uvIndex;                  // 일별 UV 지수

  DailyWeather({
    required this.time,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
    this.precipitationProbability,
    this.uvIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'weatherCode': weatherCode,
      'precipitationProbability': precipitationProbability,
      'uvIndex': uvIndex,
    };
  }

  factory DailyWeather.fromMap(Map<String, dynamic> map) {
    return DailyWeather(
      time: DateTime.parse(map['time']),
      maxTemp: map['maxTemp']?.toDouble() ?? 0.0,
      minTemp: map['minTemp']?.toDouble() ?? 0.0,
      weatherCode: map['weatherCode']?.toInt() ?? 0,
      precipitationProbability: map['precipitationProbability']?.toDouble(),
      uvIndex: map['uvIndex']?.toDouble(),
    );
  }
}
