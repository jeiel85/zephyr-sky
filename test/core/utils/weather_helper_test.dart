import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr_sky/core/utils/weather_helper.dart';

void main() {
  group('WeatherHelper', () {
    group('getDescription', () {
      test('returns clear for code 0', () {
        expect(WeatherHelper.getDescription(0), '맑음');
      });

      test('returns mainly clear for code 1', () {
        expect(WeatherHelper.getDescription(1), '대체로 맑음');
      });

      test('returns partly cloudy for code 2', () {
        expect(WeatherHelper.getDescription(2), '구름 조금');
      });

      test('returns overcast for code 3', () {
        expect(WeatherHelper.getDescription(3), '흐림');
      });

      test('returns fog for codes 45 and 48', () {
        expect(WeatherHelper.getDescription(45), '안개');
        expect(WeatherHelper.getDescription(48), '안개');
      });

      test('returns light drizzle for codes 51, 53, 55', () {
        expect(WeatherHelper.getDescription(51), '가벼운 이슬비');
        expect(WeatherHelper.getDescription(53), '가벼운 이슬비');
        expect(WeatherHelper.getDescription(55), '가벼운 이슬비');
      });

      test('returns rain for codes 61, 63, 65', () {
        expect(WeatherHelper.getDescription(61), '약한 비');
        expect(WeatherHelper.getDescription(63), '보통 비');
        expect(WeatherHelper.getDescription(65), '강한 비');
      });

      test('returns snow for codes 71, 73, 75', () {
        expect(WeatherHelper.getDescription(71), '약한 눈');
        expect(WeatherHelper.getDescription(73), '보통 눈');
        expect(WeatherHelper.getDescription(75), '강한 눈');
      });

      test('returns thunderstorm for code 95', () {
        expect(WeatherHelper.getDescription(95), '뇌우');
      });

      test('returns thunderstorm with hail for codes 96, 99', () {
        expect(WeatherHelper.getDescription(96), '우박을 동반한 뇌우');
        expect(WeatherHelper.getDescription(99), '우박을 동반한 뇌우');
      });

      test('returns unknown for unmapped code', () {
        expect(WeatherHelper.getDescription(999), '알 수 없음');
      });
    });

    group('getIcon', () {
      test('returns sunny icon for clear day', () {
        expect(WeatherHelper.getIcon(0, isDay: true), Icons.wb_sunny);
      });

      test('returns night icon for clear night', () {
        expect(WeatherHelper.getIcon(0, isDay: false), Icons.nightlight_round);
      });

      test('returns cloud icon for overcast', () {
        expect(WeatherHelper.getIcon(3), Icons.cloud);
      });

      test('returns fog icon for fog', () {
        expect(WeatherHelper.getIcon(45), Icons.foggy);
        expect(WeatherHelper.getIcon(48), Icons.foggy);
      });

      test('returns umbrella icon for rain', () {
        expect(WeatherHelper.getIcon(61), Icons.umbrella);
        expect(WeatherHelper.getIcon(65), Icons.umbrella);
      });

      test('returns ac_unit icon for snow', () {
        expect(WeatherHelper.getIcon(71), Icons.ac_unit);
        expect(WeatherHelper.getIcon(75), Icons.ac_unit);
      });

      test('returns thunderstorm icon for storm', () {
        expect(WeatherHelper.getIcon(95), Icons.thunderstorm);
        expect(WeatherHelper.getIcon(99), Icons.thunderstorm);
      });

      test('returns help icon for unknown code', () {
        expect(WeatherHelper.getIcon(999), Icons.help_outline);
      });
    });

    group('getGradientColors', () {
      test('returns night gradient when isDay is false', () {
        final colors = WeatherHelper.getGradientColors(0, isDay: false);
        expect(colors.length, 3);
        expect(colors[0], const Color(0xFF0F2027));
      });

      test('returns clear day gradient for code 0', () {
        final colors = WeatherHelper.getGradientColors(0, isDay: true);
        expect(colors.length, 2);
        expect(colors[0], const Color(0xFF2193b0));
      });

      test('returns cloudy gradient for code 3', () {
        final colors = WeatherHelper.getGradientColors(3, isDay: true);
        expect(colors[0], const Color(0xFFbdc3c7));
      });

      test('returns rain gradient for code 61', () {
        final colors = WeatherHelper.getGradientColors(61, isDay: true);
        expect(colors[0], const Color(0xFF203a43));
      });

      test('returns snow gradient for code 71', () {
        final colors = WeatherHelper.getGradientColors(71, isDay: true);
        expect(colors[0], const Color(0xFF83a4d4));
      });

      test('returns thunderstorm gradient for code 95', () {
        final colors = WeatherHelper.getGradientColors(95, isDay: true);
        expect(colors.length, 3);
        expect(colors[0], const Color(0xFF0f0c29));
      });

      test('returns default gradient for unknown code', () {
        final colors = WeatherHelper.getGradientColors(999, isDay: true);
        expect(colors[0], const Color(0xFF4facfe));
      });
    });
  });
}
