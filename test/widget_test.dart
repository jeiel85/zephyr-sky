import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_weather/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // ProviderScope가 필요하므로 감싸줍니다.
    await tester.pumpWidget(
      const ProviderScope(
        child: OpenWeatherApp(),
      ),
    );

    // 앱이 정상적으로 로드되었는지 확인 (에러 없이 렌더링되는지)
    expect(find.byType(OpenWeatherApp), findsOneWidget);
  });
}
