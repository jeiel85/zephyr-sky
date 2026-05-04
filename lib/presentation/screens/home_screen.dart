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
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDailyExpanded = false; // 주간 예보 펼침 상태

  @override
  void initState() {
    super.initState();
    _initializeData();
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
    // ... (기존 코드와 동일)
    await ref.read(weatherStateProvider.notifier).loadCachedWeather();
    final repository = ref.read(weatherRepositoryProvider);
    final lastLocation = await repository.getLastLocation();
    if (lastLocation != null) {
      await ref.read(weatherStateProvider.notifier).fetchWeather(
        lastLocation['lat'], 
        lastLocation['lon'], 
        lastLocation['name']
      );
    } else {
      _refreshWeather();
    }
  }

  Future<void> _refreshWeather() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();
      
      // 역지오코딩으로 지역명 가져오기
      final address = await locationService.getAddressFromLatLng(position.latitude, position.longitude);
      final locationLabel = address != null ? '현재 위치 ($address)' : '현재 위치';
      
      await ref.read(weatherStateProvider.notifier).fetchWeather(
        position.latitude, 
        position.longitude, 
        locationLabel
      );
      
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
                weather?.locationName ?? '위치 로드 중...',
                style: const TextStyle(
                  fontSize: 22, 
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: _textShadows,
                ),
              ),
              if (weather != null)
                Text(
                  DateFormat('M월 d일 (E)', 'ko_KR').format(weather.time),
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
                Text('Zephyr Sky', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('날씨 및 설정', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search, color: Colors.white),
            title: const Text('위치 검색', style: TextStyle(color: Colors.white)),
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
            title: const Text('설정', style: TextStyle(color: Colors.white)),
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
            title: const Text('날씨 새로고침', style: TextStyle(color: Colors.white)),
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
            const Text(
              '기온 및 강수량 추이',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: _textShadows),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(weather.weatherIcon, size: 70, color: Colors.white, shadows: const [Shadow(blurRadius: 10, color: Colors.black26)]),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather.weatherDescription,
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
                      'UV ${weather.uvIndex!.toStringAsFixed(1)} ${weather.uvRiskLevel}',
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
          '최고: ${weather.maxTemp.round()}°  최저: ${weather.minTemp.round()}°',
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
                  '강수확률 ${weather.precipitationProbability!.round()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeatherDetails(Weather weather) {
    return _buildGlassCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(Icons.water_drop_outlined, '습도', '${weather.humidity.round()}%'),
          _buildDetailItem(Icons.air, '풍속', '${weather.windSpeed.round()}km/h'),
          _buildDetailItem(Icons.thermostat_outlined, '체감', '${weather.apparentTemperature.round()}°'),
        ],
      ),
    );
  }

  Widget _buildExtendedWeatherInfo(Weather weather) {
    final List<Widget> items = [];
    if (weather.airQualityIndex != null) {
      items.add(_buildDetailItem(Icons.eco_outlined, 'AQI', '${weather.airQualityIndex} (${weather.airQualityLevel})', color: _getAqiColor(weather.airQualityIndex!)));
    }
    if (weather.pressure != null) {
      items.add(_buildDetailItem(Icons.speed_outlined, '기압', '${weather.pressure!.round()}hPa'));
    }
    if (weather.visibility != null) {
      items.add(_buildDetailItem(Icons.visibility_outlined, '시정', '${(weather.visibility! / 1000).toStringAsFixed(1)}km'));
    }
    if (weather.dewPoint != null) {
      items.add(_buildDetailItem(Icons.water_outlined, '이슬점', '${weather.dewPoint!.round()}°'));
    }
    if (weather.cloudCover != null) {
      items.add(_buildDetailItem(Icons.cloud_outlined, '구름', '${weather.cloudCover}%'));
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
    final score = weather.outdoorActivityScore;
    final level = weather.outdoorActivityLevel;
    final message = weather.outdoorActivityMessage;
    
    Color scoreColor = score >= 80 ? Colors.greenAccent : (score >= 60 ? Colors.lightGreenAccent : (score >= 40 ? Colors.orangeAccent : Colors.redAccent));
    
    return _buildGlassCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.directions_run, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              const Text('야외 활동 지수', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, shadows: _textShadows)),
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
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text('시간별 예보', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: _textShadows)),
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
                        Text(DateFormat('HH시').format(item.time), style: const TextStyle(color: Colors.white70, fontSize: 12, shadows: _textShadows)),
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
              const Text('주간 예보', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: _textShadows)),
              TextButton(
                onPressed: () => setState(() => _isDailyExpanded = !_isDailyExpanded),
                child: Text(
                  _isDailyExpanded ? '접기' : '더보기',
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
                          DateFormat('E d일', 'ko_KR').format(day.time),
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
          const Text('날씨 정보를 가져올 수 없습니다.', style: TextStyle(color: Colors.white, fontSize: 18, shadows: _textShadows)),
          const SizedBox(height: 8),
          Text(err.toString(), style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshWeather,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
