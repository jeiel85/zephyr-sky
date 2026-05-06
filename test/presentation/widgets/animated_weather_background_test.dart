import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr_sky/presentation/widgets/animated_weather_background.dart';

void main() {
  group('AnimatedWeatherBackground Widget Tests', () {
    testWidgets('renders correctly for clear day', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 0,
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AnimatedWeatherBackground), findsOneWidget);
    });

    testWidgets('renders correctly for rain', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 61,
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AnimatedWeatherBackground), findsOneWidget);
    });

    testWidgets('renders correctly for night', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 0,
            isDay: false,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AnimatedWeatherBackground), findsOneWidget);
    });

    testWidgets('renders correctly for snow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 71,
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AnimatedWeatherBackground), findsOneWidget);
    });

    testWidgets('renders correctly for clouds', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 2,
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AnimatedWeatherBackground), findsOneWidget);
    });
  });
}
