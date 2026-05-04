import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zephyr_sky/data/repositories/weather_repository_impl.dart';
import 'package:zephyr_sky/data/sources/weather_api_source.dart';
import 'package:zephyr_sky/domain/entities/weather.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('WeatherRepositoryImpl', () {
    late MockHttpClient mockClient;
    late WeatherApiSource apiSource;
    late WeatherRepositoryImpl repository;
    late SharedPreferences prefs;

    final weatherJson = {
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

    setUp(() async {
      mockClient = MockHttpClient();
      apiSource = WeatherApiSource(mockClient);
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repository = WeatherRepositoryImpl(apiSource, prefs);
      registerFallbackValue(Uri());
    });

    group('getWeather', () {
      test('fetches weather, caches it, and saves location', () async {
        when(() => mockClient.get(any()))
            .thenAnswer((_) async => http.Response(json.encode(weatherJson), 200));

        final weather = await repository.getWeather(37.57, 126.98, 'Seoul');

        expect(weather.locationName, 'Seoul');
        expect(weather.temperature, 25.0);

        // Verify cache
        final cached = await repository.getCachedWeather();
        expect(cached, isNotNull);
        expect(cached!.locationName, 'Seoul');

        // Verify last location
        final location = await repository.getLastLocation();
        expect(location!['name'], 'Seoul');
        expect(location['lat'], 37.57);
        expect(location['lon'], 126.98);
      });
    });

    group('getCachedWeather', () {
      test('returns null when no cache exists', () async {
        final cached = await repository.getCachedWeather();
        expect(cached, isNull);
      });

      test('returns cached weather', () async {
        final weather = Weather(
          temperature: 25.0,
          weatherCode: 0,
          humidity: 60.0,
          windSpeed: 10.0,
          apparentTemperature: 27.0,
          isDay: true,
          maxTemp: 28.0,
          minTemp: 20.0,
          locationName: 'Seoul',
          time: DateTime(2026, 4, 22, 12, 0),
          hourlyForecast: [],
          dailyForecast: [],
        );

        await repository.saveWeatherToCache(weather);
        final cached = await repository.getCachedWeather();

        expect(cached, isNotNull);
        expect(cached!.temperature, 25.0);
        expect(cached.locationName, 'Seoul');
      });

      test('returns null for malformed cache data', () async {
        await prefs.setString('cached_weather', 'invalid-json');
        final cached = await repository.getCachedWeather();
        expect(cached, isNull);
      });
    });

    group('getCachedWeatherWithInfo', () {
      test('returns non-expired for fresh cache', () async {
        final weather = Weather(
          temperature: 25.0,
          weatherCode: 0,
          humidity: 60.0,
          windSpeed: 10.0,
          apparentTemperature: 27.0,
          isDay: true,
          maxTemp: 28.0,
          minTemp: 20.0,
          locationName: 'Seoul',
          time: DateTime(2026, 4, 22, 12, 0),
          hourlyForecast: [],
          dailyForecast: [],
        );

        await repository.saveWeatherToCache(weather);

        final info = await repository.getCachedWeatherWithInfo();
        expect(info, isNotNull);
        expect(info!.isExpired, false);
        expect(info.weather.locationName, 'Seoul');
      });

      test('returns expired for old cache', () async {
        final weather = Weather(
          temperature: 25.0,
          weatherCode: 0,
          humidity: 60.0,
          windSpeed: 10.0,
          apparentTemperature: 27.0,
          isDay: true,
          maxTemp: 28.0,
          minTemp: 20.0,
          locationName: 'Seoul',
          time: DateTime(2026, 4, 22, 12, 0),
          hourlyForecast: [],
          dailyForecast: [],
        );

        await repository.saveWeatherToCache(weather);
        // Override timestamp to 60 minutes ago
        final oldTime = DateTime.now().millisecondsSinceEpoch - 60 * 60 * 1000;
        await prefs.setInt('cached_weather_timestamp', oldTime);

        final info = await repository.getCachedWeatherWithInfo();
        expect(info!.isExpired, true);
      });

      test('returns null when cache is missing', () async {
        final info = await repository.getCachedWeatherWithInfo();
        expect(info, isNull);
      });
    });

    group('saveWeatherToCache', () {
      test('stores weather and timestamp', () async {
        final weather = Weather(
          temperature: 25.0,
          weatherCode: 0,
          humidity: 60.0,
          windSpeed: 10.0,
          apparentTemperature: 27.0,
          isDay: true,
          maxTemp: 28.0,
          minTemp: 20.0,
          locationName: 'Seoul',
          time: DateTime(2026, 4, 22, 12, 0),
          hourlyForecast: [],
          dailyForecast: [],
        );

        await repository.saveWeatherToCache(weather);

        expect(prefs.getString('cached_weather'), isNotNull);
        expect(prefs.getInt('cached_weather_timestamp'), isNotNull);
      });
    });

    group('saveLastLocation / getLastLocation', () {
      test('saves and retrieves location', () async {
        await repository.saveLastLocation(37.57, 126.98, 'Seoul');
        final location = await repository.getLastLocation();

        expect(location!['lat'], 37.57);
        expect(location['lon'], 126.98);
        expect(location['name'], 'Seoul');
      });

      test('returns null when no location saved', () async {
        final location = await repository.getLastLocation();
        expect(location, isNull);
      });

      test('returns null for malformed location data', () async {
        await prefs.setString('last_location', 'invalid');
        final location = await repository.getLastLocation();
        expect(location, isNull);
      });
    });

    group('searchLocation', () {
      test('delegates to api source', () async {
        when(() => mockClient.get(any()))
            .thenAnswer((_) async => http.Response(json.encode({'results': []}), 200));

        final results = await repository.searchLocation('Seoul');
        expect(results, isEmpty);
      });
    });
  });
}
