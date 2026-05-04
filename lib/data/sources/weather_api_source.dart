import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../l10n/app_localizations.dart';
import '../models/weather_model.dart';

class WeatherApiSource {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _airQualityUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';

  final http.Client _client;

  WeatherApiSource(this._client);

  // 위도, 경도를 기반으로 날씨 정보를 가져옴 (확장版)
  Future<WeatherModel> fetchWeather(double lat, double lon, String locationName, {AppLocalizations? l10n}) async {
    // 확장 파라미터: 16일 예보, UV, 기압, 시정, 이슬점, 구름량, 강수확률
    final url = Uri.parse(
      '$_baseUrl?latitude=$lat&longitude=$lon'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m,uv_index,pressure_msl,visibility,dew_point_2m,cloud_cover'
      '&hourly=temperature_2m,weather_code,precipitation_probability'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,uv_index_max,sunrise,sunset'
      '&timezone=auto&forecast_days=16'
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final weather = WeatherModel.fromJson(data, locationName);
      
      // AQI 정보를 별도 API에서 가져옴
      return await _fetchAirQuality(lat, lon, weather, l10n: l10n);
    } else {
      throw Exception(l10n?.weatherLoadFailed ?? '날씨 정보를 불러오는 데 실패했습니다.');
    }
  }

  // AQI 정보를 가져와서 Weather 객체에 추가
  Future<WeatherModel> _fetchAirQuality(double lat, double lon, WeatherModel weather, {AppLocalizations? l10n}) async {
    try {
      final url = Uri.parse(
        '$_airQualityUrl?latitude=$lat&longitude=$lon'
        '&current=european_aqi'
        '&timezone=auto'
      );
      
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final current = data['current'] as Map<String, dynamic>?;
        final aqi = current?['european_aqi'] as num?;
        
        if (aqi != null) {
          return WeatherModel(
            temperature: weather.temperature,
            weatherCode: weather.weatherCode,
            humidity: weather.humidity,
            windSpeed: weather.windSpeed,
            apparentTemperature: weather.apparentTemperature,
            isDay: weather.isDay,
            maxTemp: weather.maxTemp,
            minTemp: weather.minTemp,
            locationName: weather.locationName,
            time: weather.time,
            hourlyForecast: weather.hourlyForecast,
            dailyForecast: weather.dailyForecast,
            airQualityIndex: aqi.toInt(),
            uvIndex: weather.uvIndex,
            precipitationProbability: weather.precipitationProbability,
            sunrise: weather.sunrise,
            sunset: weather.sunset,
            pressure: weather.pressure,
            visibility: weather.visibility,
            dewPoint: weather.dewPoint,
            cloudCover: weather.cloudCover,
          );
        }
      }
    } catch (e) {
      // AQI 가져오기 실패 시 기존 날씨 정보 반환
      debugPrint(l10n?.aqiLoadFailed(e.toString()) ?? 'AQI 정보를 불러오는 데 실패했습니다: $e');
    }
    
    return weather;
  }

  // 도시 이름을 기반으로 여러 장소 정보를 검색함
  Future<List<dynamic>> searchLocation(String query, {String language = 'ko', AppLocalizations? l10n}) async {
    final url = Uri.parse('$_geocodingUrl?name=$query&count=5&language=$language&format=json');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['results'] as List<dynamic>? ?? [];
    } else {
      throw Exception(l10n?.searchFailed ?? '위치 검색에 실패했습니다.');
    }
  }
}
