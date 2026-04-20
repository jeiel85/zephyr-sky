import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
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
    Future.microtask(() => _refreshWeather());
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherStateProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _getGradientColors(weatherState.value?.weatherCode),
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
              return Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    weather.locationName,
                    style: const TextStyle(
                      fontSize: 28, 
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${weather.time.year}년 ${weather.time.month}월 ${weather.time.day}일',
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.wb_sunny_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${weather.temperature.round()}°',
                    style: const TextStyle(
                      fontSize: 120, 
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
                  Text(
                    '최고: ${weather.maxTemp.round()}°  최저: ${weather.minTemp.round()}°',
                    style: TextStyle(
                      fontSize: 18, 
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchScreen()),
                            );
                          },
                          icon: const Icon(Icons.search, color: Colors.white70, size: 30),
                        ),
                        const SizedBox(width: 40),
                        IconButton(
                          onPressed: _refreshWeather,
                          icon: const Icon(Icons.refresh, color: Colors.white70, size: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    '날씨 정보를 가져올 수 없습니다.',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: _refreshWeather,
                    child: const Text('다시 시도', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int? code) {
    if (code == null || code == 0) {
      return [const Color(0xFF4facfe), const Color(0xFF00f2fe)];
    }
    if (code <= 3) {
      return [const Color(0xFF6a11cb), const Color(0xFF2575fc)];
    }
    if (code >= 51 && code <= 65) {
      return [const Color(0xFF485563), const Color(0xFF29323c)];
    }
    if (code >= 71 && code <= 75) {
      return [const Color(0xFFe6e9f0), const Color(0xFFeef1f5)];
    }
    return [const Color(0xFF1e3c72), const Color(0xFF2a5298)];
  }
}
