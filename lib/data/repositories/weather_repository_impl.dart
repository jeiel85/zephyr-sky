import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../sources/weather_api_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiSource _apiSource;
  final SharedPreferences _prefs;
  static const String _cacheKey = 'cached_weather';
  static const String _lastLocationKey = 'last_location';
  static const String _cacheTimestampKey = 'cached_weather_timestamp';
  
  // 캐시 유효 시간: 30분
  static const int _cacheValidityMinutes = 30;

  WeatherRepositoryImpl(this._apiSource, this._prefs);

  @override
  Future<Weather> getWeather(double lat, double lon, String locationName) async {
    // 1. 날씨 정보 가져오기
    final weather = await _apiSource.fetchWeather(lat, lon, locationName);
    
    // 2. 날씨 데이터 캐싱
    await saveWeatherToCache(weather);
    
    // 3. 마지막 성공한 위치 정보 저장
    await saveLastLocation(lat, lon, locationName);
    
    return weather;
  }

  @override
  Future<List<dynamic>> searchLocation(String query, {String language = 'ko'}) {
    return _apiSource.searchLocation(query, language: language);
  }

  @override
  Future<Weather?> getCachedWeather() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> map = json.decode(jsonString);
        return Weather.fromMap(map);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
  
  @override
  Future<CachedWeatherInfo?> getCachedWeatherWithInfo() async {
    final jsonString = _prefs.getString(_cacheKey);
    final timestamp = _prefs.getInt(_cacheTimestampKey);
    
    if (jsonString != null && timestamp != null) {
      try {
        final Map<String, dynamic> map = json.decode(jsonString);
        final weather = Weather.fromMap(map);
        final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final isExpired = DateTime.now().difference(cachedTime).inMinutes > _cacheValidityMinutes;
        
        return CachedWeatherInfo(
          weather: weather,
          cachedTime: cachedTime,
          isExpired: isExpired,
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveWeatherToCache(Weather weather) async {
    final jsonString = json.encode(weather.toMap());
    await _prefs.setString(_cacheKey, jsonString);
    await _prefs.setInt(_cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<void> saveLastLocation(double lat, double lon, String name) async {
    final locationData = {
      'lat': lat,
      'lon': lon,
      'name': name,
    };
    await _prefs.setString(_lastLocationKey, json.encode(locationData));
  }

  @override
  Future<Map<String, dynamic>?> getLastLocation() async {
    final jsonString = _prefs.getString(_lastLocationKey);
    if (jsonString != null) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
