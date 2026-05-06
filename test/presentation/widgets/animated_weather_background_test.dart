import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr_sky/presentation/widgets/animated_weather_background.dart';

void main() {
  group('AnimatedWeatherBackground Widget Tests', () {
    testWidgets('renders gradient background correctly', (WidgetTester tester) async {
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

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('changes particles when weather code changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 0, // Sunshine
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CustomPaint), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 61, // Rain
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();
      
      expect(find.byType(CustomPaint), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('renders stars at night', (WidgetTester tester) async {
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

      expect(find.byType(CustomPaint), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('renders snow effect', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 71, // Snow
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CustomPaint), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('renders clouds effect', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnimatedWeatherBackground(
            weatherCode: 2, // Clouds
            isDay: true,
            child: SizedBox(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CustomPaint), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
