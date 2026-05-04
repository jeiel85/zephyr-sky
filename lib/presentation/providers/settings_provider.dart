import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 설정 상태
class SettingsState {
  final bool useCelsius;  // true = °C, false = °F
  final bool isDarkMode;
  final bool notificationsEnabled;
  final List<Map<String, dynamic>> favoriteLocations;
  final String languageCode; // 'ko' or 'en'
  final bool useSystemTheme; // true = 시스템 설정 따르기
  final int themeColor;      // 테마 색상 (Color.value)

  const SettingsState({
    this.useCelsius = true,
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.favoriteLocations = const [],
    this.languageCode = 'ko',
    this.useSystemTheme = true,
    this.themeColor = 0xFF2196F3, // Colors.blue 기본값
  });

  SettingsState copyWith({
    bool? useCelsius,
    bool? isDarkMode,
    bool? notificationsEnabled,
    List<Map<String, dynamic>>? favoriteLocations,
    String? languageCode,
    bool? useSystemTheme,
    int? themeColor,
  }) {
    return SettingsState(
      useCelsius: useCelsius ?? this.useCelsius,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
      languageCode: languageCode ?? this.languageCode,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}

// 설정 관리자
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;

  static const String _keyUseCelsius = 'use_celsius';
  static const String _keyIsDarkMode = 'dark_mode';
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyLanguage = 'language_code';
  static const String _keyUseSystemTheme = 'use_system_theme';
  static const String _keyThemeColor = 'theme_color';

  SettingsNotifier(this._prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final useCelsius = _prefs.getBool(_keyUseCelsius) ?? true;
    final isDarkMode = _prefs.getBool(_keyIsDarkMode) ?? false;
    final notificationsEnabled = _prefs.getBool(_keyNotifications) ?? true;
    final languageCode = _prefs.getString(_keyLanguage) ?? 'ko';
    final useSystemTheme = _prefs.getBool(_keyUseSystemTheme) ?? true;
    final themeColor = _prefs.getInt(_keyThemeColor) ?? 0xFF2196F3;
    
    // 즐겨찾기 위치 로드
    final favoritesJson = _prefs.getStringList(_keyFavorites) ?? [];
    final favorites = favoritesJson.map((json) {
      // 간단한 JSON 파싱 (실제 앱에서는 jsonDecode 사용)
      final parts = json.split('|');
      if (parts.length >= 3) {
        return {
          'name': parts[0],
          'lat': double.tryParse(parts[1]) ?? 0.0,
          'lon': double.tryParse(parts[2]) ?? 0.0,
        };
      }
      return null;
    }).whereType<Map<String, dynamic>>().toList();

    state = SettingsState(
      useCelsius: useCelsius,
      isDarkMode: isDarkMode,
      notificationsEnabled: notificationsEnabled,
      favoriteLocations: favorites,
      languageCode: languageCode,
      useSystemTheme: useSystemTheme,
      themeColor: themeColor,
    );
  }

  // 단위 변경 (°C / °F)
  Future<void> setUseCelsius(bool value) async {
    await _prefs.setBool(_keyUseCelsius, value);
    state = state.copyWith(useCelsius: value);
  }

  // 다크 모드 변경
  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyIsDarkMode, value);
    state = state.copyWith(isDarkMode: value);
  }

  // 시스템 테마 설정 변경
  Future<void> setUseSystemTheme(bool value) async {
    await _prefs.setBool(_keyUseSystemTheme, value);
    state = state.copyWith(useSystemTheme: value);
  }

  // 테마 색상 변경
  Future<void> setThemeColor(int value) async {
    await _prefs.setInt(_keyThemeColor, value);
    state = state.copyWith(themeColor: value);
  }

  // 알림 설정 변경
  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_keyNotifications, value);
    state = state.copyWith(notificationsEnabled: value);
  }

  // 언어 설정 변경
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_keyLanguage, languageCode);
    state = state.copyWith(languageCode: languageCode);
  }

  // 즐겨찾기 추가
  Future<void> addFavoriteLocation(String name, double lat, double lon) async {
    // 중복 확인
    final exists = state.favoriteLocations.any(
      (loc) => loc['name'] == name && loc['lat'] == lat && loc['lon'] == lon,
    );
    if (exists) return;

    final newFavorites = [
      ...state.favoriteLocations,
      {'name': name, 'lat': lat, 'lon': lon},
    ];
    
    // SharedPreferences에 문자열 리스트로 저장
    final favoritesJson = newFavorites.map(
      (loc) => '${loc['name']}|${loc['lat']}|${loc['lon']}',
    ).toList();
    await _prefs.setStringList(_keyFavorites, favoritesJson);
    
    state = state.copyWith(favoriteLocations: newFavorites);
  }

  // 즐겨찾기 제거
  Future<void> removeFavoriteLocation(int index) async {
    if (index < 0 || index >= state.favoriteLocations.length) return;
    
    final newFavorites = [...state.favoriteLocations]..removeAt(index);
    
    final favoritesJson = newFavorites.map(
      (loc) => '${loc['name']}|${loc['lat']}|${loc['lon']}',
    ).toList();
    await _prefs.setStringList(_keyFavorites, favoritesJson);
    
    state = state.copyWith(favoriteLocations: newFavorites);
  }

  // 온도 변환 (°C -> °F)
  double convertTemperature(double celsius) {
    if (state.useCelsius) return celsius;
    return celsius * 9 / 5 + 32;
  }

  // 온도 문자열 반환
  String formatTemperature(double celsius) {
    final temp = convertTemperature(celsius).round();
    final unit = state.useCelsius ? '°C' : '°F';
    return '$temp$unit';
  }
}

// 설정 프로바이더
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  throw UnimplementedError('settingsProvider must be overridden in main.dart');
});