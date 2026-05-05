import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zephyr_sky/l10n/app_localizations.dart';
import 'package:zephyr_sky/presentation/providers/settings_provider.dart';
import 'package:zephyr_sky/presentation/providers/weather_provider.dart';
import 'package:zephyr_sky/presentation/screens/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('renders without crashing', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            settingsProvider.overrideWith((ref) => SettingsNotifier(prefs)),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ko'),
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
