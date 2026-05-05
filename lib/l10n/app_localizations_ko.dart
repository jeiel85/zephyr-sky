// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Zephyr Sky';

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get close => '닫기';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get search => '검색';

  @override
  String get refresh => '새로고침';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 시도';

  @override
  String get locationLoading => '위치 로드 중...';

  @override
  String get menuOpen => '메뉴 열기';

  @override
  String get appSubtitle => '날씨 및 설정';

  @override
  String get searchLocation => '위치 검색';

  @override
  String get settings => '설정';

  @override
  String get weatherRefresh => '날씨 새로고침';

  @override
  String get temperaturePrecipitationTrend => '기온 및 강수량 추이';

  @override
  String currentWeatherLabel(Object description, Object temperature) {
    return '현재 날씨: $description, $temperature도';
  }

  @override
  String get maxTemp => '최고';

  @override
  String get minTemp => '최저';

  @override
  String get precipitationProbability => '강수확률';

  @override
  String get humidity => '습도';

  @override
  String get windSpeed => '풍속';

  @override
  String get feelsLike => '체감';

  @override
  String get pressure => '기압';

  @override
  String get visibility => '시정';

  @override
  String get dewPoint => '이슬점';

  @override
  String get cloudCover => '구름';

  @override
  String get outdoorActivityIndex => '야외 활동 지수';

  @override
  String get hourlyForecast => '시간별 예보';

  @override
  String get dailyForecast => '주간 예보';

  @override
  String get collapse => '접기';

  @override
  String get seeMore => '더보기';

  @override
  String get weatherLoadError => '날씨 정보를 가져올 수 없습니다.';

  @override
  String get searchHint => '도시 이름 검색 (예: 서울, 도쿄...)';

  @override
  String get noResults => '검색 결과가 없습니다.';

  @override
  String get unknown => '알 수 없음';

  @override
  String get notifications => '알림';

  @override
  String get statusBarWeatherNotification => '상태바 날씨 알림';

  @override
  String get statusBarWeatherDesc => '상태바에 현재 날씨를 항상 표시합니다.';

  @override
  String get notificationPermissionRequired =>
      '알림 권한이 필요합니다. 시스템 설정 > 앱 > Zephyr Sky에서 알림을 허용해주세요.';

  @override
  String get appearance => '외관';

  @override
  String get darkMode => '다크 모드';

  @override
  String get darkModeDesc => '어두운 테마 사용';

  @override
  String get unit => '단위';

  @override
  String get celsius => '섭씨 (°C)';

  @override
  String get celsiusDesc => '한국, 유럽 등';

  @override
  String get fahrenheit => '화씨 (°F)';

  @override
  String get fahrenheitDesc => '미국 등';

  @override
  String get favoriteLocations => '즐겨찾기 위치';

  @override
  String get noFavoriteLocations => '즐겨찾기 위치가 없습니다';

  @override
  String get addFavoriteHint => '홈 화면에서 검색 후 추가하세요';

  @override
  String get unknownLocation => '알 수 없는 위치';

  @override
  String latLon(Object lat, Object lon) {
    return '위도: $lat, 경도: $lon';
  }

  @override
  String get addCurrentLocation => '현재 위치 추가';

  @override
  String get info => '정보';

  @override
  String get version => '버전 1.3.0';

  @override
  String get dataSource => '데이터 소스';

  @override
  String get openMeteoApi => 'Open-Meteo API';

  @override
  String get language => '언어';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get weatherClear => '맑음';

  @override
  String get weatherMainlyClear => '대체로 맑음';

  @override
  String get weatherPartlyCloudy => '구름 조금';

  @override
  String get weatherOvercast => '흐림';

  @override
  String get weatherFog => '안개';

  @override
  String get weatherLightDrizzle => '가벼운 이슬비';

  @override
  String get weatherFreezingDrizzle => '결빙 이슬비';

  @override
  String get weatherLightRain => '약한 비';

  @override
  String get weatherModerateRain => '보통 비';

  @override
  String get weatherHeavyRain => '강한 비';

  @override
  String get weatherFreezingRain => '결빙 비';

  @override
  String get weatherLightSnow => '약한 눈';

  @override
  String get weatherModerateSnow => '보통 눈';

  @override
  String get weatherHeavySnow => '강한 눈';

  @override
  String get weatherSnowGrains => '싸락눈';

  @override
  String get weatherRainShowers => '소나기';

  @override
  String get weatherSnowShowers => '눈 소나기';

  @override
  String get weatherThunderstorm => '뇌우';

  @override
  String get weatherThunderstormHail => '우박을 동반한 뇌우';

  @override
  String get weatherUnknown => '알 수 없음';

  @override
  String get aqiUnknown => '알 수 없음';

  @override
  String get aqiGood => '좋음';

  @override
  String get aqiModerate => '보통';

  @override
  String get aqiSensitive => '민감군 불쾌';

  @override
  String get aqiUnhealthy => '불건강';

  @override
  String get aqiVeryUnhealthy => '매우 불건강';

  @override
  String get aqiHazardous => '위험';

  @override
  String get uvUnknown => '알 수 없음';

  @override
  String get uvLow => '낮음';

  @override
  String get uvModerate => '보통';

  @override
  String get uvHigh => '높음';

  @override
  String get uvVeryHigh => '매우 높음';

  @override
  String get uvExtreme => '위험';

  @override
  String get outdoorExcellent => '최상';

  @override
  String get outdoorGood => '양호';

  @override
  String get outdoorFair => '보통';

  @override
  String get outdoorPoor => '나쁨';

  @override
  String get outdoorDangerous => '위험';

  @override
  String get outdoorMsgExcellent => '야외 활동하기 좋은 날씨입니다!';

  @override
  String get outdoorMsgGood => '평소보다 양호합니다';

  @override
  String get outdoorMsgFair => '야외 활동 시 주의가 필요합니다';

  @override
  String get outdoorMsgPoor => '야외 활동에 권장하지 않습니다';

  @override
  String get outdoorMsgDangerous => '야외 활동을 자제해 주세요';

  @override
  String get weatherNotification => '날씨 알림';

  @override
  String get weatherAlert => '날씨 경고';

  @override
  String get weatherNotificationDesc => '현재 날씨 정보를 상태바에 표시합니다.';

  @override
  String get weatherAlertDesc => '날씨 경고 알림을 표시합니다.';

  @override
  String currentTemp(Object temp, Object min, Object max) {
    return '현재: $temp° (최저: $min° / 최고: $max°)';
  }

  @override
  String alertStrongWind(Object speed) {
    return '💨 강한 바람 (${speed}km/h)';
  }

  @override
  String alertColdWave(Object temp) {
    return '❄️ 한파 경보 ($temp°)';
  }

  @override
  String alertHeatWave(Object temp) {
    return '🔥 한열 경보 ($temp°)';
  }

  @override
  String alertHighPrecipitation(Object prob) {
    return '🌧️ 강수 확률 높음 ($prob%)';
  }

  @override
  String alertAirQuality(Object level, Object aqi) {
    return '🌬️ 대기질 $level (AQI: $aqi)';
  }

  @override
  String alertUv(Object level, Object uv) {
    return '☀️ 자외선 $level (UV: $uv)';
  }

  @override
  String get weatherWarnings => '⚠️ 날씨 경고';

  @override
  String lastUpdate(Object time) {
    return '마지막 업데이트: $time';
  }

  @override
  String get locationServiceDisabled => '위치 서비스가 비활성화되어 있습니다. 설정에서 활성화해 주세요.';

  @override
  String get locationPermissionDenied => '위치 권한이 거부되었습니다.';

  @override
  String get locationPermissionPermanentlyDenied =>
      '위치 권한이 영구적으로 거부되었습니다. 설정에서 직접 허용해 주세요.';

  @override
  String get weatherLoadFailed => '날씨 정보를 불러오는 데 실패했습니다.';

  @override
  String aqiLoadFailed(Object error) {
    return 'AQI 정보를 불러오는 데 실패했습니다: $error';
  }

  @override
  String get searchFailed => '위치 검색에 실패했습니다.';

  @override
  String get temperatureTrend => '기온 추이';

  @override
  String get precipitationChance => '강수 확률';

  @override
  String get offlineMode => '오프라인 모드 - 캐시된 데이터 표시 중';

  @override
  String get cacheExpired => '캐시가 만료되었습니다';

  @override
  String minutesAgo(Object count) {
    return '$count분 전';
  }

  @override
  String hoursAgo(Object count) {
    return '$count시간 전';
  }

  @override
  String daysAgo(Object count) {
    return '$count일 전';
  }

  @override
  String get searchOffline => '오프라인 상태에서는 검색할 수 없습니다';

  @override
  String get followSystemTheme => '시스템 테마 따르기';

  @override
  String get followSystemThemeDesc => '기기 설정에 따라 라이트/다크 모드를 자동으로 적용합니다';

  @override
  String get themeColor => '테마 색상';

  @override
  String get skip => '걸러뛰기';

  @override
  String get next => '다음';

  @override
  String get start => '시작하기';

  @override
  String get onboardingWelcomeTitle => 'Zephyr Sky';

  @override
  String get onboardingWelcomeDesc =>
      '아름다운 그라데이션과 함께하는 미니멀리스트 날씨 앱입니다. 정확한 날씨 정보로 당신의 하루를 밝게 비춰드립니다.';

  @override
  String get onboardingLocationTitle => '위치 정보';

  @override
  String get onboardingLocationDesc =>
      '현재 위치의 정확한 날씨를 제공하기 위해 위치 권한이 필요합니다. 위치 데이터는 날씨 조회에만 사용됩니다.';

  @override
  String get onboardingNotificationTitle => '날씨 알림';

  @override
  String get onboardingNotificationDesc =>
      '매일 아침 날씨 정보를 받아보시려면 알림을 허용해주세요. 날씨 경고 시 즉시 알려드립니다.';

  @override
  String get onboardingReadyTitle => '준비 완료!';

  @override
  String get onboardingReadyDesc =>
      '모든 설정이 완료되었습니다. 지금 바로 Zephyr Sky와 함께 날씨를 확인핳세요!';

  @override
  String get shareWeather => '날씨 공유';

  @override
  String shareWeatherText(
      Object city, Object temp, Object condition, Object score) {
    return '지금 $city은 $temp도, $condition. 야외활동지수 $score점 🌤️ (Zephyr Sky)';
  }
}
