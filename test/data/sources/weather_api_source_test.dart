import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:zephyr_sky/data/sources/weather_api_source.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late WeatherApiSource apiSource;

  setUp(() {
    mockClient = MockHttpClient();
    apiSource = WeatherApiSource(mockClient);
    registerFallbackValue(Uri());
  });

  group('fetchWeather', () {
    final weatherJson = {
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
        'time': ['2026-04-22'],
        'temperature_2m_max': [28.0],
        'temperature_2m_min': [20.0],
        'weather_code': [0],
        'precipitation_probability_max': [10.0],
        'uv_index_max': [5.0],
        'sunrise': ['2026-04-22T05:30'],
        'sunset': ['2026-04-22T19:00'],
      },
    };

    final aqiJson = {
      'current': {
        'european_aqi': 45,
      },
    };

    test('returns WeatherModel on successful response', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(json.encode(weatherJson), 200));

      final result = await apiSource.fetchWeather(37.57, 126.98, 'Seoul');

      expect(result.temperature, 25.0);
      expect(result.weatherCode, 0);
      expect(result.humidity, 60.0);
      expect(result.windSpeed, 10.0);
      expect(result.locationName, 'Seoul');
      expect(result.hourlyForecast.length, 2);
      expect(result.dailyForecast.length, 1);
    });

    test('throws exception on non-200 status', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () => apiSource.fetchWeather(37.57, 126.98, 'Seoul'),
        throwsException,
      );
    });

    test('parses AQI when air quality API succeeds', () async {
      var callCount = 0;
      when(() => mockClient.get(any())).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return http.Response(json.encode(weatherJson), 200);
        }
        return http.Response(json.encode(aqiJson), 200);
      });

      final result = await apiSource.fetchWeather(37.57, 126.98, 'Seoul');
      expect(result.airQualityIndex, 45);
    });

    test('returns weather without AQI when air quality API fails', () async {
      var callCount = 0;
      when(() => mockClient.get(any())).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return http.Response(json.encode(weatherJson), 200);
        }
        return http.Response('Error', 500);
      });

      final result = await apiSource.fetchWeather(37.57, 126.98, 'Seoul');
      expect(result.airQualityIndex, isNull);
      expect(result.temperature, 25.0);
    });

    test('handles missing precipitation probability gracefully', () async {
      final jsonWithoutPrecip = {
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
        },
      };

      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(json.encode(jsonWithoutPrecip), 200));

      final result = await apiSource.fetchWeather(37.57, 126.98, 'Seoul');
      expect(result.precipitationProbability, isNull);
      expect(result.hourlyForecast.first.precipitationProbability, isNull);
    });
  });

  group('searchLocation', () {
    test('returns list of locations on success', () async {
      final searchJson = {
        'results': [
          {'name': 'Seoul', 'latitude': 37.57, 'longitude': 126.98},
          {'name': 'Seoul-si', 'latitude': 37.57, 'longitude': 126.98},
        ],
      };

      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(json.encode(searchJson), 200));

      final results = await apiSource.searchLocation('Seoul');
      expect(results.length, 2);
      expect(results.first['name'], 'Seoul');
    });

    test('returns empty list when no results', () async {
      final searchJson = {'results': null};

      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(json.encode(searchJson), 200));

      final results = await apiSource.searchLocation('xyzabc');
      expect(results, isEmpty);
    });

    test('throws exception on non-200 status', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => apiSource.searchLocation('Seoul'),
        throwsException,
      );
    });

    test('respects language parameter', () async {
      final searchJson = {'results': []};

      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(json.encode(searchJson), 200));

      await apiSource.searchLocation('Seoul', language: 'en');

      final captured = verify(() => mockClient.get(captureAny())).captured;
      final uri = captured.first as Uri;
      expect(uri.queryParameters['language'], 'en');
    });
  });
}
