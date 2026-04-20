import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/weather_repository_impl.dart';
import '../../data/sources/weather_api_source.dart';
import '../../domain/entities/weather.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/notification_service.dart';
import '../../domain/repositories/weather_repository.dart';

// 위치 서비스 프로바이더
final locationServiceProvider = Provider((ref) => LocationService());

// 알림 서비스 프로바이더
final notificationServiceProvider = Provider((ref) => NotificationService());

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
  final Ref _ref;

  WeatherNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> fetchWeather(double lat, double lon, String locationName) async {
    state = const AsyncValue.loading();
    try {
      final weather = await _repository.getWeather(lat, lon, locationName);
      state = AsyncValue.data(weather);
      
      // 날씨 데이터를 성공적으로 가져오면 상태바 알림 업데이트
      await _ref.read(notificationServiceProvider).showWeatherNotification(weather);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// 날씨 상태 프로바이더
final weatherStateProvider = StateNotifierProvider<WeatherNotifier, AsyncValue<Weather?>>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return WeatherNotifier(repository, ref);
});

// 검색 결과를 관리하는 Notifier
class SearchNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final WeatherRepository _repository;

  SearchNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final results = await _repository.searchLocation(query);
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// 검색 결과 프로바이더
final searchResultsProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<dynamic>>>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return SearchNotifier(repository);
});
