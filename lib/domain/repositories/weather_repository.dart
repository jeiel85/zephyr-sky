import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(double lat, double lon, String locationName);
  Future<List<dynamic>> searchLocation(String query, {String language = 'ko'});
  Future<Weather?> getCachedWeather();
  Future<void> saveWeatherToCache(Weather weather);
}
