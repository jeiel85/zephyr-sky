import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'Zephyr Sky'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get search;

  /// No description provided for @refresh.
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @locationLoading.
  ///
  /// In ko, this message translates to:
  /// **'위치 로드 중...'**
  String get locationLoading;

  /// No description provided for @menuOpen.
  ///
  /// In ko, this message translates to:
  /// **'메뉴 열기'**
  String get menuOpen;

  /// No description provided for @appSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'날씨 및 설정'**
  String get appSubtitle;

  /// No description provided for @searchLocation.
  ///
  /// In ko, this message translates to:
  /// **'위치 검색'**
  String get searchLocation;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @weatherRefresh.
  ///
  /// In ko, this message translates to:
  /// **'날씨 새로고침'**
  String get weatherRefresh;

  /// No description provided for @temperaturePrecipitationTrend.
  ///
  /// In ko, this message translates to:
  /// **'기온 및 강수량 추이'**
  String get temperaturePrecipitationTrend;

  /// No description provided for @currentWeatherLabel.
  ///
  /// In ko, this message translates to:
  /// **'현재 날씨: {description}, {temperature}도'**
  String currentWeatherLabel(Object description, Object temperature);

  /// No description provided for @maxTemp.
  ///
  /// In ko, this message translates to:
  /// **'최고'**
  String get maxTemp;

  /// No description provided for @minTemp.
  ///
  /// In ko, this message translates to:
  /// **'최저'**
  String get minTemp;

  /// No description provided for @precipitationProbability.
  ///
  /// In ko, this message translates to:
  /// **'강수확률'**
  String get precipitationProbability;

  /// No description provided for @humidity.
  ///
  /// In ko, this message translates to:
  /// **'습도'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In ko, this message translates to:
  /// **'풍속'**
  String get windSpeed;

  /// No description provided for @feelsLike.
  ///
  /// In ko, this message translates to:
  /// **'체감'**
  String get feelsLike;

  /// No description provided for @pressure.
  ///
  /// In ko, this message translates to:
  /// **'기압'**
  String get pressure;

  /// No description provided for @visibility.
  ///
  /// In ko, this message translates to:
  /// **'시정'**
  String get visibility;

  /// No description provided for @dewPoint.
  ///
  /// In ko, this message translates to:
  /// **'이슬점'**
  String get dewPoint;

  /// No description provided for @cloudCover.
  ///
  /// In ko, this message translates to:
  /// **'구름'**
  String get cloudCover;

  /// No description provided for @outdoorActivityIndex.
  ///
  /// In ko, this message translates to:
  /// **'야외 활동 지수'**
  String get outdoorActivityIndex;

  /// No description provided for @hourlyForecast.
  ///
  /// In ko, this message translates to:
  /// **'시간별 예보'**
  String get hourlyForecast;

  /// No description provided for @dailyForecast.
  ///
  /// In ko, this message translates to:
  /// **'주간 예보'**
  String get dailyForecast;

  /// No description provided for @collapse.
  ///
  /// In ko, this message translates to:
  /// **'접기'**
  String get collapse;

  /// No description provided for @seeMore.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get seeMore;

  /// No description provided for @weatherLoadError.
  ///
  /// In ko, this message translates to:
  /// **'날씨 정보를 가져올 수 없습니다.'**
  String get weatherLoadError;

  /// No description provided for @searchHint.
  ///
  /// In ko, this message translates to:
  /// **'도시 이름 검색 (예: 서울, 도쿄...)'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다.'**
  String get noResults;

  /// No description provided for @unknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없음'**
  String get unknown;

  /// No description provided for @notifications.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notifications;

  /// No description provided for @statusBarWeatherNotification.
  ///
  /// In ko, this message translates to:
  /// **'상태바 날씨 알림'**
  String get statusBarWeatherNotification;

  /// No description provided for @statusBarWeatherDesc.
  ///
  /// In ko, this message translates to:
  /// **'상태바에 현재 날씨를 항상 표시합니다.'**
  String get statusBarWeatherDesc;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In ko, this message translates to:
  /// **'알림 권한이 필요합니다. 시스템 설정 > 앱 > Zephyr Sky에서 알림을 허용해주세요.'**
  String get notificationPermissionRequired;

  /// No description provided for @appearance.
  ///
  /// In ko, this message translates to:
  /// **'외관'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get darkMode;

  /// No description provided for @darkModeDesc.
  ///
  /// In ko, this message translates to:
  /// **'어두운 테마 사용'**
  String get darkModeDesc;

  /// No description provided for @unit.
  ///
  /// In ko, this message translates to:
  /// **'단위'**
  String get unit;

  /// No description provided for @celsius.
  ///
  /// In ko, this message translates to:
  /// **'섭씨 (°C)'**
  String get celsius;

  /// No description provided for @celsiusDesc.
  ///
  /// In ko, this message translates to:
  /// **'한국, 유럽 등'**
  String get celsiusDesc;

  /// No description provided for @fahrenheit.
  ///
  /// In ko, this message translates to:
  /// **'화씨 (°F)'**
  String get fahrenheit;

  /// No description provided for @fahrenheitDesc.
  ///
  /// In ko, this message translates to:
  /// **'미국 등'**
  String get fahrenheitDesc;

  /// No description provided for @favoriteLocations.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 위치'**
  String get favoriteLocations;

  /// No description provided for @noFavoriteLocations.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 위치가 없습니다'**
  String get noFavoriteLocations;

  /// No description provided for @addFavoriteHint.
  ///
  /// In ko, this message translates to:
  /// **'홈 화면에서 검색 후 추가하세요'**
  String get addFavoriteHint;

  /// No description provided for @unknownLocation.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 위치'**
  String get unknownLocation;

  /// No description provided for @latLon.
  ///
  /// In ko, this message translates to:
  /// **'위도: {lat}, 경도: {lon}'**
  String latLon(Object lat, Object lon);

  /// No description provided for @addCurrentLocation.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치 추가'**
  String get addCurrentLocation;

  /// No description provided for @info.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get info;

  /// No description provided for @version.
  ///
  /// In ko, this message translates to:
  /// **'버전 1.3.0'**
  String get version;

  /// No description provided for @dataSource.
  ///
  /// In ko, this message translates to:
  /// **'데이터 소스'**
  String get dataSource;

  /// No description provided for @openMeteoApi.
  ///
  /// In ko, this message translates to:
  /// **'Open-Meteo API'**
  String get openMeteoApi;

  /// No description provided for @language.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// No description provided for @korean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @english.
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @weatherClear.
  ///
  /// In ko, this message translates to:
  /// **'맑음'**
  String get weatherClear;

  /// No description provided for @weatherMainlyClear.
  ///
  /// In ko, this message translates to:
  /// **'대체로 맑음'**
  String get weatherMainlyClear;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In ko, this message translates to:
  /// **'구름 조금'**
  String get weatherPartlyCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In ko, this message translates to:
  /// **'흐림'**
  String get weatherOvercast;

  /// No description provided for @weatherFog.
  ///
  /// In ko, this message translates to:
  /// **'안개'**
  String get weatherFog;

  /// No description provided for @weatherLightDrizzle.
  ///
  /// In ko, this message translates to:
  /// **'가벼운 이슬비'**
  String get weatherLightDrizzle;

  /// No description provided for @weatherFreezingDrizzle.
  ///
  /// In ko, this message translates to:
  /// **'결빙 이슬비'**
  String get weatherFreezingDrizzle;

  /// No description provided for @weatherLightRain.
  ///
  /// In ko, this message translates to:
  /// **'약한 비'**
  String get weatherLightRain;

  /// No description provided for @weatherModerateRain.
  ///
  /// In ko, this message translates to:
  /// **'보통 비'**
  String get weatherModerateRain;

  /// No description provided for @weatherHeavyRain.
  ///
  /// In ko, this message translates to:
  /// **'강한 비'**
  String get weatherHeavyRain;

  /// No description provided for @weatherFreezingRain.
  ///
  /// In ko, this message translates to:
  /// **'결빙 비'**
  String get weatherFreezingRain;

  /// No description provided for @weatherLightSnow.
  ///
  /// In ko, this message translates to:
  /// **'약한 눈'**
  String get weatherLightSnow;

  /// No description provided for @weatherModerateSnow.
  ///
  /// In ko, this message translates to:
  /// **'보통 눈'**
  String get weatherModerateSnow;

  /// No description provided for @weatherHeavySnow.
  ///
  /// In ko, this message translates to:
  /// **'강한 눈'**
  String get weatherHeavySnow;

  /// No description provided for @weatherSnowGrains.
  ///
  /// In ko, this message translates to:
  /// **'싸락눈'**
  String get weatherSnowGrains;

  /// No description provided for @weatherRainShowers.
  ///
  /// In ko, this message translates to:
  /// **'소나기'**
  String get weatherRainShowers;

  /// No description provided for @weatherSnowShowers.
  ///
  /// In ko, this message translates to:
  /// **'눈 소나기'**
  String get weatherSnowShowers;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In ko, this message translates to:
  /// **'뇌우'**
  String get weatherThunderstorm;

  /// No description provided for @weatherThunderstormHail.
  ///
  /// In ko, this message translates to:
  /// **'우박을 동반한 뇌우'**
  String get weatherThunderstormHail;

  /// No description provided for @weatherUnknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없음'**
  String get weatherUnknown;

  /// No description provided for @aqiUnknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없음'**
  String get aqiUnknown;

  /// No description provided for @aqiGood.
  ///
  /// In ko, this message translates to:
  /// **'좋음'**
  String get aqiGood;

  /// No description provided for @aqiModerate.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get aqiModerate;

  /// No description provided for @aqiSensitive.
  ///
  /// In ko, this message translates to:
  /// **'민감군 불쾌'**
  String get aqiSensitive;

  /// No description provided for @aqiUnhealthy.
  ///
  /// In ko, this message translates to:
  /// **'불건강'**
  String get aqiUnhealthy;

  /// No description provided for @aqiVeryUnhealthy.
  ///
  /// In ko, this message translates to:
  /// **'매우 불건강'**
  String get aqiVeryUnhealthy;

  /// No description provided for @aqiHazardous.
  ///
  /// In ko, this message translates to:
  /// **'위험'**
  String get aqiHazardous;

  /// No description provided for @uvUnknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없음'**
  String get uvUnknown;

  /// No description provided for @uvLow.
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get uvLow;

  /// No description provided for @uvModerate.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get uvModerate;

  /// No description provided for @uvHigh.
  ///
  /// In ko, this message translates to:
  /// **'높음'**
  String get uvHigh;

  /// No description provided for @uvVeryHigh.
  ///
  /// In ko, this message translates to:
  /// **'매우 높음'**
  String get uvVeryHigh;

  /// No description provided for @uvExtreme.
  ///
  /// In ko, this message translates to:
  /// **'위험'**
  String get uvExtreme;

  /// No description provided for @outdoorExcellent.
  ///
  /// In ko, this message translates to:
  /// **'최상'**
  String get outdoorExcellent;

  /// No description provided for @outdoorGood.
  ///
  /// In ko, this message translates to:
  /// **'양호'**
  String get outdoorGood;

  /// No description provided for @outdoorFair.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get outdoorFair;

  /// No description provided for @outdoorPoor.
  ///
  /// In ko, this message translates to:
  /// **'나쁨'**
  String get outdoorPoor;

  /// No description provided for @outdoorDangerous.
  ///
  /// In ko, this message translates to:
  /// **'위험'**
  String get outdoorDangerous;

  /// No description provided for @outdoorMsgExcellent.
  ///
  /// In ko, this message translates to:
  /// **'야외 활동하기 좋은 날씨입니다!'**
  String get outdoorMsgExcellent;

  /// No description provided for @outdoorMsgGood.
  ///
  /// In ko, this message translates to:
  /// **'평소보다 양호합니다'**
  String get outdoorMsgGood;

  /// No description provided for @outdoorMsgFair.
  ///
  /// In ko, this message translates to:
  /// **'야외 활동 시 주의가 필요합니다'**
  String get outdoorMsgFair;

  /// No description provided for @outdoorMsgPoor.
  ///
  /// In ko, this message translates to:
  /// **'야외 활동에 권장하지 않습니다'**
  String get outdoorMsgPoor;

  /// No description provided for @outdoorMsgDangerous.
  ///
  /// In ko, this message translates to:
  /// **'야외 활동을 자제해 주세요'**
  String get outdoorMsgDangerous;

  /// No description provided for @weatherNotification.
  ///
  /// In ko, this message translates to:
  /// **'날씨 알림'**
  String get weatherNotification;

  /// No description provided for @weatherAlert.
  ///
  /// In ko, this message translates to:
  /// **'날씨 경고'**
  String get weatherAlert;

  /// No description provided for @weatherNotificationDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재 날씨 정보를 상태바에 표시합니다.'**
  String get weatherNotificationDesc;

  /// No description provided for @weatherAlertDesc.
  ///
  /// In ko, this message translates to:
  /// **'날씨 경고 알림을 표시합니다.'**
  String get weatherAlertDesc;

  /// No description provided for @currentTemp.
  ///
  /// In ko, this message translates to:
  /// **'현재: {temp}° (최저: {min}° / 최고: {max}°)'**
  String currentTemp(Object temp, Object min, Object max);

  /// No description provided for @alertStrongWind.
  ///
  /// In ko, this message translates to:
  /// **'💨 강한 바람 ({speed}km/h)'**
  String alertStrongWind(Object speed);

  /// No description provided for @alertColdWave.
  ///
  /// In ko, this message translates to:
  /// **'❄️ 한파 경보 ({temp}°)'**
  String alertColdWave(Object temp);

  /// No description provided for @alertHeatWave.
  ///
  /// In ko, this message translates to:
  /// **'🔥 한열 경보 ({temp}°)'**
  String alertHeatWave(Object temp);

  /// No description provided for @alertHighPrecipitation.
  ///
  /// In ko, this message translates to:
  /// **'🌧️ 강수 확률 높음 ({prob}%)'**
  String alertHighPrecipitation(Object prob);

  /// No description provided for @alertAirQuality.
  ///
  /// In ko, this message translates to:
  /// **'🌬️ 대기질 {level} (AQI: {aqi})'**
  String alertAirQuality(Object level, Object aqi);

  /// No description provided for @alertUv.
  ///
  /// In ko, this message translates to:
  /// **'☀️ 자외선 {level} (UV: {uv})'**
  String alertUv(Object level, Object uv);

  /// No description provided for @weatherWarnings.
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 날씨 경고'**
  String get weatherWarnings;

  /// No description provided for @lastUpdate.
  ///
  /// In ko, this message translates to:
  /// **'마지막 업데이트: {time}'**
  String lastUpdate(Object time);

  /// No description provided for @locationServiceDisabled.
  ///
  /// In ko, this message translates to:
  /// **'위치 서비스가 비활성화되어 있습니다. 설정에서 활성화해 주세요.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 거부되었습니다.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 영구적으로 거부되었습니다. 설정에서 직접 허용해 주세요.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @weatherLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'날씨 정보를 불러오는 데 실패했습니다.'**
  String get weatherLoadFailed;

  /// No description provided for @aqiLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'AQI 정보를 불러오는 데 실패했습니다: {error}'**
  String aqiLoadFailed(Object error);

  /// No description provided for @searchFailed.
  ///
  /// In ko, this message translates to:
  /// **'위치 검색에 실패했습니다.'**
  String get searchFailed;

  /// No description provided for @temperatureTrend.
  ///
  /// In ko, this message translates to:
  /// **'기온 추이'**
  String get temperatureTrend;

  /// No description provided for @precipitationChance.
  ///
  /// In ko, this message translates to:
  /// **'강수 확률'**
  String get precipitationChance;

  /// No description provided for @offlineMode.
  ///
  /// In ko, this message translates to:
  /// **'오프라인 모드 - 캐시된 데이터 표시 중'**
  String get offlineMode;

  /// No description provided for @cacheExpired.
  ///
  /// In ko, this message translates to:
  /// **'캐시가 만료되었습니다'**
  String get cacheExpired;

  /// No description provided for @minutesAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}분 전'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}시간 전'**
  String hoursAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}일 전'**
  String daysAgo(Object count);

  /// No description provided for @searchOffline.
  ///
  /// In ko, this message translates to:
  /// **'오프라인 상태에서는 검색할 수 없습니다'**
  String get searchOffline;

  /// No description provided for @followSystemTheme.
  ///
  /// In ko, this message translates to:
  /// **'시스템 테마 따르기'**
  String get followSystemTheme;

  /// No description provided for @followSystemThemeDesc.
  ///
  /// In ko, this message translates to:
  /// **'기기 설정에 따라 라이트/다크 모드를 자동으로 적용합니다'**
  String get followSystemThemeDesc;

  /// No description provided for @themeColor.
  ///
  /// In ko, this message translates to:
  /// **'테마 색상'**
  String get themeColor;

  /// No description provided for @skip.
  ///
  /// In ko, this message translates to:
  /// **'걸러뛰기'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get next;

  /// No description provided for @start.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get start;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'Zephyr Sky'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In ko, this message translates to:
  /// **'아름다운 그라데이션과 함께하는 미니멀리스트 날씨 앱입니다. 정확한 날씨 정보로 당신의 하루를 밝게 비춰드립니다.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingLocationTitle.
  ///
  /// In ko, this message translates to:
  /// **'위치 정보'**
  String get onboardingLocationTitle;

  /// No description provided for @onboardingLocationDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치의 정확한 날씨를 제공하기 위해 위치 권한이 필요합니다. 위치 데이터는 날씨 조회에만 사용됩니다.'**
  String get onboardingLocationDesc;

  /// No description provided for @onboardingNotificationTitle.
  ///
  /// In ko, this message translates to:
  /// **'날씨 알림'**
  String get onboardingNotificationTitle;

  /// No description provided for @onboardingNotificationDesc.
  ///
  /// In ko, this message translates to:
  /// **'매일 아침 날씨 정보를 받아보시려면 알림을 허용해주세요. 날씨 경고 시 즉시 알려드립니다.'**
  String get onboardingNotificationDesc;

  /// No description provided for @onboardingReadyTitle.
  ///
  /// In ko, this message translates to:
  /// **'준비 완료!'**
  String get onboardingReadyTitle;

  /// No description provided for @onboardingReadyDesc.
  ///
  /// In ko, this message translates to:
  /// **'모든 설정이 완료되었습니다. 지금 바로 Zephyr Sky와 함께 날씨를 확인핳세요!'**
  String get onboardingReadyDesc;

  /// No description provided for @shareWeather.
  ///
  /// In ko, this message translates to:
  /// **'날씨 공유'**
  String get shareWeather;

  /// No description provided for @shareWeatherText.
  ///
  /// In ko, this message translates to:
  /// **'지금 {city}은 {temp}도, {condition}. 야외활동지수 {score}점 🌤️ (Zephyr Sky)'**
  String shareWeatherText(
      Object city, Object temp, Object condition, Object score);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
