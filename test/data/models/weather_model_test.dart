import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr_sky/data/models/weather_model.dart';

void main() {
  group('WeatherModel.fromJson', () {
    test('parses complete weather data correctly', () {
      final json = {
        'current': {
          'time': '2026-04-22T12:00',
          'temperature_2m': 25.0,
          'relative_humidity_2m': 60.0,
          'apparent_temperature': 27.0,
          'is_day': 1,
          'weather_code': 0,
          'wind_speed_10m': 10.0,
          'uv_index': 5.0,
          'pressure_msl': 1013.0,
          'visibility': 10000.0,
          'dew_point_2m': 12.0,
          'cloud_cover': 30,
        },
        'hourly': {
          'time': ['2026-04-22T12:00', '2026-04-22T13:00'],
          'temperature_2m': [25.0, 26.0],
          'weather_code': [0, 1],
          'precipitation_probability': [10.0, 20.0],
        },
        'daily': {
          'time': ['2026-04-22', '2026-04-23'],
          'temperature_2m_max': [28.0, 29.0],
          'temperature_2m_min': [20.0, 21.0],
          'weather_code': [0, 1],
          'precipitation_probability_max': [10.0, 20.0],
          'uv_index_max': [5.0, 6.0],
          'sunrise': ['2026-04-22T05:30', '2026-04-23T05:29'],
          'sunset': ['2026-04-22T19:00', '2026-04-23T19:01'],
        },
      };

      final model = WeatherModel.fromJson(json, 'Seoul');

      expect(model.temperature, 25.0);
      expect(model.humidity, 60.0);
      expect(model.windSpeed, 10.0);
      expect(model.apparentTemperature, 27.0);
      expect(model.isDay, true);
      expect(model.weatherCode, 0);
      expect(model.maxTemp, 28.0);
      expect(model.minTemp, 20.0);
      expect(model.locationName, 'Seoul');
      expect(model.uvIndex, 5.0);
      expect(model.pressure, 1013.0);
      expect(model.visibility, 10000.0);
      expect(model.dewPoint, 12.0);
      expect(model.cloudCover, 30);
      expect(model.precipitationProbability, 10.0);
      expect(model.hourlyForecast.length, 2);
      expect(model.dailyForecast.length, 2);
      expect(model.sunrise, isNotNull);
      expect(model.sunset, isNotNull);
    });

    test('parses data without optional fields', () {
      final json = {
        'current': {
          'time': '2026-04-22T12:00',
          'temperature_2m': 20.0,
          'relative_humidity_2m': 50.0,
          'apparent_temperature': 20.0,
          'is_day': 0,
          'weather_code': 3,
          'wind_speed_10m': 5.0,
        },
        'hourly': {
          'time': ['2026-04-22T12:00'],
          'temperature_2m': [20.0],
          'weather_code': [3],
        },
        'daily': {
          'time': ['2026-04-22'],
          'temperature_2m_max': [22.0],
          'temperature_2m_min': [18.0],
          'weather_code': [3],
        },
      };

      final model = WeatherModel.fromJson(json, 'Busan');

      expect(model.temperature, 20.0);
      expect(model.isDay, false);
      expect(model.uvIndex, isNull);
      expect(model.pressure, isNull);
      expect(model.visibility, isNull);
      expect(model.dewPoint, isNull);
      expect(model.cloudCover, isNull);
      expect(model.precipitationProbability, isNull);
      expect(model.sunrise, isNull);
      expect(model.sunset, isNull);
      expect(model.hourlyForecast.first.precipitationProbability, isNull);
      expect(model.dailyForecast.first.precipitationProbability, isNull);
      expect(model.dailyForecast.first.uvIndex, isNull);
    });

    test('limits hourly forecast to 48 entries', () {
      final times = List.generate(60, (i) => '2026-04-22T${i.toString().padLeft(2, '0')}:00');
      final temps = List.generate(60, (i) => i.toDouble());
      final codes = List.generate(60, (i) => i % 10);

      final json = {
        'current': {
          'time': '2026-04-22T12:00',
          'temperature_2m': 25.0,
          'relative_humidity_2m': 60.0,
          'apparent_temperature': 27.0,
          'is_day': 1,
          'weather_code': 0,
          'wind_speed_10m': 10.0,
        },
        'hourly': {
          'time': times,
          'temperature_2m': temps,
          'weather_code': codes,
        },
        'daily': {
          'time': ['2026-04-22'],
          'temperature_2m_max': [28.0],
          'temperature_2m_min': [20.0],
          'weather_code': [0],
        },
      };

      final model = WeatherModel.fromJson(json, 'Test');
      expect(model.hourlyForecast.length, 48);
    });

    test('limits daily forecast to 16 entries', () {
      final times = List.generate(20, (i) => '2026-04-${(22 + i).toString().padLeft(2, '0')}');
      final maxTemps = List.generate(20, (i) => (25.0 + i).toDouble());
      final minTemps = List.generate(20, (i) => (15.0 + i).toDouble());
      final codes = List.generate(20, (i) => i % 5);

      final json = {
        'current': {
          'time': '2026-04-22T12:00',
          'temperature_2m': 25.0,
          'relative_humidity_2m': 60.0,
          'apparent_temperature': 27.0,
          'is_day': 1,
          'weather_code': 0,
          'wind_speed_10m': 10.0,
        },
        'hourly': {
          'time': ['2026-04-22T12:00'],
          'temperature_2m': [25.0],
          'weather_code': [0],
        },
        'daily': {
          'time': times,
          'temperature_2m_max': maxTemps,
          'temperature_2m_min': minTemps,
          'weather_code': codes,
        },
      };

      final model = WeatherModel.fromJson(json, 'Test');
      expect(model.dailyForecast.length, 16);
    });

    test('handles empty sunrise/sunset gracefully', () {
      final json = {
        'current': {
          'time': '2026-04-22T12:00',
          'temperature_2m': 25.0,
          'relative_humidity_2m': 60.0,
          'apparent_temperature': 27.0,
          'is_day': 1,
          'weather_code': 0,
          'wind_speed_10m': 10.0,
        },
        'hourly': {
          'time': ['2026-04-22T12:00'],
          'temperature_2m': [25.0],
          'weather_code': [0],
        },
        'daily': {
          'time': ['2026-04-22'],
          'temperature_2m_max': [28.0],
          'temperature_2m_min': [20.0],
          'weather_code': [0],
          'sunrise': [],
          'sunset': [],
        },
      };

      final model = WeatherModel.fromJson(json, 'Test');
      expect(model.sunrise, isNull);
      expect(model.sunset, isNull);
    });
  });
}
