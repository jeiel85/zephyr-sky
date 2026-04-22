import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/weather_helper.dart';
import '../providers/weather_provider.dart';
import '../../domain/entities/weather.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // 1. 먼저 캐시된 데이터 로드 (빠른 화면 표시)
    await ref.read(weatherStateProvider.notifier).loadCachedWeather();
    
    // 2. 마지막으로 확인한 위치 정보가 있는지 확인
    final repository = ref.read(weatherRepositoryProvider);
    final lastLocation = await repository.getLastLocation();
    
    if (lastLocation != null) {
      // 마지막 위치가 있으면 해당 위치 날씨 새로고침
      await ref.read(weatherStateProvider.notifier).fetchWeather(
        lastLocation['lat'], 
        lastLocation['lon'], 
        lastLocation['name']
      );
    } else {
      // 마지막 위치가 없으면 현재 위치 기반으로 새로고침
      _refreshWeather();
    }
  }

  Future<void> _refreshWeather() async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();
      
      await ref.read(weatherStateProvider.notifier).fetchWeather(
        position.latitude, 
        position.longitude, 
        '현재 위치'
      );
    } catch (e) {
      if (mounted) {
        // 데이터가 아예 없는 경우에만 에러 표시 (이미 캐시가 있으면 조용히 실패 가능)
        if (ref.read(weatherStateProvider).value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              behavior: SnackBarBehavior.floating,
            ),
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
          child: weatherState.when(
            data: (weather) {
              if (weather == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
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
      ),
    );
  }

  Widget _buildWeatherContent(Weather weather) {
    return RefreshIndicator(
      onRefresh: _refreshWeather,
      color: Colors.blue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildHeader(weather),
              const SizedBox(height: 60),
              _buildCurrentWeather(weather),
              const SizedBox(height: 40),
              _buildWeatherDetails(weather),
              const SizedBox(height: 24),
              _buildExtendedWeatherInfo(weather),
              const SizedBox(height: 40),
              _buildHourlyForecast(weather.hourlyForecast),
              const SizedBox(height: 40),
              _buildDailyForecast(weather.dailyForecast),
              const SizedBox(height: 40),
              _buildFooterActions(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Weather weather) {
    return Column(
      children: [
        Text(
          weather.locationName,
          style: const TextStyle(
            fontSize: 32, 
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('M월 d일 (E)', 'ko_KR').format(weather.time),
          style: TextStyle(
            fontSize: 16, 
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        // 일출/일몰 시간 표시
        if (weather.sunrise != null || weather.sunset != null) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (weather.sunrise != null) ...[
                const Icon(Icons.wb_sunny_outlined, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm').format(weather.sunrise!),
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
              const SizedBox(width: 16),
              if (weather.sunset != null) ...[
                const Icon(Icons.nights_stay_outlined, color: Colors.orange, size: 18),
                const SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm').format(weather.sunset!),
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCurrentWeather(Weather weather) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(weather.weatherIcon, size: 80, color: Colors.white),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (weather.uvIndex != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'UV ${weather.uvIndex!.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getUvColor(weather.uvIndex!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          weather.uvRiskLevel,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${weather.temperature.round()}°',
          style: const TextStyle(
            fontSize: 100, 
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
        Text(
          weather.weatherDescription,
          style: const TextStyle(
            fontSize: 24, 
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        // 강수 확률 표시
        if (weather.precipitationProbability != null && weather.precipitationProbability! > 0) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop, color: Colors.lightBlueAccent, size: 18),
                const SizedBox(width: 4),
                Text(
                  '강수확률 ${weather.precipitationProbability!.round()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          '최고: ${weather.maxTemp.round()}°  최저: ${weather.minTemp.round()}°',
          style: TextStyle(
            fontSize: 18, 
            color: Colors.white.withOpacity(0.8),
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

  Widget _buildWeatherDetails(Weather weather) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
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
    
    // AQI
    if (weather.airQualityIndex != null) {
      items.add(_buildDetailItem(
        Icons.eco_outlined, 
        'AQI', 
        '${weather.airQualityIndex} (${weather.airQualityLevel})',
        color: _getAqiColor(weather.airQualityIndex!),
      ));
    }
    
    // 기압
    if (weather.pressure != null) {
      items.add(_buildDetailItem(
        Icons.speed_outlined, 
        '기압', 
        '${weather.pressure!.round()}hPa',
      ));
    }
    
    // 시정
    if (weather.visibility != null) {
      items.add(_buildDetailItem(
        Icons.visibility_outlined, 
        '시정', 
        '${(weather.visibility! / 1000).toStringAsFixed(1)}km',
      ));
    }
    
    // 이슬점
    if (weather.dewPoint != null) {
      items.add(_buildDetailItem(
        Icons.water_outlined, 
        '이슬점', 
        '${weather.dewPoint!.round()}°',
      ));
    }
    
    // 구름량
    if (weather.cloudCover != null) {
      items.add(_buildDetailItem(
        Icons.cloud_outlined, 
        '구름', 
        '${weather.cloudCover}%',
      ));
    }
    
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 16,
        alignment: WrapAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow.shade700;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  Widget _buildDetailItem(IconData icon, String label, String value, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHourlyForecast(List<HourlyWeather> hourly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '시간별 예보',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${hourly.length}시간',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              final item = hourly[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('HH시').format(item.time),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Icon(
                      WeatherHelper.getIcon(item.weatherCode), 
                      color: Colors.white, 
                      size: 26
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.temperature.round()}°',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    if (item.precipitationProbability != null && item.precipitationProbability! > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.water_drop, color: Colors.lightBlueAccent, size: 12),
                          Text(
                            '${item.precipitationProbability!.round()}%',
                            style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast(List<DailyWeather> daily) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '주간 예보',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${daily.length}일',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: daily.map((day) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        DateFormat('E', 'ko_KR').format(day.time),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        WeatherHelper.getIcon(day.weatherCode), 
                        color: Colors.white, 
                        size: 22
                      ),
                    ),
                    // 강수 확률
                    if (day.precipitationProbability != null && day.precipitationProbability! > 0)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.water_drop, color: Colors.lightBlueAccent, size: 14),
                            Text(
                              '${day.precipitationProbability!.round()}%',
                              style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    else
                      const Expanded(child: SizedBox.shrink()),
                    // UV 지수
                    if (day.uvIndex != null && day.uvIndex! > 0)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wb_sunny, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              'UV ${day.uvIndex!.round()}',
                              style: TextStyle(color: Colors.amber.shade200, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 70,
                      child: Text(
                        '${day.minTemp.round()}° / ${day.maxTemp.round()}°',
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          icon: const Icon(Icons.search, color: Colors.white70, size: 32),
        ),
        const SizedBox(width: 40),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings, color: Colors.white70, size: 32),
        ),
        const SizedBox(width: 40),
        IconButton(
          onPressed: _refreshWeather,
          icon: const Icon(Icons.refresh, color: Colors.white70, size: 32),
        ),
      ],
    );
  }

  Widget _buildErrorView(Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.white),
          const SizedBox(height: 16),
          const Text('날씨 정보를 가져올 수 없습니다.', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            err.toString(), 
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
            textAlign: TextAlign.center,
          ),
          TextButton(onPressed: _refreshWeather, child: const Text('다시 시도', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
