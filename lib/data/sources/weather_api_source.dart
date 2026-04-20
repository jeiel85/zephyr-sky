import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiSource {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  final http.Client _client;

  WeatherApiSource(this._client);

  // 위도, 경도를 기반으로 날씨 정보를 가져옴
  Future<WeatherModel> fetchWeather(double lat, double lon, String locationName) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto'
    );

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(data, locationName);
    } else {
      throw Exception('날씨 정보를 불러오는 데 실패했습니다.');
    }
  }

  // 도시 이름을 기반으로 여러 장소 정보를 검색함
  Future<List<dynamic>> searchLocation(String query) async {
    final url = Uri.parse('$_geocodingUrl?name=$query&count=5&language=ko&format=json');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['results'] as List<dynamic>? ?? [];
    } else {
      throw Exception('위치 검색에 실패했습니다.');
    }
  }
}
