import 'package:flutter/material.dart';

class WeatherHelper {
  static String getDescription(int code) {
    switch (code) {
      case 0: return '맑음';
      case 1: return '대체로 맑음';
      case 2: return '구름 조금';
      case 3: return '흐림';
      case 45: case 48: return '안개';
      case 51: case 53: case 55: return '가벼운 이슬비';
      case 56: case 57: return '결빙 이슬비';
      case 61: return '약한 비';
      case 63: return '보통 비';
      case 65: return '강한 비';
      case 66: case 67: return '결빙 비';
      case 71: return '약한 눈';
      case 73: return '보통 눈';
      case 75: return '강한 눈';
      case 77: return '싸락눈';
      case 80: case 81: case 82: return '소나기';
      case 85: case 86: return '눈 소나기';
      case 95: return '뇌우';
      case 96: case 99: return '우박을 동반한 뇌우';
      default: return '알 수 없음';
    }
  }

  static IconData getIcon(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return isDay ? Icons.wb_sunny : Icons.nightlight_round;
      case 1: case 2:
        return isDay ? Icons.wb_cloudy_outlined : Icons.nightlight_round;
      case 3:
        return Icons.cloud;
      case 45: case 48:
        return Icons.foggy;
      case 51: case 53: case 55:
      case 56: case 57:
        return Icons.grain;
      case 61: case 63: case 65:
      case 66: case 67:
        return Icons.umbrella;
      case 71: case 73: case 75:
      case 77:
        return Icons.ac_unit;
      case 80: case 81: case 82:
        return Icons.beach_access;
      case 85: case 86:
        return Icons.ac_unit_outlined;
      case 95: case 96: case 99:
        return Icons.thunderstorm;
      default:
        return Icons.help_outline;
    }
  }

  static List<Color> getGradientColors(int code, {bool isDay = true}) {
    if (!isDay) {
      return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)];
    }
    
    switch (code) {
      case 0: case 1:
        return [const Color(0xFF2193b0), const Color(0xFF6dd5ed)];
      case 2: case 3:
        return [const Color(0xFFbdc3c7), const Color(0xFF2c3e50)];
      case 45: case 48:
        return [const Color(0xFF757f9a), const Color(0xFFd7dde8)];
      case 51: case 53: case 55:
      case 61: case 63: case 65:
      case 80: case 81: case 82:
        return [const Color(0xFF203a43), const Color(0xFF2c5364)];
      case 71: case 73: case 75:
      case 85: case 86:
        return [const Color(0xFF83a4d4), const Color(0xFFb6fbff)];
      case 95: case 96: case 99:
        return [const Color(0xFF0f0c29), const Color(0xFF302b63), const Color(0xFF24243e)];
      default:
        return [const Color(0xFF4facfe), const Color(0xFF00f2fe)];
    }
  }
}
