import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/weather_repository_impl.dart';
import '../../data/sources/weather_api_source.dart';
import '../../domain/entities/weather.dart';
import '../../core/utils/location_service.dart';
import '../../domain/repositories/weather_repository.dart';

// 위치 서비스 프로바이더
final locationServiceProvider = Provider((ref) => LocationService());

// HTTP 클라이언트 프로바이더
final httpClientProvider = Provider((ref) => http.Client());

// API 소스 프로바이더
final weatherApiSourceProvider = Provider((ref) {
  final client = ref.watch(httpClientProvider);
  return WeatherApiSource(client);
});

// 레파지토리 프로바이더
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final apiSource = ref.watch(weatherApiSourceProvider);
  return WeatherRepositoryImpl(apiSource);
});

// 날씨 상태를 관리하는 Notifier
class WeatherNotifier extends StateNotifier<AsyncValue<Weather?>> {
  final WeatherRepository _repository;

  WeatherNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> fetchWeather(double lat, double lon, String locationName) async {
    state = const AsyncValue.loading();
    try {
      final weather = await _repository.getWeather(lat, lon, locationName);
      state = AsyncValue.data(weather);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// 날씨 상태 프로바이더
final weatherStateProvider = StateNotifierProvider<WeatherNotifier, AsyncValue<Weather?>>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return WeatherNotifier(repository);
});
