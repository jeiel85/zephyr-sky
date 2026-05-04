import '../entities/weather.dart';

/// 캐시된 날씨 정보
class CachedWeatherInfo {
  final Weather weather;
  final DateTime cachedTime;
  final bool isExpired;

  CachedWeatherInfo({
    required this.weather,
    required this.cachedTime,
    required this.isExpired,
  });
}

abstract class WeatherRepository {
  Future<Weather> getWeather(double lat, double lon, String locationName);
  Future<List<dynamic>> searchLocation(String query, {String language = 'ko'});
  Future<Weather?> getCachedWeather();
  Future<CachedWeatherInfo?> getCachedWeatherWithInfo();
  Future<void> saveWeatherToCache(Weather weather);

  // 마지막으로 본 위치 정보 저장 및 불러오기
  Future<void> saveLastLocation(double lat, double lon, String name);
  Future<Map<String, dynamic>?> getLastLocation();
}
