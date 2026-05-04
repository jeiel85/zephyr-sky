import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
///   intl: any # Use the latest version of intl
///
/// flutter:
///   generate: true # Optional, but recommended
/// ```
///
/// ## Implementation details
///
/// This file was manually generated as a replacement for the flutter gen-l10n
/// tool because the flutter CLI was not available in the environment.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
  /// In en, this message translates to:
  /// **'Zephyr Sky'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @locationLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading location...'**
  String get locationLoading;

  /// No description provided for @menuOpen.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get menuOpen;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weather & Settings'**
  String get appSubtitle;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search Location'**
  String get searchLocation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @weatherRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh Weather'**
  String get weatherRefresh;

  /// No description provided for @temperaturePrecipitationTrend.
  ///
  /// In en, this message translates to:
  /// **'Temperature & Precipitation Trend'**
  String get temperaturePrecipitationTrend;

  /// No description provided for @currentWeatherLabel.
  ///
  /// In en, this message translates to:
  /// **'Current weather: {description}, {temperature}°'**
  String currentWeatherLabel(Object description, Object temperature);

  /// No description provided for @maxTemp.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get maxTemp;

  /// No description provided for @minTemp.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get minTemp;

  /// No description provided for @precipitationProbability.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get precipitationProbability;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get windSpeed;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels Like'**
  String get feelsLike;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @dewPoint.
  ///
  /// In en, this message translates to:
  /// **'Dew Point'**
  String get dewPoint;

  /// No description provided for @cloudCover.
  ///
  /// In en, this message translates to:
  /// **'Clouds'**
  String get cloudCover;

  /// No description provided for @outdoorActivityIndex.
  ///
  /// In en, this message translates to:
  /// **'Outdoor Activity Index'**
  String get outdoorActivityIndex;

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// No description provided for @dailyForecast.
  ///
  /// In en, this message translates to:
  /// **'Weekly Forecast'**
  String get dailyForecast;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @weatherLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to retrieve weather information.'**
  String get weatherLoadError;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search city name (e.g. Seoul, Tokyo...)'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No search results found.'**
  String get noResults;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @statusBarWeatherNotification.
  ///
  /// In en, this message translates to:
  /// **'Status Bar Weather'**
  String get statusBarWeatherNotification;

  /// No description provided for @statusBarWeatherDesc.
  ///
  /// In en, this message translates to:
  /// **'Always show current weather in the status bar.'**
  String get statusBarWeatherDesc;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required. Please allow notifications in Settings > Apps > Zephyr Sky.'**
  String get notificationPermissionRequired;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get darkModeDesc;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get celsius;

  /// No description provided for @celsiusDesc.
  ///
  /// In en, this message translates to:
  /// **'Korea, Europe, etc.'**
  String get celsiusDesc;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get fahrenheit;

  /// No description provided for @fahrenheitDesc.
  ///
  /// In en, this message translates to:
  /// **'USA, etc.'**
  String get fahrenheitDesc;

  /// No description provided for @favoriteLocations.
  ///
  /// In en, this message translates to:
  /// **'Favorite Locations'**
  String get favoriteLocations;

  /// No description provided for @noFavoriteLocations.
  ///
  /// In en, this message translates to:
  /// **'No favorite locations'**
  String get noFavoriteLocations;

  /// No description provided for @addFavoriteHint.
  ///
  /// In en, this message translates to:
  /// **'Search and add from the home screen'**
  String get addFavoriteHint;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknownLocation;

  /// No description provided for @latLon.
  ///
  /// In en, this message translates to:
  /// **'Lat: {lat}, Lon: {lon}'**
  String latLon(Object lat, Object lon);

  /// No description provided for @addCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Current Location'**
  String get addCurrentLocation;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get info;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.2.2'**
  String get version;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get dataSource;

  /// No description provided for @openMeteoApi.
  ///
  /// In en, this message translates to:
  /// **'Open-Meteo API'**
  String get openMeteoApi;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// No description provided for @weatherMainlyClear.
  ///
  /// In en, this message translates to:
  /// **'Mainly Clear'**
  String get weatherMainlyClear;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly Cloudy'**
  String get weatherPartlyCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get weatherOvercast;

  /// No description provided for @weatherFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherFog;

  /// No description provided for @weatherLightDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Light Drizzle'**
  String get weatherLightDrizzle;

  /// No description provided for @weatherFreezingDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Freezing Drizzle'**
  String get weatherFreezingDrizzle;

  /// No description provided for @weatherLightRain.
  ///
  /// In en, this message translates to:
  /// **'Light Rain'**
  String get weatherLightRain;

  /// No description provided for @weatherModerateRain.
  ///
  /// In en, this message translates to:
  /// **'Moderate Rain'**
  String get weatherModerateRain;

  /// No description provided for @weatherHeavyRain.
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain'**
  String get weatherHeavyRain;

  /// No description provided for @weatherFreezingRain.
  ///
  /// In en, this message translates to:
  /// **'Freezing Rain'**
  String get weatherFreezingRain;

  /// No description provided for @weatherLightSnow.
  ///
  /// In en, this message translates to:
  /// **'Light Snow'**
  String get weatherLightSnow;

  /// No description provided for @weatherModerateSnow.
  ///
  /// In en, this message translates to:
  /// **'Moderate Snow'**
  String get weatherModerateSnow;

  /// No description provided for @weatherHeavySnow.
  ///
  /// In en, this message translates to:
  /// **'Heavy Snow'**
  String get weatherHeavySnow;

  /// No description provided for @weatherSnowGrains.
  ///
  /// In en, this message translates to:
  /// **'Snow Grains'**
  String get weatherSnowGrains;

  /// No description provided for @weatherRainShowers.
  ///
  /// In en, this message translates to:
  /// **'Rain Showers'**
  String get weatherRainShowers;

  /// No description provided for @weatherSnowShowers.
  ///
  /// In en, this message translates to:
  /// **'Snow Showers'**
  String get weatherSnowShowers;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherThunderstorm;

  /// No description provided for @weatherThunderstormHail.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm with Hail'**
  String get weatherThunderstormHail;

  /// No description provided for @weatherUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get weatherUnknown;

  /// No description provided for @aqiUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get aqiUnknown;

  /// No description provided for @aqiGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get aqiGood;

  /// No description provided for @aqiModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get aqiModerate;

  /// No description provided for @aqiSensitive.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy for Sensitive Groups'**
  String get aqiSensitive;

  /// No description provided for @aqiUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get aqiUnhealthy;

  /// No description provided for @aqiVeryUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Very Unhealthy'**
  String get aqiVeryUnhealthy;

  /// No description provided for @aqiHazardous.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get aqiHazardous;

  /// No description provided for @uvUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get uvUnknown;

  /// No description provided for @uvLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get uvLow;

  /// No description provided for @uvModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get uvModerate;

  /// No description provided for @uvHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get uvHigh;

  /// No description provided for @uvVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get uvVeryHigh;

  /// No description provided for @uvExtreme.
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get uvExtreme;

  /// No description provided for @outdoorExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get outdoorExcellent;

  /// No description provided for @outdoorGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get outdoorGood;

  /// No description provided for @outdoorFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get outdoorFair;

  /// No description provided for @outdoorPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get outdoorPoor;

  /// No description provided for @outdoorDangerous.
  ///
  /// In en, this message translates to:
  /// **'Dangerous'**
  String get outdoorDangerous;

  /// No description provided for @outdoorMsgExcellent.
  ///
  /// In en, this message translates to:
  /// **'Great weather for outdoor activities!'**
  String get outdoorMsgExcellent;

  /// No description provided for @outdoorMsgGood.
  ///
  /// In en, this message translates to:
  /// **'Better than usual'**
  String get outdoorMsgGood;

  /// No description provided for @outdoorMsgFair.
  ///
  /// In en, this message translates to:
  /// **'Be careful during outdoor activities'**
  String get outdoorMsgFair;

  /// No description provided for @outdoorMsgPoor.
  ///
  /// In en, this message translates to:
  /// **'Not recommended for outdoor activities'**
  String get outdoorMsgPoor;

  /// No description provided for @outdoorMsgDangerous.
  ///
  /// In en, this message translates to:
  /// **'Please avoid outdoor activities'**
  String get outdoorMsgDangerous;

  /// No description provided for @weatherNotification.
  ///
  /// In en, this message translates to:
  /// **'Weather Notification'**
  String get weatherNotification;

  /// No description provided for @weatherAlert.
  ///
  /// In en, this message translates to:
  /// **'Weather Alert'**
  String get weatherAlert;

  /// No description provided for @weatherNotificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Show current weather in the status bar.'**
  String get weatherNotificationDesc;

  /// No description provided for @weatherAlertDesc.
  ///
  /// In en, this message translates to:
  /// **'Show weather alert notifications.'**
  String get weatherAlertDesc;

  /// No description provided for @currentTemp.
  ///
  /// In en, this message translates to:
  /// **'Now: {temp}° (Low: {min}° / High: {max}°)'**
  String currentTemp(Object temp, Object min, Object max);

  /// No description provided for @alertStrongWind.
  ///
  /// In en, this message translates to:
  /// **'💨 Strong Wind ({speed}km/h)'**
  String alertStrongWind(Object speed);

  /// No description provided for @alertColdWave.
  ///
  /// In en, this message translates to:
  /// **'❄️ Cold Wave Warning ({temp}°)'**
  String alertColdWave(Object temp);

  /// No description provided for @alertHeatWave.
  ///
  /// In en, this message translates to:
  /// **'🔥 Heat Wave Warning ({temp}°)'**
  String alertHeatWave(Object temp);

  /// No description provided for @alertHighPrecipitation.
  ///
  /// In en, this message translates to:
  /// **'🌧️ High Precipitation ({prob}%)'**
  String alertHighPrecipitation(Object prob);

  /// No description provided for @alertAirQuality.
  ///
  /// In en, this message translates to:
  /// **'🌬️ Air Quality {level} (AQI: {aqi})'**
  String alertAirQuality(Object level, Object aqi);

  /// No description provided for @alertUv.
  ///
  /// In en, this message translates to:
  /// **'☀️ UV {level} (UV: {uv})'**
  String alertUv(Object level, Object uv);

  /// No description provided for @weatherWarnings.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Weather Warnings'**
  String get weatherWarnings;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update: {time}'**
  String lastUpdate(Object time);

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable them in Settings.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Please allow it in Settings.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @weatherLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load weather information.'**
  String get weatherLoadFailed;

  /// No description provided for @aqiLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load AQI information: {error}'**
  String aqiLoadFailed(Object error);

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Location search failed.'**
  String get searchFailed;

  /// No description provided for @temperatureTrend.
  ///
  /// In en, this message translates to:
  /// **'Temperature Trend'**
  String get temperatureTrend;

  /// No description provided for @precipitationChance.
  ///
  /// In en, this message translates to:
  /// **'Precipitation Chance'**
  String get precipitationChance;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with '
    'a reproducible sample app and the gen-l10n configuration that was used.'
  );
}

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Zephyr Sky';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get locationLoading => 'Loading location...';

  @override
  String get menuOpen => 'Open menu';

  @override
  String get appSubtitle => 'Weather & Settings';

  @override
  String get searchLocation => 'Search Location';

  @override
  String get settings => 'Settings';

  @override
  String get weatherRefresh => 'Refresh Weather';

  @override
  String get temperaturePrecipitationTrend => 'Temperature & Precipitation Trend';

  @override
  String currentWeatherLabel(Object description, Object temperature) {
    return 'Current weather: $description, $temperature°';
  }

  @override
  String get maxTemp => 'High';

  @override
  String get minTemp => 'Low';

  @override
  String get precipitationProbability => 'Precipitation';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind';

  @override
  String get feelsLike => 'Feels Like';

  @override
  String get pressure => 'Pressure';

  @override
  String get visibility => 'Visibility';

  @override
  String get dewPoint => 'Dew Point';

  @override
  String get cloudCover => 'Clouds';

  @override
  String get outdoorActivityIndex => 'Outdoor Activity Index';

  @override
  String get hourlyForecast => 'Hourly Forecast';

  @override
  String get dailyForecast => 'Weekly Forecast';

  @override
  String get collapse => 'Collapse';

  @override
  String get seeMore => 'See More';

  @override
  String get weatherLoadError => 'Unable to retrieve weather information.';

  @override
  String get searchHint => 'Search city name (e.g. Seoul, Tokyo...)';

  @override
  String get noResults => 'No search results found.';

  @override
  String get unknown => 'Unknown';

  @override
  String get notifications => 'Notifications';

  @override
  String get statusBarWeatherNotification => 'Status Bar Weather';

  @override
  String get statusBarWeatherDesc => 'Always show current weather in the status bar.';

  @override
  String get notificationPermissionRequired => 'Notification permission is required. Please allow notifications in Settings > Apps > Zephyr Sky.';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDesc => 'Use dark theme';

  @override
  String get unit => 'Unit';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get celsiusDesc => 'Korea, Europe, etc.';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get fahrenheitDesc => 'USA, etc.';

  @override
  String get favoriteLocations => 'Favorite Locations';

  @override
  String get noFavoriteLocations => 'No favorite locations';

  @override
  String get addFavoriteHint => 'Search and add from the home screen';

  @override
  String get unknownLocation => 'Unknown Location';

  @override
  String latLon(Object lat, Object lon) {
    return 'Lat: $lat, Lon: $lon';
  }

  @override
  String get addCurrentLocation => 'Add Current Location';

  @override
  String get info => 'About';

  @override
  String get version => 'Version 1.2.2';

  @override
  String get dataSource => 'Data Source';

  @override
  String get openMeteoApi => 'Open-Meteo API';

  @override
  String get language => 'Language';

  @override
  String get korean => 'Korean';

  @override
  String get english => 'English';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherMainlyClear => 'Mainly Clear';

  @override
  String get weatherPartlyCloudy => 'Partly Cloudy';

  @override
  String get weatherOvercast => 'Overcast';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherLightDrizzle => 'Light Drizzle';

  @override
  String get weatherFreezingDrizzle => 'Freezing Drizzle';

  @override
  String get weatherLightRain => 'Light Rain';

  @override
  String get weatherModerateRain => 'Moderate Rain';

  @override
  String get weatherHeavyRain => 'Heavy Rain';

  @override
  String get weatherFreezingRain => 'Freezing Rain';

  @override
  String get weatherLightSnow => 'Light Snow';

  @override
  String get weatherModerateSnow => 'Moderate Snow';

  @override
  String get weatherHeavySnow => 'Heavy Snow';

  @override
  String get weatherSnowGrains => 'Snow Grains';

  @override
  String get weatherRainShowers => 'Rain Showers';

  @override
  String get weatherSnowShowers => 'Snow Showers';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get weatherThunderstormHail => 'Thunderstorm with Hail';

  @override
  String get weatherUnknown => 'Unknown';

  @override
  String get aqiUnknown => 'Unknown';

  @override
  String get aqiGood => 'Good';

  @override
  String get aqiModerate => 'Moderate';

  @override
  String get aqiSensitive => 'Unhealthy for Sensitive Groups';

  @override
  String get aqiUnhealthy => 'Unhealthy';

  @override
  String get aqiVeryUnhealthy => 'Very Unhealthy';

  @override
  String get aqiHazardous => 'Hazardous';

  @override
  String get uvUnknown => 'Unknown';

  @override
  String get uvLow => 'Low';

  @override
  String get uvModerate => 'Moderate';

  @override
  String get uvHigh => 'High';

  @override
  String get uvVeryHigh => 'Very High';

  @override
  String get uvExtreme => 'Extreme';

  @override
  String get outdoorExcellent => 'Excellent';

  @override
  String get outdoorGood => 'Good';

  @override
  String get outdoorFair => 'Fair';

  @override
  String get outdoorPoor => 'Poor';

  @override
  String get outdoorDangerous => 'Dangerous';

  @override
  String get outdoorMsgExcellent => 'Great weather for outdoor activities!';

  @override
  String get outdoorMsgGood => 'Better than usual';

  @override
  String get outdoorMsgFair => 'Be careful during outdoor activities';

  @override
  String get outdoorMsgPoor => 'Not recommended for outdoor activities';

  @override
  String get outdoorMsgDangerous => 'Please avoid outdoor activities';

  @override
  String get weatherNotification => 'Weather Notification';

  @override
  String get weatherAlert => 'Weather Alert';

  @override
  String get weatherNotificationDesc => 'Show current weather in the status bar.';

  @override
  String get weatherAlertDesc => 'Show weather alert notifications.';

  @override
  String currentTemp(Object temp, Object min, Object max) {
    return 'Now: $temp° (Low: $min° / High: $max°)';
  }

  @override
  String alertStrongWind(Object speed) {
    return '💨 Strong Wind (${speed}km/h)';
  }

  @override
  String alertColdWave(Object temp) {
    return '❄️ Cold Wave Warning ($temp°)';
  }

  @override
  String alertHeatWave(Object temp) {
    return '🔥 Heat Wave Warning ($temp°)';
  }

  @override
  String alertHighPrecipitation(Object prob) {
    return '🌧️ High Precipitation ($prob%)';
  }

  @override
  String alertAirQuality(Object level, Object aqi) {
    return '🌬️ Air Quality $level (AQI: $aqi)';
  }

  @override
  String alertUv(Object level, Object uv) {
    return '☀️ UV $level (UV: $uv)';
  }

  @override
  String get weatherWarnings => '⚠️ Weather Warnings';

  @override
  String lastUpdate(Object time) {
    return 'Last Update: $time';
  }

  @override
  String get locationServiceDisabled => 'Location services are disabled. Please enable them in Settings.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationPermissionPermanentlyDenied => 'Location permission permanently denied. Please allow it in Settings.';

  @override
  String get weatherLoadFailed => 'Failed to load weather information.';

  @override
  String aqiLoadFailed(Object error) {
    return 'Failed to load AQI information: $error';
  }

  @override
  String get searchFailed => 'Location search failed.';

  @override
  String get temperatureTrend => 'Temperature Trend';

  @override
  String get precipitationChance => 'Precipitation Chance';
}

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
  String get notificationPermissionRequired => '알림 권한이 필요합니다. 시스템 설정 > 앱 > Zephyr Sky에서 알림을 허용해주세요.';

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
  String get version => '버전 1.2.2';

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
  String get locationPermissionPermanentlyDenied => '위치 권한이 영구적으로 거부되었습니다. 설정에서 직접 허용해 주세요.';

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
}
