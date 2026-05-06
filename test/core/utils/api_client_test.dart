import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zephyr_sky/core/utils/api_client.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;
  late SharedPreferences prefs;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(mockHttpClient, prefs);
  });

  group('ApiClient Tests', () {
    final url = Uri.parse('https://api.example.com/weather');

    test('get returns success response', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"status": "ok"}', 200));

      final response = await apiClient.get(url);

      expect(response.statusCode, 200);
      expect(response.body, '{"status": "ok"}');
      verify(() => mockHttpClient.get(url, headers: any(named: 'headers'))).called(1);
    });

    test('retries on 500 server error', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      final response = await apiClient.get(url);

      expect(response.statusCode, 500);
      // Verify it tried 3 times (maxRetries)
      verify(() => mockHttpClient.get(url, headers: any(named: 'headers'))).called(3);
    });

    test('retries on 429 rate limit error', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Too Many Requests', 429));

      final response = await apiClient.get(url);

      expect(response.statusCode, 429);
      verify(() => mockHttpClient.get(url, headers: any(named: 'headers'))).called(3);
    });

    test('does not retry on 404 client error', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final response = await apiClient.get(url);

      expect(response.statusCode, 404);
      verify(() => mockHttpClient.get(url, headers: any(named: 'headers'))).called(1);
    });

    test('respects rate limiting interval', () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('ok', 200));

      final startTime = DateTime.now().millisecondsSinceEpoch;
      
      // First call
      await apiClient.get(url);
      
      // Second call immediately
      await apiClient.get(url);
      
      final endTime = DateTime.now().millisecondsSinceEpoch;
      final duration = endTime - startTime;
      
      // Should wait at least 5 seconds between calls
      expect(duration, greaterThanOrEqualTo(5000));
    });
  });
}
