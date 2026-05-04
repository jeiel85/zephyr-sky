import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: settings.isDarkMode ? Colors.white : Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 알림 설정 (중요도에 따라 상단 배치)
          _buildSectionHeader('알림', settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              SwitchListTile(
                title: const Text('상태바 날씨 알림'),
                subtitle: const Text('상태바에 현재 날씨를 항상 표시합니다.'),
                value: settings.notificationsEnabled,
                onChanged: (value) async {
                  // 설정 토글 햅틱 피드백
                  HapticFeedback.lightImpact();
                  await settingsNotifier.setNotificationsEnabled(value);
                  final notificationService = ref.read(notificationServiceProvider);
                  if (!value) {
                    await notificationService.cancelNotification();
                  } else {
                    // 권한 확인 후 없으면 요청
                    bool hasPermission = await notificationService.areNotificationsEnabled();
                    if (!hasPermission) {
                      hasPermission = await notificationService.requestPermission();
                    }
                    if (!hasPermission) {
                      // 권한 거부 시 설정 안내
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('알림 권한이 필요합니다. 시스템 설정 > 앱 > Zephyr Sky에서 알림을 허용해주세요.'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                      return;
                    }
                    final weather = ref.read(weatherStateProvider).value;
                    if (weather != null) {
                      await notificationService.showWeatherNotification(weather);
                    }
                  }
                },
                secondary: const Icon(Icons.notifications_active, color: Colors.blue),
              ),
            ],
          ),
          
          const SizedBox(height: 24),

          // 외관 설정
          _buildSectionHeader('외관', settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              SwitchListTile(
                title: const Text('다크 모드'),
                subtitle: const Text('어두운 테마 사용'),
                value: settings.isDarkMode,
                onChanged: (value) {
                  // 설정 토글 햅틱 피드백
                  HapticFeedback.lightImpact();
                  settingsNotifier.setDarkMode(value);
                },
                secondary: Icon(
                  settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: settings.isDarkMode ? Colors.amber : Colors.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 단위 설정
          _buildSectionHeader('단위', settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              RadioListTile<bool>(
                title: const Text('섭씨 (°C)'),
                subtitle: const Text('한국, 유럽 등'),
                value: true,
                groupValue: settings.useCelsius,
                onChanged: (value) {
                  // 설정 토글 햅틱 피드백
                  HapticFeedback.lightImpact();
                  settingsNotifier.setUseCelsius(true);
                },
              ),
              RadioListTile<bool>(
                title: const Text('화씨 (°F)'),
                subtitle: const Text('미국 등'),
                value: false,
                groupValue: settings.useCelsius,
                onChanged: (value) {
                  // 설정 토글 햅틱 피드백
                  HapticFeedback.lightImpact();
                  settingsNotifier.setUseCelsius(false);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 즐겨찾기 위치
          _buildSectionHeader('즐겨찾기 위치', settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              if (settings.favoriteLocations.isEmpty)
                const ListTile(
                  leading: Icon(Icons.location_off, color: Colors.grey),
                  title: Text('즐겨찾기 위치가 없습니다'),
                  subtitle: Text('홈 화면에서 검색 후 추가하세요'),
                )
              else
                ...List.generate(settings.favoriteLocations.length, (index) {
                  final location = settings.favoriteLocations[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: Text(location['name'] ?? '알 수 없는 위치'),
                    subtitle: Text(
                      '위도: ${location['lat']?.toStringAsFixed(2)}, 경도: ${location['lon']?.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => settingsNotifier.removeFavoriteLocation(index),
                    ),
                  );
                }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add_location, color: Colors.blue),
                title: const Text('현재 위치 추가'),
                onTap: () {
                  // TODO: 현재 위치 추가 기능
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('홈 화면에서 검색 후 추가하세요')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 앱 정보
          _buildSectionHeader('정보', settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.grey),
                title: const Text('Zephyr Sky'),
                subtitle: const Text('버전 1.2.1'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.code, color: Colors.grey),
                title: const Text('데이터 소스'),
                subtitle: const Text('Open-Meteo API'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(bool isDarkMode, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}