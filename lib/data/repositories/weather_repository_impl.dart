import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../sources/weather_api_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiSource _apiSource;
  final SharedPreferences _prefs;
  static const String _cacheKey = 'cached_weather';

  WeatherRepositoryImpl(this._apiSource, this._prefs);

  @override
  Future<Weather> getWeather(double lat, double lon, String locationName) async {
    final weather = await _apiSource.fetchWeather(lat, lon, locationName);
    await saveWeatherToCache(weather);
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
  Future<void> saveWeatherToCache(Weather weather) async {
    final jsonString = json.encode(weather.toMap());
    await _prefs.setString(_cacheKey, jsonString);
  }
}
