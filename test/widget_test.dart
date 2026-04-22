import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr_sky/domain/entities/weather.dart';

void main() {
  group('Weather Entity Tests', () {
    test(' Weather creation with basic data', () {
      final weather = Weather(
        temperature: 25.0,
        weatherCode: 0,
        humidity: 60.0,
        windSpeed: 10.0,
        apparentTemperature: 27.0,
        isDay: true,
        maxTemp: 28.0,
        minTemp: 20.0,
        locationName: '서울',
        time: DateTime.now(),
        hourlyForecast: [],
        dailyForecast: [],
      );

      expect(weather.temperature, 25.0);
      expect(weather.locationName, '서울');
      expect(weather.isDay, true);
    });

    test(' AQI level calculation', () {
      final weather = Weather(
        temperature: 25.0,
        weatherCode: 0,
        humidity: 60.0,
        windSpeed: 10.0,
        apparentTemperature: 27.0,
        isDay: true,
        maxTemp: 28.0,
        minTemp: 20.0,
        locationName: '서울',
        time: DateTime.now(),
        hourlyForecast: [],
        dailyForecast: [],
        airQualityIndex: 45,
      );

      expect(weather.airQualityLevel, '좋음');
    });

    test(' AQI level for unhealthy air', () {
      final weather = Weather(
        temperature: 25.0,
        weatherCode: 0,
        humidity: 60.0,
        windSpeed: 10.0,
        apparentTemperature: 27.0,
        isDay: true,
        maxTemp: 28.0,
        minTemp: 20.0,
        locationName: '서울',
        time: DateTime.now(),
        hourlyForecast: [],
        dailyForecast: [],
        airQualityIndex: 180,
      );

      expect(weather.airQualityLevel, '불건강');
    });

    test(' UV risk level calculation', () {
      final weather = Weather(
        temperature: 25.0,
        weatherCode: 0,
        humidity: 60.0,
        windSpeed: 10.0,
        apparentTemperature: 27.0,
        isDay: true,
        maxTemp: 28.0,
        minTemp: 20.0,
        locationName: '서울',
        time: DateTime.now(),
        hourlyForecast: [],
        dailyForecast: [],
        uvIndex: 8.0,
      );

      expect(weather.uvRiskLevel, '매우 높음');
    });

    test(' Outdoor activity score calculation - good conditions', () {
      final weather = Weather(
        temperature: 22.0,
        weatherCode: 0,
        humidity: 50.0,
        windSpeed: 10.0,
        apparentTemperature: 22.0,
        isDay: true,
        maxTemp: 25.0,
        minTemp: 18.0,
        locationName: '서울',
        time: DateTime.now(),
        hourlyForecast: [],
        dailyForecast: [],
        uvIndex: 3.0,
        precipitationProbability: 10.0,
        airQualityIndex: 30,
      );

      expect(weather.outdoorActivityScore, greaterThanOrEqualTo(70));
      expect(weather.outdoorActivityLevel, anyOf('최상', '양호'));
    });

    test(' Outdoor activity score calculation - bad conditions', () {
      final weather = Weather(
        temperature: -5.0,
        weatherCode: 71, // Snow
        humidity: 90.0,
        windSpeed: 55.0,
        apparentTemperature: -15.0,
        isDay: true,
        maxTemp: 0.0,
        minTemp: -10.0,
        locationName: '서울',
        time: DateTime.now(),
        hourlyForecast: [],
        dailyForecast: [],
        uvIndex: 1.0,
        precipitationProbability: 90.0,
        airQualityIndex: 180,
      );

      expect(weather.outdoorActivityScore, lessThan(30));
      expect(weather.outdoorActivityLevel, '위험');
    });

    test(' Weather serialization and deserialization', () {
      final weather = Weather(
        temperature: 25.0,
        weatherCode: 0,
        humidity: 60.0,
        windSpeed: 10.0,
        apparentTemperature: 27.0,
        isDay: true,
        maxTemp: 28.0,
        minTemp: 20.0,
        locationName: '서울',
        time: DateTime(2026, 4, 22, 12, 0),
        hourlyForecast: [
          HourlyWeather(
            time: DateTime(2026, 4, 22, 13, 0),
            temperature: 26.0,
            weatherCode: 0,
            precipitationProbability: 10.0,
          ),
        ],
        dailyForecast: [
          DailyWeather(
            time: DateTime(2026, 4, 22),
            maxTemp: 28.0,
            minTemp: 20.0,
            weatherCode: 0,
            precipitationProbability: 10.0,
            uvIndex: 5.0,
          ),
        ],
        airQualityIndex: 45,
        uvIndex: 5.0,
        precipitationProbability: 10.0,
        sunrise: DateTime(2026, 4, 22, 5, 30),
        sunset: DateTime(2026, 4, 22, 19, 0),
        pressure: 1013.0,
        visibility: 10000.0,
        dewPoint: 12.0,
        cloudCover: 30,
      );

      final map = weather.toMap();
      final restored = Weather.fromMap(map);

      expect(restored.temperature, weather.temperature);
      expect(restored.locationName, weather.locationName);
      expect(restored.airQualityIndex, weather.airQualityIndex);
      expect(restored.uvIndex, weather.uvIndex);
      expect(restored.hourlyForecast.length, 1);
      expect(restored.dailyForecast.length, 1);
    });

    test(' HourlyWeather with precipitation probability', () {
      final hourly = HourlyWeather(
        time: DateTime(2026, 4, 22, 15, 0),
        temperature: 25.0,
        weatherCode: 61, // Rain
        precipitationProbability: 80.0,
      );

      expect(hourly.precipitationProbability, 80.0);
      expect(hourly.weatherCode, 61);

      final map = hourly.toMap();
      final restored = HourlyWeather.fromMap(map);

      expect(restored.precipitationProbability, 80.0);
    });

    test(' DailyWeather with UV index', () {
      final daily = DailyWeather(
        time: DateTime(2026, 4, 22),
        maxTemp: 30.0,
        minTemp: 20.0,
        weatherCode: 0,
        precipitationProbability: 20.0,
        uvIndex: 8.0,
      );

      expect(daily.uvIndex, 8.0);
      expect(daily.precipitationProbability, 20.0);

      final map = daily.toMap();
      final restored = DailyWeather.fromMap(map);

      expect(restored.uvIndex, 8.0);
    });
  });

  group('Weather Helper Tests', () {
    test(' Temperature conversion placeholder', () {
      // This test verifies basic temperature handling
      const celsius = 25.0;
      final fahrenheit = celsius * 9 / 5 + 32;
      
      expect(fahrenheit, 77.0);
    });
  });
}