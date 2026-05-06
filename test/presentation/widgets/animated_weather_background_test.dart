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

      expect(find.byType(Container), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('renders rain effect', (WidgetTester tester) async {
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
      expect(find.byType(CustomPaint), findsOneWidget);
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
    });

    testWidgets('renders snow effect', (WidgetTester tester) async {
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
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('renders clouds effect', (WidgetTester tester) async {
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
      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });
}
