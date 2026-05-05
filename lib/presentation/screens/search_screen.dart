import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/connectivity_service.dart';
import '../providers/weather_provider.dart';
import '../../l10n/app_localizations.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    await _connectivityService.initialize();
    final isConnected = await _connectivityService.checkConnection();
    if (mounted) {
      setState(() {
        _isOffline = !isConnected;
      });
    }
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1e3c72),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          autofocus: true,
          enabled: !_isOffline,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: _isOffline ? l10n.searchOffline : l10n.searchHint,
            hintStyle: TextStyle(color: _isOffline ? Colors.white30 : Colors.white54),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            if (_isOffline) return;
            if (value.trim().isNotEmpty) {
              ref.read(searchResultsProvider.notifier).search(value.trim());
            }
          },
        ),
      ),
      body: _isOffline
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 64, color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  l10n.searchOffline,
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                ),
              ],
            ),
          )
        : searchResults.when(
        data: (results) {
          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noResults,
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
