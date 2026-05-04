import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// API 클라이언트 with Rate Limiting & Retry Logic
class ApiClient {
  final http.Client _client;
  final SharedPreferences _prefs;
  
  // API 호출 제한 설정
  static const String _lastApiCallKey = 'last_api_call_timestamp';
  static const int _minApiCallIntervalSeconds = 5; // 최소 5초 간격
  
  // 재시도 설정
  static const int _maxRetries = 3;
  static const int _baseDelayMs = 1000; // 1초 기본 대기

  ApiClient(this._client, this._prefs);

  /// GET 요청 with Rate Limiting & Exponential Backoff
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool skipCache = false,
  }) async {
    // 1. Rate Limiting 체크
    if (!skipCache) {
      await _waitForRateLimit();
    }

    // 2. API 호출 with Retry
    return await _requestWithRetry(
      () => _client.get(url, headers: headers),
    );
  }

  /// Rate Limiting: 마지막 호출로부터 최소 간격 보장
  Future<void> _waitForRateLimit() async {
    final lastCall = _prefs.getInt(_lastApiCallKey);
    if (lastCall != null) {
      final elapsed = DateTime.now().millisecondsSinceEpoch - lastCall;
      final minIntervalMs = _minApiCallIntervalSeconds * 1000;
      
      if (elapsed < minIntervalMs) {
        final waitMs = minIntervalMs - elapsed;
        await Future.delayed(Duration(milliseconds: waitMs));
      }
    }
  }

  /// API 호출 with Exponential Backoff 재시도
  Future<http.Response> _requestWithRetry(
    Future<http.Response> Function() request,
  ) async {
    int attempt = 0;
    
    while (attempt < _maxRetries) {
      try {
        // API 호출 기록
        await _prefs.setInt(
          _lastApiCallKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        
        final response = await request().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Request timed out after 10 seconds');
          },
        );

        // 성공 응답
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }

        // 재시도 가능한 에러 (429, 5xx)
        if (_isRetryableStatusCode(response.statusCode)) {
          attempt++;
          if (attempt < _maxRetries) {
            await _exponentialBackoff(attempt);
          } else {
            return response; // 최대 재시도 도달
          }
        } else {
          // 재시도 불가능한 에러 (4xx)
          return response;
        }
      } on TimeoutException catch (e) {
        attempt++;
        if (attempt < _maxRetries) {
          await _exponentialBackoff(attempt);
        } else {
          rethrow;
        }
      } on SocketException catch (e) {
        attempt++;
        if (attempt < _maxRetries) {
          await _exponentialBackoff(attempt);
        } else {
          rethrow;
        }
      } catch (e) {
        attempt++;
        if (attempt < _maxRetries) {
          await _exponentialBackoff(attempt);
        } else {
          rethrow;
        }
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// 재시도 가능한 HTTP 상태 코드 체크
  bool _isRetryableStatusCode(int statusCode) {
    return statusCode == 429 || // Too Many Requests
           (statusCode >= 500 && statusCode < 600); // Server errors
  }

  /// Exponential Backoff 대기
  Future<void> _exponentialBackoff(int attempt) async {
    final delayMs = _baseDelayMs * (1 << (attempt - 1)); // 1s, 2s, 4s
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}
