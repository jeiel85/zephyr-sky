import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/weather_helper.dart';
import '../../core/utils/route_animations.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../../domain/entities/weather.dart';
import '../widgets/weather_chart.dart';
import '../widgets/offline_banner.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDailyExpanded = false; // 주간 예보 펼침 상태

  // 오프라인 상태
  bool _isOffline = false;
  bool _isCacheExpired = false;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _listenToConnectivityChanges();
  }

  /// 연결 상태 변경 리스닝
  void _listenToConnectivityChanges() {
    final notifier = ref.read(weatherStateProvider.notifier);
    notifier.offlineStatus.listen((isOffline) {
      if (mounted) {
        setState(() {
          _isOffline = isOffline;
        });
      }
    });
  }

  // 가독성을 위한 공통 텍스트 그림자
  static const List<Shadow> _textShadows = [
    Shadow(offset: Offset(0, 1), blurRadius: 3.0, color: Colors.black38),
  ];

  // 반투명 카드 스타일
  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Future<void> _initializeData() async {
    // 캐시된 날씨 먼저 로드 (오프라인 상태 포함)
    final offlineStatus = await ref.read(weatherStateProvider.notifier).loadCachedWeather();
    _updateOfflineStatus(offlineStatus);

    final repository = ref.read(weatherRepositoryProvider);
    final lastLocation = await repository.getLastLocation();
    if (lastLocation != null) {
      final newStatus = await ref.read(weatherStateProvider.notifier).fetchWeather(
        lastLocation['lat'],
        lastLocation['lon'],
        lastLocation['name']
      );
      _updateOfflineStatus(newStatus);
    } else {
      _refreshWeather();
    }
  }

  /// 오프라인 상태 업데이트
  void _updateOfflineStatus(OfflineStatus status) {
    if (mounted) {
      setState(() {
        _isOffline = status.isOffline;
        _isCacheExpired = status.isCacheExpired;
        _lastUpdated = status.lastUpdated;
      });
    }
  }

  Future<void> _refreshWeather() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();

      // 역지오코딩으로 지역명 가져오기
      final address = await locationService.getAddressFromLatLng(position.latitude, position.longitude);
      final l10n = AppLocalizations.of(context)!;
      final locationLabel = address != null ? '${l10n.addCurrentLocation} ($address)' : l10n.addCurrentLocation;

      final offlineStatus = await ref.read(weatherStateProvider.notifier).fetchWeather(
        position.latitude,
        position.longitude,
        locationLabel
      );
      _updateOfflineStatus(offlineStatus);

      // Pull-to-refresh 완료 햅틱 피드백
      HapticFeedback.lightImpact();
    } catch (e) {
      // 오류 발생 시 햅틱 피드백
      HapticFeedback.heavyImpact();
      if (mounted) {
        if (ref.read(weatherStateProvider).value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), behavior: SnackBarBehavior.floating),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherStateProvider);
    final weather = weatherState.value;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: WeatherHelper.getGradientColors(
              weather?.weatherCode ?? 0, 
              isDay: weather?.isDay ?? true
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(weather),
              // 오프라인 배너
              if (_isOffline || _isCacheExpired)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OfflineBanner(
                    isOffline: _isOffline,
                    isCacheExpired: _isCacheExpired,
                    lastUpdated: _lastUpdated,
                  ),
                ),
              Expanded(
                child: weatherState.when(
                  data: (weather) {
                    if (weather == null) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    return RefreshIndicator(
                      onRefresh: _refreshWeather,
                      color: Colors.blue,
                      child: _buildWeatherContent(weather),
                    );
                  },
                  loading: () => weather != null 
                    ? RefreshIndicator(
                        onRefresh: _refreshWeather,
                        color: Colors.blue,
                        child: _buildWeatherContent(weather),
                      )
                    : const Center(child: CircularProgressIndicator(color: Colors.white)),
                  error: (err, stack) => weather != null
                    ? RefreshIndicator(
                        onRefresh: _refreshWeather,
                        color: Colors.blue,
                        child: _buildWeatherContent(weather),
                      )
                    : _buildErrorView(err),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(Weather? weather) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // 좌측 균형을 위한 공간
          Column(
            children: [
              Text(
                weather?.locationName ?? AppLocalizations.of(context)!.locationLoading,
                style: const TextStyle(
                  fontSize: 22, 
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: _textShadows,
                ),
              ),
              if (weather != null)
                Text(
                  DateFormat('M월 d일 (E)', AppLocalizations.of(context)!.localeName).format(weather.time),
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.white.withOpacity(0.8),
                    shadows: _textShadows,
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            tooltip: AppLocalizations.of(context)!.menuOpen,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(AppLocalizations.of(context)!.appName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(AppLocalizations.of(context)!.appSubtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search, color: Colors.white),
            title: Text(AppLocalizations.of(context)!.searchLocation, style: const TextStyle(color: Colors.white)),
            onTap: () {
              // Navigator.pop(context); // Drawer를 닫지 않고 이동
              Navigator.push(
                context, 
                RouteAnimations.slideTransition(page: const SearchScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: Text(AppLocalizations.of(context)!.settings, style: const TextStyle(color: Colors.white)),
            onTap: () {
              // Navigator.pop(context); // Drawer를 닫지 않고 이동
              Navigator.push(
                context, 
                RouteAnimations.slideTransition(page: const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.white),
            title: Text(AppLocalizations.of(context)!.weatherRefresh, style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _refreshWeather();
            },
          ),

        ],
      ),
    );
  }

  Widget _buildWeatherContent(Weather weather) {
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildCurrentWeather(weather),
            const SizedBox(height: 30),
            _buildWeatherDetails(weather),
            const SizedBox(height: 20),
            _buildExtendedWeatherInfo(weather),
            const SizedBox(height: 20),
            _buildOutdoorActivity(weather),
            const SizedBox(height: 30),
            Text(
              AppLocalizations.of(context)!.temperaturePrecipitationTrend,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: _textShadows),
            ),
            const SizedBox(height: 16),
            WeatherChart(hourlyForecast: weather.hourlyForecast, isDarkMode: isDarkMode),
            const SizedBox(height: 20),
            PrecipitationChart(hourlyForecast: weather.hourlyForecast),
            const SizedBox(height: 40),
            _buildHourlyForecast(weather.hourlyForecast),
            const SizedBox(height: 40),
            _buildDailyForecast(weather.dailyForecast),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather(Weather weather) {
    final l10n = AppLocalizations.of(context)!;
    final weatherDesc = WeatherHelper.getDescriptionLocalized(weather.weatherCode, l10n);
    return Semantics(
      label: l10n.currentWeatherLabel(weatherDesc, weather.temperature.round()),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(weather.weatherIcon, size: 70, color: Colors.white, shadows: const [Shadow(blurRadius: 10, color: Colors.black26)], semanticLabel: weatherDesc),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weatherDesc,
                    style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w400, shadows: _textShadows),
                  ),
                if (weather.uvIndex != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getUvColor(weather.uvIndex!).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'UV ${weather.uvIndex!.toStringAsFixed(1)} ${weather.uvRiskLevelLocalized(l10n)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Text(
          '${weather.temperature.round()}°',
          style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w100, color: Colors.white, shadows: _textShadows),
        ),
        Text(
          '${AppLocalizations.of(context)!.maxTemp}: ${weather.maxTemp.round()}°  ${AppLocalizations.of(context)!.minTemp}: ${weather.minTemp.round()}°',
          style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w400, shadows: _textShadows),
        ),
        if (weather.precipitationProbability != null && weather.precipitationProbability! > 0) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop, color: Colors.lightBlueAccent, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${AppLocalizations.of(context)!.precipitationProbability} ${weather.precipitationProbability!.round()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ],
      ),
    );
  }

  Widget _buildWeatherDetails(Weather weather) {
    return _buildGlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(Icons.water_drop_outlined, AppLocalizations.of(context)!.humidity, '${weather.humidity.round()}%'),
          _buildDetailItem(Icons.air, AppLocalizations.of(context)!.windSpeed, '${weather.windSpeed.round()}km/h'),
          _buildDetailItem(Icons.thermostat_outlined, AppLocalizations.of(context)!.feelsLike, '${weather.apparentTemperature.round()}°'),
        ],
      ),
    );
  }

  Widget _buildExtendedWeatherInfo(Weather weather) {
    final l10n = AppLocalizations.of(context)!;
    final List<Widget> items = [];
    if (weather.airQualityIndex != null) {
      items.add(_buildDetailItem(Icons.eco_outlined, 'AQI', '${weather.airQualityIndex} (${weather.airQualityLevelLocalized(l10n)})', color: _getAqiColor(weather.airQualityIndex!)));
    }
    if (weather.pressure != null) {
      items.add(_buildDetailItem(Icons.speed_outlined, AppLocalizations.of(context)!.pressure, '${weather.pressure!.round()}hPa'));
    }
    if (weather.visibility != null) {
      items.add(_buildDetailItem(Icons.visibility_outlined, AppLocalizations.of(context)!.visibility, '${(weather.visibility! / 1000).toStringAsFixed(1)}km'));
    }
    if (weather.dewPoint != null) {
      items.add(_buildDetailItem(Icons.water_outlined, AppLocalizations.of(context)!.dewPoint, '${weather.dewPoint!.round()}°'));
    }
    if (weather.cloudCover != null) {
      items.add(_buildDetailItem(Icons.cloud_outlined, AppLocalizations.of(context)!.cloudCover, '${weather.cloudCover}%'));
    }
    
    if (items.isEmpty) return const SizedBox.shrink();
    
    return _buildGlassCard(
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        children: items,
      ),
    );
  }

  Widget _buildOutdoorActivity(Weather weather) {
    final l10n = AppLocalizations.of(context)!;
    final score = weather.outdoorActivityScore;
    final level = weather.outdoorActivityLevelLocalized(l10n);
    final message = weather.outdoorActivityMessageLocalized(l10n);
    
    Color scoreColor = score >= 80 ? Colors.greenAccent : (score >= 60 ? Colors.lightGreenAccent : (score >= 40 ? Colors.orangeAccent : Colors.redAccent));
    
    return Semantics(
      label: '${l10n.outdoorActivityIndex}: $score, $level, $message',
      child: _buildGlassCard(
        child: Column(
          children: [
          Row(
            children: [
              const Icon(Icons.directions_run, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              Text(l10n.outdoorActivityIndex, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, shadows: _textShadows)),
              const Spacer(),
              Text(level, style: TextStyle(color: scoreColor, fontSize: 16, fontWeight: FontWeight.bold, shadows: _textShadows)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, shadows: _textShadows)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value, {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color ?? Colors.white, size: 24, shadows: const [Shadow(blurRadius: 5, color: Colors.black26)]),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, shadows: _textShadows)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 14, fontWeight: FontWeight.bold, shadows: _textShadows)),
      ],
    );
  }

  Widget _buildHourlyForecast(List<HourlyWeather> hourly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(AppLocalizations.of(context)!.hourlyForecast, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: _textShadows)),
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: hourly.length,
                itemBuilder: (context, index) {
                  final item = hourly[index];
                  return Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('HH시', AppLocalizations.of(context)!.localeName).format(item.time), style: const TextStyle(color: Colors.white70, fontSize: 12, shadows: _textShadows)),
                        const SizedBox(height: 10),
                        Icon(WeatherHelper.getIcon(item.weatherCode), color: Colors.white, size: 28, shadows: const [Shadow(blurRadius: 5, color: Colors.black26)]),
                        const SizedBox(height: 10),
                        Text('${item.temperature.round()}°', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, shadows: _textShadows)),
                        if (item.precipitationProbability != null && item.precipitationProbability! > 0) ...[
                          const SizedBox(height: 4),
                          Text('${item.precipitationProbability!.round()}%', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ],
                    ),
                  );
                },
              ),
              // 스크롤 힌트를 위한 좌우 페이드 효과 (간략하게 화살표 표시)
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 30),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast(List<DailyWeather> daily) {
    // 접혀있을 때는 3일, 펼쳐져있을 때는 전체(최대 10일) 표시
    final displayList = _isDailyExpanded ? daily.take(10).toList() : daily.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.dailyForecast, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: _textShadows)),
              TextButton(
                onPressed: () => setState(() => _isDailyExpanded = !_isDailyExpanded),
                child: Text(
                  _isDailyExpanded ? AppLocalizations.of(context)!.collapse : AppLocalizations.of(context)!.seeMore,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildGlassCard(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              ...displayList.map((day) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          DateFormat('E d일', AppLocalizations.of(context)!.localeName).format(day.time),
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400, shadows: _textShadows),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(WeatherHelper.getIcon(day.weatherCode), color: Colors.white, size: 24),
                            if (day.precipitationProbability != null && day.precipitationProbability! > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  '${day.precipitationProbability!.round()}%', 
                                  style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 13, fontWeight: FontWeight.w900, shadows: [Shadow(blurRadius: 2, color: Colors.black)]),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // UV 지수 복구
                      if (day.uvIndex != null)
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.wb_sunny, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'UV ${day.uvIndex!.round()}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, shadows: _textShadows),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${day.minTemp.round()}°', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, shadows: _textShadows)),
                            const SizedBox(width: 8),
                            Container(
                              width: 30,
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.orangeAccent]),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${day.maxTemp.round()}°', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, shadows: _textShadows)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Color _getUvColor(double uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow.shade700;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.greenAccent;
    if (aqi <= 100) return Colors.yellowAccent;
    if (aqi <= 150) return Colors.orangeAccent;
    if (aqi <= 200) return Colors.redAccent;
    return Colors.purpleAccent;
  }

  Widget _buildErrorView(Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.white),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.weatherLoadError, style: const TextStyle(color: Colors.white, fontSize: 18, shadows: _textShadows)),
          const SizedBox(height: 8),
          Text(err.toString(), style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshWeather,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }
}
