import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zephyr_sky/l10n/app_localizations.dart';
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
          textInputAction: TextInputAction.search, // 검색 아이콘 표시
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchHint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            // 엔터나 검색 버튼을 눌렀을 때만 검색 실행
            if (value.trim().isNotEmpty) {
              ref.read(searchResultsProvider.notifier).search(value.trim());
            }
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
                  const Icon(Icons.search, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noResults,
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
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
              final String name = place['name'] ?? AppLocalizations.of(context)!.unknown;
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
                  // 검색 결과 선택 햅틱 피드백
                  HapticFeedback.selectionClick();
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
          child: Text('${AppLocalizations.of(context)!.error}: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
