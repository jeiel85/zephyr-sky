import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(double lat, double lon, String locationName);
  Future<List<dynamic>> searchLocation(String query, {String language = 'ko'});
  Future<Weather?> getCachedWeather();
  Future<void> saveWeatherToCache(Weather weather);
  
  // 마지막으로 본 위치 정보 저장 및 불러오기
  Future<void> saveLastLocation(double lat, double lon, String name);
  Future<Map<String, dynamic>?> getLastLocation();
}
