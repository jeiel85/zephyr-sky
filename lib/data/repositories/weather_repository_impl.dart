import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../sources/weather_api_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiSource _apiSource;

  WeatherRepositoryImpl(this._apiSource);

  @override
  Future<Weather> getWeather(double lat, double lon, String locationName) {
    return _apiSource.fetchWeather(lat, lon, locationName);
  }

  @override
  Future<Map<String, dynamic>> searchLocation(String query) {
    return _apiSource.searchLocation(query);
  }
}
