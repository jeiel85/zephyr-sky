import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/utils/weather_helper.dart';
import '../providers/weather_provider.dart';
import '../../domain/entities/weather.dart';
import 'search_screen.dart';

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
    
    // 2. 새로운 데이터 요청
    _refreshWeather();
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
                        const SizedBox(height: 60),
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
            },
            loading: () => weather != null 
              ? _buildWeatherContent(weather) // 데이터가 있으면 로딩 중에도 이전 데이터 표시
              : const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (err, stack) => weather != null
              ? _buildWeatherContent(weather) // 에러나도 데이터 있으면 표시
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
              const SizedBox(height: 60),
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
      ],
    );
  }

  Widget _buildCurrentWeather(Weather weather) {
    return Column(
      children: [
        Icon(
          WeatherHelper.getIcon(weather.weatherCode, isDay: weather.isDay), 
          size: 80, 
          color: Colors.white
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
          WeatherHelper.getDescription(weather.weatherCode),
          style: const TextStyle(
            fontSize: 24, 
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
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

  Widget _buildHourlyForecast(List<HourlyWeather> hourly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '시간별 예보',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 130,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('HH시').format(item.time),
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      WeatherHelper.getIcon(item.weatherCode), 
                      color: Colors.white, 
                      size: 28
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.temperature.round()}°',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
        const Text(
          '주간 예보',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        DateFormat('E', 'ko_KR').format(day.time),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        WeatherHelper.getIcon(day.weatherCode), 
                        color: Colors.white, 
                        size: 24
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${day.minTemp.round()}° / ${day.maxTemp.round()}°',
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
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
