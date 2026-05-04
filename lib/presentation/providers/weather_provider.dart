import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../data/sources/weather_api_source.dart';
import '../../domain/entities/weather.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/notification_service.dart';
import '../../core/utils/home_widget_service.dart';
import '../../core/utils/connectivity_service.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../l10n/app_localizations.dart';
import 'settings_provider.dart';
import 'dart:io' show Platform;

// SharedPreferences 프로바이더 (main.dart에서 override 필수)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

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
  final prefs = ref.watch(sharedPreferencesProvider);
  return WeatherRepositoryImpl(apiSource, prefs);
});

// 오프라인 상태 모델
class OfflineStatus {
  final bool isOffline;
  final bool isCacheExpired;
  final DateTime? lastUpdated;

  const OfflineStatus({
    this.isOffline = false,
    this.isCacheExpired = false,
    this.lastUpdated,
  });

  OfflineStatus copyWith({
    bool? isOffline,
    bool? isCacheExpired,
    DateTime? lastUpdated,
  }) {
    return OfflineStatus(
      isOffline: isOffline ?? this.isOffline,
      isCacheExpired: isCacheExpired ?? this.isCacheExpired,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// 날씨 상태를 관리하는 Notifier
class WeatherNotifier extends StateNotifier<AsyncValue<Weather?>> {
  final WeatherRepository _repository;
  final Ref _ref;
  final ConnectivityService _connectivityService = ConnectivityService();

  WeatherNotifier(this._repository, this._ref) : super(const AsyncValue.data(null)) {
    _connectivityService.initialize();
  }

  AppLocalizations _getL10n() {
    final settings = _ref.read(settingsProvider);
    return lookupAppLocalizations(Locale(settings.languageCode));
  }

  /// 오프라인 상태 스트림
  Stream<bool> get offlineStatus => _connectivityService.connectionStatus.map((isConnected) => !isConnected);

  /// 현재 오프라인 상태
  bool get isCurrentlyOffline => !_connectivityService.isConnected;

  /// 캐시된 날씨 로드 (오프라인 상태 포함)
  Future<OfflineStatus> loadCachedWeather() async {
    final cachedInfo = await _repository.getCachedWeatherWithInfo();
    if (cachedInfo != null) {
      state = AsyncValue.data(cachedInfo.weather);

      // 알림 설정 확인 후 업데이트
      final settings = _ref.read(settingsProvider);
      final l10n = _getL10n();
      if (settings.notificationsEnabled) {
        await _ref.read(notificationServiceProvider).showWeatherNotification(cachedInfo.weather, l10n);
      } else {
        await _ref.read(notificationServiceProvider).cancelNotification();
      }

      // 위젯 업데이트
      await HomeWidgetService.updateWidget(cachedInfo.weather, l10n);

      return OfflineStatus(
        isOffline: isCurrentlyOffline,
        isCacheExpired: cachedInfo.isExpired,
        lastUpdated: cachedInfo.cachedTime,
      );
    }
    return const OfflineStatus();
  }

  /// 날씨 가져오기 (오프라인 대응)
  Future<OfflineStatus> fetchWeather(double lat, double lon, String locationName, {bool forceRefresh = false}) async {
    // 1. 먼저 캐시된 데이터 로드 (있는 경우)
    final cachedInfo = await _repository.getCachedWeatherWithInfo();
    if (cachedInfo != null && !forceRefresh) {
      state = AsyncValue.data(cachedInfo.weather);
    }

    // 2. 네트워크 상태 확인
    final isOnline = await _connectivityService.checkConnection();

    if (!isOnline) {
      // 오프라인: 캐시된 데이터가 있으면 그대로 사용
      if (cachedInfo != null) {
        return OfflineStatus(
          isOffline: true,
          isCacheExpired: cachedInfo.isExpired,
          lastUpdated: cachedInfo.cachedTime,
        );
      }
      // 캐시도 없으면 에러
      state = AsyncValue.error(Exception('No internet connection and no cached data'), StackTrace.current);
      return const OfflineStatus(isOffline: true);
    }

    // 3. 온라인: API 호출
    if (cachedInfo == null || forceRefresh) {
      state = const AsyncValue.loading();
    }

    try {
      final weather = await _repository.getWeather(lat, lon, locationName);
      state = AsyncValue.data(weather);

      // 알림 및 위젯 업데이트
      final settings = _ref.read(settingsProvider);
      final l10n = _getL10n();
      if (settings.notificationsEnabled) {
        await _ref.read(notificationServiceProvider).showWeatherNotification(weather, l10n);
      } else {
        await _ref.read(notificationServiceProvider).cancelNotification();
      }
      await HomeWidgetService.updateWidget(weather, l10n);

      return OfflineStatus(
        isOffline: false,
        isCacheExpired: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e, stack) {
      // API 실패: 캐시된 데이터가 있으면 폴리백
      if (cachedInfo != null) {
        state = AsyncValue.data(cachedInfo.weather);
        return OfflineStatus(
          isOffline: false,
          isCacheExpired: cachedInfo.isExpired,
          lastUpdated: cachedInfo.cachedTime,
        );
      }
      state = AsyncValue.error(e, stack);
      return const OfflineStatus(isOffline: false);
    }
  }

  /// 새로고침 (stale-while-revalidate 패턴)
  Future<OfflineStatus> refreshWeather(double lat, double lon, String locationName) async {
    return fetchWeather(lat, lon, locationName, forceRefresh: true);
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
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
