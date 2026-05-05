import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zephyr_sky/domain/entities/weather.dart';
import 'package:zephyr_sky/domain/repositories/weather_repository.dart';
import 'package:zephyr_sky/presentation/providers/weather_provider.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  group('OfflineStatus', () {
    test('has correct default values', () {
      const status = OfflineStatus();
      expect(status.isOffline, false);
      expect(status.isCacheExpired, false);
      expect(status.lastUpdated, isNull);
    });

    test('copyWith updates values', () {
      const status = OfflineStatus();
      final updated = status.copyWith(
        isOffline: true,
        isCacheExpired: true,
        lastUpdated: DateTime(2026, 4, 22),
      );

      expect(updated.isOffline, true);
      expect(updated.isCacheExpired, true);
      expect(updated.lastUpdated, DateTime(2026, 4, 22));
    });

    test('copyWith preserves unchanged values', () {
      const status = OfflineStatus(isOffline: true);
      final updated = status.copyWith(isCacheExpired: true);

      expect(updated.isOffline, true);
      expect(updated.isCacheExpired, true);
      expect(updated.lastUpdated, isNull);
    });
  });

  group('SearchNotifier', () {
    late MockWeatherRepository mockRepository;
    late SearchNotifier notifier;

    setUp(() {
      mockRepository = MockWeatherRepository();
      notifier = SearchNotifier(mockRepository);
    });

    test('initial state is empty list', () {
      expect(notifier.state.value, isEmpty);
    });

    test('search with empty query returns empty list', () async {
      await notifier.search('');
      expect(notifier.state.value, isEmpty);
    });

    test('search updates state to loading then results', () async {
      final results = [
        {'name': 'Seoul', 'latitude': 37.57, 'longitude': 126.98},
      ];

      when(() => mockRepository.searchLocation(any(), language: any(named: 'language')))
          .thenAnswer((_) async => results);

      await notifier.search('Seoul');

      expect(notifier.state.value, results);
    });

    test('search handles errors', () async {
      when(() => mockRepository.searchLocation(any(), language: any(named: 'language')))
          .thenThrow(Exception('Network error'));

      await notifier.search('Seoul');

      expect(notifier.state, isA<AsyncError<List<dynamic>>>());
    });
  });
}
