import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1e3c72), // 일관성 있는 배경색
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintText: '도시 이름 검색 (예: 서울, 도쿄...)',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // 입력값이 변경될 때마다 검색 실행
            ref.read(searchResultsProvider.notifier).search(value);
          },
        ),
      ),
      body: searchResults.when(
        data: (results) {
          if (results.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: results.length,
            separatorBuilder: (context, index) => Divider(color: Colors.white.withOpacity(0.1)),
            itemBuilder: (context, index) {
              final place = results[index];
              final String name = place['name'] ?? '알 수 없음';
              final String country = place['country'] ?? '';
              final String admin1 = place['admin1'] ?? '';
              final String subtitle = [admin1, country].where((s) => s.isNotEmpty).join(', ');

              return ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Colors.white70),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  final lat = place['latitude'] as double;
                  final lon = place['longitude'] as double;
                  // 선택한 장소의 날씨 데이터 요청
                  ref.read(weatherStateProvider.notifier).fetchWeather(lat, lon, name);
                  Navigator.pop(context); // 메인 화면으로 복귀
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (err, stack) => Center(
          child: Text('오류 발생: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
