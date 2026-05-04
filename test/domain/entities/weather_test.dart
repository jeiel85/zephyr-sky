import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr_sky/domain/entities/weather.dart';

void main() {
  group('Weather', () {
    final baseWeather = Weather(
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

    test('creates with required fields', () {
      expect(baseWeather.temperature, 25.0);
      expect(baseWeather.weatherCode, 0);
      expect(baseWeather.humidity, 60.0);
      expect(baseWeather.windSpeed, 10.0);
      expect(baseWeather.isDay, true);
      expect(baseWeather.locationName, 'Seoul');
    });

    group('airQualityLevel', () {
      test('returns unknown when null', () {
        expect(baseWeather.airQualityLevel, '알 수 없음');
      });

      test('returns good for AQI <= 50', () {
        final w = _copyWith(baseWeather, airQualityIndex: 50);
        expect(w.airQualityLevel, '좋음');
      });

      test('returns moderate for AQI <= 100', () {
        final w = _copyWith(baseWeather, airQualityIndex: 75);
        expect(w.airQualityLevel, '보통');
      });

      test('returns sensitive for AQI <= 150', () {
        final w = _copyWith(baseWeather, airQualityIndex: 120);
        expect(w.airQualityLevel, '민감군 불쾌');
      });

      test('returns unhealthy for AQI <= 200', () {
        final w = _copyWith(baseWeather, airQualityIndex: 180);
        expect(w.airQualityLevel, '불건강');
      });

      test('returns very unhealthy for AQI <= 300', () {
        final w = _copyWith(baseWeather, airQualityIndex: 250);
        expect(w.airQualityLevel, '매우 불건강');
      });

      test('returns hazardous for AQI > 300', () {
        final w = _copyWith(baseWeather, airQualityIndex: 350);
        expect(w.airQualityLevel, '위험');
      });
    });

    group('uvRiskLevel', () {
      test('returns unknown when null', () {
        expect(baseWeather.uvRiskLevel, '알 수 없음');
      });

      test('returns low for UV <= 2', () {
        final w = _copyWith(baseWeather, uvIndex: 1.0);
        expect(w.uvRiskLevel, '낮음');
      });

      test('returns moderate for UV <= 5', () {
        final w = _copyWith(baseWeather, uvIndex: 4.0);
        expect(w.uvRiskLevel, '보통');
      });

      test('returns high for UV <= 7', () {
        final w = _copyWith(baseWeather, uvIndex: 6.0);
        expect(w.uvRiskLevel, '높음');
      });

      test('returns very high for UV <= 10', () {
        final w = _copyWith(baseWeather, uvIndex: 9.0);
        expect(w.uvRiskLevel, '매우 높음');
      });

      test('returns extreme for UV > 10', () {
        final w = _copyWith(baseWeather, uvIndex: 12.0);
        expect(w.uvRiskLevel, '위험');
      });
    });

    group('outdoorActivityScore', () {
      test('returns 100 for perfect conditions', () {
        final w = _copyWith(baseWeather,
          temperature: 22.0,
          windSpeed: 5.0,
          uvIndex: 2.0,
          precipitationProbability: 0.0,
          airQualityIndex: 20,
        );
        expect(w.outdoorActivityScore, 100);
      });

      test('penalizes extreme cold', () {
        final w = _copyWith(baseWeather, temperature: -15.0);
        expect(w.outdoorActivityScore, lessThanOrEqualTo(60));
      });

      test('penalizes extreme heat', () {
        final w = _copyWith(baseWeather, temperature: 40.0);
        expect(w.outdoorActivityScore, lessThanOrEqualTo(60));
      });

      test('penalizes high precipitation', () {
        final w = _copyWith(baseWeather, precipitationProbability: 100.0);
        expect(w.outdoorActivityScore, lessThanOrEqualTo(50));
      });

      test('penalizes high UV', () {
        final w = _copyWith(baseWeather, uvIndex: 10.0);
        expect(w.outdoorActivityScore, lessThanOrEqualTo(70));
      });

      test('penalizes strong wind', () {
        final w = _copyWith(baseWeather, windSpeed: 60.0);
        expect(w.outdoorActivityScore, lessThanOrEqualTo(70));
      });

      test('penalizes poor air quality', () {
        final w = _copyWith(baseWeather, airQualityIndex: 200);
        expect(w.outdoorActivityScore, lessThanOrEqualTo(70));
      });

      test('clamps to minimum 0', () {
        final w = _copyWith(baseWeather,
          temperature: -20.0,
          windSpeed: 60.0,
          uvIndex: 12.0,
          precipitationProbability: 100.0,
          airQualityIndex: 500,
        );
        expect(w.outdoorActivityScore, 0);
      });
    });

    group('outdoorActivityLevel', () {
      test('returns excellent for score >= 80', () {
        final w = _copyWith(baseWeather, temperature: 22.0, windSpeed: 5.0);
        expect(w.outdoorActivityLevel, '최상');
      });

      test('returns good for score >= 60', () {
        final w = _copyWith(baseWeather, temperature: 32.0);
        expect(w.outdoorActivityLevel, '양호');
      });

      test('returns fair for score >= 40', () {
        final w = _copyWith(baseWeather, temperature: 38.0);
        expect(w.outdoorActivityLevel, '보통');
      });

      test('returns poor for score >= 20', () {
        final w = _copyWith(baseWeather, temperature: -5.0, windSpeed: 35.0);
        expect(w.outdoorActivityLevel, '나쁨');
      });

      test('returns dangerous for score < 20', () {
        final w = _copyWith(baseWeather,
          temperature: -20.0,
          windSpeed: 60.0,
          precipitationProbability: 100.0,
        );
        expect(w.outdoorActivityLevel, '위험');
      });
    });

    group('serialization', () {
      test('toMap and fromMap preserve data', () {
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
        expect(restored.weatherCode, weather.weatherCode);
        expect(restored.humidity, weather.humidity);
        expect(restored.windSpeed, weather.windSpeed);
        expect(restored.apparentTemperature, weather.apparentTemperature);
        expect(restored.isDay, weather.isDay);
        expect(restored.maxTemp, weather.maxTemp);
        expect(restored.minTemp, weather.minTemp);
        expect(restored.locationName, weather.locationName);
        expect(restored.time, weather.time);
        expect(restored.hourlyForecast.length, weather.hourlyForecast.length);
        expect(restored.dailyForecast.length, weather.dailyForecast.length);
        expect(restored.airQualityIndex, weather.airQualityIndex);
        expect(restored.uvIndex, weather.uvIndex);
        expect(restored.precipitationProbability, weather.precipitationProbability);
        expect(restored.sunrise, weather.sunrise);
        expect(restored.sunset, weather.sunset);
        expect(restored.pressure, weather.pressure);
        expect(restored.visibility, weather.visibility);
        expect(restored.dewPoint, weather.dewPoint);
        expect(restored.cloudCover, weather.cloudCover);
      });

      test('handles null optional fields', () {
        final map = baseWeather.toMap();
        final restored = Weather.fromMap(map);
        expect(restored.airQualityIndex, isNull);
        expect(restored.uvIndex, isNull);
        expect(restored.precipitationProbability, isNull);
        expect(restored.sunrise, isNull);
        expect(restored.sunset, isNull);
        expect(restored.pressure, isNull);
        expect(restored.visibility, isNull);
        expect(restored.dewPoint, isNull);
        expect(restored.cloudCover, isNull);
      });

      test('handles empty forecast lists', () {
        final map = baseWeather.toMap();
        final restored = Weather.fromMap(map);
        expect(restored.hourlyForecast, isEmpty);
        expect(restored.dailyForecast, isEmpty);
      });
    });
  });

  group('HourlyWeather', () {
    test('serializes and deserializes', () {
      final hourly = HourlyWeather(
        time: DateTime(2026, 4, 22, 15, 0),
        temperature: 25.0,
        weatherCode: 61,
        precipitationProbability: 80.0,
      );

      final map = hourly.toMap();
      final restored = HourlyWeather.fromMap(map);

      expect(restored.time, hourly.time);
      expect(restored.temperature, hourly.temperature);
      expect(restored.weatherCode, hourly.weatherCode);
      expect(restored.precipitationProbability, hourly.precipitationProbability);
    });

    test('handles null precipitationProbability', () {
      final hourly = HourlyWeather(
        time: DateTime(2026, 4, 22, 15, 0),
        temperature: 25.0,
        weatherCode: 0,
      );
      expect(hourly.precipitationProbability, isNull);

      final map = hourly.toMap();
      final restored = HourlyWeather.fromMap(map);
      expect(restored.precipitationProbability, isNull);
    });
  });

  group('DailyWeather', () {
    test('serializes and deserializes', () {
      final daily = DailyWeather(
        time: DateTime(2026, 4, 22),
        maxTemp: 30.0,
        minTemp: 20.0,
        weatherCode: 0,
        precipitationProbability: 20.0,
        uvIndex: 8.0,
      );

      final map = daily.toMap();
      final restored = DailyWeather.fromMap(map);

      expect(restored.time, daily.time);
      expect(restored.maxTemp, daily.maxTemp);
      expect(restored.minTemp, daily.minTemp);
      expect(restored.weatherCode, daily.weatherCode);
      expect(restored.precipitationProbability, daily.precipitationProbability);
      expect(restored.uvIndex, daily.uvIndex);
    });

    test('handles null optional fields', () {
      final daily = DailyWeather(
        time: DateTime(2026, 4, 22),
        maxTemp: 30.0,
        minTemp: 20.0,
        weatherCode: 0,
      );
      expect(daily.precipitationProbability, isNull);
      expect(daily.uvIndex, isNull);

      final map = daily.toMap();
      final restored = DailyWeather.fromMap(map);
      expect(restored.precipitationProbability, isNull);
      expect(restored.uvIndex, isNull);
    });
  });
}

Weather _copyWith(Weather w, {
  double? temperature,
  int? weatherCode,
  double? humidity,
  double? windSpeed,
  double? apparentTemperature,
  bool? isDay,
  double? maxTemp,
  double? minTemp,
  String? locationName,
  DateTime? time,
  List<HourlyWeather>? hourlyForecast,
  List<DailyWeather>? dailyForecast,
  int? airQualityIndex,
  double? uvIndex,
  double? precipitationProbability,
}) {
  return Weather(
    temperature: temperature ?? w.temperature,
    weatherCode: weatherCode ?? w.weatherCode,
    humidity: humidity ?? w.humidity,
    windSpeed: windSpeed ?? w.windSpeed,
    apparentTemperature: apparentTemperature ?? w.apparentTemperature,
    isDay: isDay ?? w.isDay,
    maxTemp: maxTemp ?? w.maxTemp,
    minTemp: minTemp ?? w.minTemp,
    locationName: locationName ?? w.locationName,
    time: time ?? w.time,
    hourlyForecast: hourlyForecast ?? w.hourlyForecast,
    dailyForecast: dailyForecast ?? w.dailyForecast,
    airQualityIndex: airQualityIndex ?? w.airQualityIndex,
    uvIndex: uvIndex ?? w.uvIndex,
    precipitationProbability: precipitationProbability ?? w.precipitationProbability,
  );
}
