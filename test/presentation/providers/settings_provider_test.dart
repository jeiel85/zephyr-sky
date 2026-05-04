import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zephyr_sky/presentation/providers/settings_provider.dart';

void main() {
  group('SettingsState', () {
    test('has correct default values', () {
      const state = SettingsState();
      expect(state.useCelsius, true);
      expect(state.isDarkMode, false);
      expect(state.notificationsEnabled, true);
      expect(state.favoriteLocations, isEmpty);
      expect(state.languageCode, 'ko');
      expect(state.useSystemTheme, true);
      expect(state.themeColor, 0xFF2196F3);
    });

    test('copyWith updates values', () {
      const state = SettingsState();
      final updated = state.copyWith(
        useCelsius: false,
        isDarkMode: true,
        languageCode: 'en',
      );

      expect(updated.useCelsius, false);
      expect(updated.isDarkMode, true);
      expect(updated.languageCode, 'en');
      expect(updated.notificationsEnabled, true); // unchanged
      expect(updated.favoriteLocations, isEmpty); // unchanged
    });
  });

  group('SettingsNotifier', () {
    late SettingsNotifier notifier;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      notifier = SettingsNotifier(prefs);
    });

    test('loads default settings when prefs are empty', () {
      expect(notifier.state.useCelsius, true);
      expect(notifier.state.isDarkMode, false);
      expect(notifier.state.notificationsEnabled, true);
      expect(notifier.state.languageCode, 'ko');
    });

    test('setUseCelsius updates state and prefs', () async {
      await notifier.setUseCelsius(false);
      expect(notifier.state.useCelsius, false);
    });

    test('setDarkMode updates state and prefs', () async {
      await notifier.setDarkMode(true);
      expect(notifier.state.isDarkMode, true);
    });

    test('setNotificationsEnabled updates state and prefs', () async {
      await notifier.setNotificationsEnabled(false);
      expect(notifier.state.notificationsEnabled, false);
    });

    test('setLanguage updates state and prefs', () async {
      await notifier.setLanguage('en');
      expect(notifier.state.languageCode, 'en');
    });

    test('setUseSystemTheme updates state and prefs', () async {
      await notifier.setUseSystemTheme(false);
      expect(notifier.state.useSystemTheme, false);
    });

    test('setThemeColor updates state and prefs', () async {
      await notifier.setThemeColor(0xFF4CAF50);
      expect(notifier.state.themeColor, 0xFF4CAF50);
    });

    test('addFavoriteLocation adds location', () async {
      await notifier.addFavoriteLocation('Seoul', 37.57, 126.98);
      expect(notifier.state.favoriteLocations.length, 1);
      expect(notifier.state.favoriteLocations.first['name'], 'Seoul');
      expect(notifier.state.favoriteLocations.first['lat'], 37.57);
      expect(notifier.state.favoriteLocations.first['lon'], 126.98);
    });

    test('addFavoriteLocation prevents duplicates', () async {
      await notifier.addFavoriteLocation('Seoul', 37.57, 126.98);
      await notifier.addFavoriteLocation('Seoul', 37.57, 126.98);
      expect(notifier.state.favoriteLocations.length, 1);
    });

    test('removeFavoriteLocation removes by index', () async {
      await notifier.addFavoriteLocation('Seoul', 37.57, 126.98);
      await notifier.addFavoriteLocation('Busan', 35.18, 129.08);
      expect(notifier.state.favoriteLocations.length, 2);

      await notifier.removeFavoriteLocation(0);
      expect(notifier.state.favoriteLocations.length, 1);
      expect(notifier.state.favoriteLocations.first['name'], 'Busan');
    });

    test('removeFavoriteLocation ignores invalid index', () async {
      await notifier.addFavoriteLocation('Seoul', 37.57, 126.98);
      await notifier.removeFavoriteLocation(-1);
      await notifier.removeFavoriteLocation(10);
      expect(notifier.state.favoriteLocations.length, 1);
    });

    test('convertTemperature converts correctly', () {
      // Default is Celsius
      expect(notifier.convertTemperature(0), 0.0);
      expect(notifier.convertTemperature(100), 100.0);
    });

    test('convertTemperature converts to Fahrenheit when set', () async {
      await notifier.setUseCelsius(false);
      expect(notifier.convertTemperature(0), 32.0);
      expect(notifier.convertTemperature(100), 212.0);
    });

    test('formatTemperature returns correct string', () {
      final formatted = notifier.formatTemperature(25.0);
      expect(formatted, '25°C');
    });

    test('formatTemperature returns Fahrenheit when set', () async {
      await notifier.setUseCelsius(false);
      final formatted = notifier.formatTemperature(25.0);
      expect(formatted, '77°F');
    });

    test('loads saved settings from prefs', () async {
      SharedPreferences.setMockInitialValues({
        'use_celsius': false,
        'dark_mode': true,
        'notifications_enabled': false,
        'language_code': 'en',
        'favorite_locations': ['Seoul|37.57|126.98'],
        'use_system_theme': false,
        'theme_color': 0xFF4CAF50,
      });

      final prefs = await SharedPreferences.getInstance();
      final loadedNotifier = SettingsNotifier(prefs);

      expect(loadedNotifier.state.useCelsius, false);
      expect(loadedNotifier.state.isDarkMode, true);
      expect(loadedNotifier.state.notificationsEnabled, false);
      expect(loadedNotifier.state.languageCode, 'en');
      expect(loadedNotifier.state.favoriteLocations.length, 1);
      expect(loadedNotifier.state.favoriteLocations.first['name'], 'Seoul');
      expect(loadedNotifier.state.useSystemTheme, false);
      expect(loadedNotifier.state.themeColor, 0xFF4CAF50);
    });
  });
}
