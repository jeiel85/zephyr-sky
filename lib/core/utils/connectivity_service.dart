import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// 네트워크 연결 상태 관리 서비스
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;
  
  // 연결 상태 스트림 컨트롤러
  final _connectionStatusController = StreamController<bool>.broadcast();
  
  /// 연결 상태 변경 스트림
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  
  /// 현재 연결 상태
  bool _isConnected = true;
  bool get isConnected => _isConnected;
  
  /// 서비스 초기화
  Future<void> initialize() async {
    // 초기 상태 확인
    await _checkConnection();
    
    // 연결 상태 변경 리스너 등록
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }
  
  /// 현재 연결 상태 확인
  Future<bool> checkConnection() async {
    return await _checkConnection();
  }
  
  Future<bool> _checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      return _isConnected;
    } catch (e) {
      if (kDebugMode) {
        print('Connectivity check error: $e');
      }
      _isConnected = false;
      _connectionStatusController.add(false);
      return false;
    }
  }
  
  /// 연결 상태 업데이트
  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected;
    
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
        _isConnected = true;
        break;
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
        _isConnected = false;
        break;
      default:
        _isConnected = false;
    }
    
    // 상태가 변경되었을 때만 알림
    if (wasConnected != _isConnected) {
      _connectionStatusController.add(_isConnected);
    }
  }
  
  /// 리소스 정리
  void dispose() {
    _subscription?.cancel();
    _connectionStatusController.close();
  }
}
