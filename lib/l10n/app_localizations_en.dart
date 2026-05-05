// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get temperaturePrecipitationTrend =>
      'Temperature & Precipitation Trend';

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
  String get statusBarWeatherDesc =>
      'Always show current weather in the status bar.';

  @override
  String get notificationPermissionRequired =>
      'Notification permission is required. Please allow notifications in Settings > Apps > Zephyr Sky.';

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
  String get version => 'Version 1.3.0';

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
  String get weatherNotificationDesc =>
      'Show current weather in the status bar.';

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
  String get locationServiceDisabled =>
      'Location services are disabled. Please enable them in Settings.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied. Please allow it in Settings.';

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

  @override
  String get offlineMode => 'Offline mode - showing cached data';

  @override
  String get cacheExpired => 'Cache has expired';

  @override
  String minutesAgo(Object count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String get searchOffline => 'Search is not available in offline mode';

  @override
  String get followSystemTheme => 'Follow system theme';

  @override
  String get followSystemThemeDesc =>
      'Automatically apply light or dark mode based on device settings';

  @override
  String get themeColor => 'Theme color';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get start => 'Get Started';

  @override
  String get onboardingWelcomeTitle => 'Zephyr Sky';

  @override
  String get onboardingWelcomeDesc =>
      'A minimalist weather app with beautiful gradients. Brighten your day with accurate weather information.';

  @override
  String get onboardingLocationTitle => 'Location Access';

  @override
  String get onboardingLocationDesc =>
      'Location permission is needed to provide accurate weather for your current position. Location data is only used for weather lookup.';

  @override
  String get onboardingNotificationTitle => 'Weather Alerts';

  @override
  String get onboardingNotificationDesc =>
      'Allow notifications to receive daily weather updates. We\'ll alert you immediately for weather warnings.';

  @override
  String get onboardingReadyTitle => 'All Set!';

  @override
  String get onboardingReadyDesc =>
      'Everything is ready. Start checking the weather with Zephyr Sky now!';

  @override
  String get shareWeather => 'Share Weather';

  @override
  String shareWeatherText(
      Object city, Object temp, Object condition, Object score) {
    return 'Currently $city: $temp°, $condition. Outdoor activity score: $score/100 🌤️ (Zephyr Sky)';
  }
}
