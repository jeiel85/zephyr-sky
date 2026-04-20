import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel({
    required super.temperature,
    required super.weatherCode,
    required super.humidity,
    required super.windSpeed,
    required super.apparentTemperature,
    required super.isDay,
    required super.maxTemp,
    required super.minTemp,
    required super.locationName,
    required super.time,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String locationName) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      humidity: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      isDay: (current['is_day'] as num) == 1,
      maxTemp: (daily['temperature_2m_max'][0] as num).toDouble(),
      minTemp: (daily['temperature_2m_min'][0] as num).toDouble(),
      locationName: locationName,
      time: DateTime.parse(current['time'] as String),
    );
  }
}
