import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zephyr_sky/l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: settings.isDarkMode ? Colors.white : Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 알림 설정 (중요도에 따라 상단 배치)
          _buildSectionHeader(AppLocalizations.of(context)!.notifications, settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.statusBarWeatherNotification),
                subtitle: Text(AppLocalizations.of(context)!.statusBarWeatherDesc),
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
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.notificationPermissionRequired),
                            duration: const Duration(seconds: 4),
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
          _buildSectionHeader(AppLocalizations.of(context)!.appearance, settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                subtitle: Text(AppLocalizations.of(context)!.darkModeDesc),
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
          _buildSectionHeader(AppLocalizations.of(context)!.unit, settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              RadioListTile<bool>(
                title: Text(AppLocalizations.of(context)!.celsius),
                subtitle: Text(AppLocalizations.of(context)!.celsiusDesc),
                value: true,
                groupValue: settings.useCelsius,
                onChanged: (value) {
                  // 설정 토글 햅틱 피드백
                  HapticFeedback.lightImpact();
                  settingsNotifier.setUseCelsius(true);
                },
              ),
              RadioListTile<bool>(
                title: Text(AppLocalizations.of(context)!.fahrenheit),
                subtitle: Text(AppLocalizations.of(context)!.fahrenheitDesc),
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
          
          // 언어 설정
          _buildSectionHeader(AppLocalizations.of(context)!.language, settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.korean),
                value: 'ko',
                groupValue: settings.languageCode,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  settingsNotifier.setLanguage('ko');
                },
              ),
              RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.english),
                value: 'en',
                groupValue: settings.languageCode,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  settingsNotifier.setLanguage('en');
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 즐겨찾기 위치
          _buildSectionHeader(AppLocalizations.of(context)!.favoriteLocations, settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              if (settings.favoriteLocations.isEmpty)
                ListTile(
                  leading: const Icon(Icons.location_off, color: Colors.grey),
                  title: Text(AppLocalizations.of(context)!.noFavoriteLocations),
                  subtitle: Text(AppLocalizations.of(context)!.addFavoriteHint),
                )
              else
                ...List.generate(settings.favoriteLocations.length, (index) {
                  final location = settings.favoriteLocations[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: Text(location['name'] ?? AppLocalizations.of(context)!.unknownLocation),
                    subtitle: Text(
                      AppLocalizations.of(context)!.latLon(location['lat'], location['lon']),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => settingsNotifier.removeFavoriteLocation(index),
                      tooltip: AppLocalizations.of(context)!.delete,
                    ),
                  );
                }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add_location, color: Colors.blue),
                title: Text(AppLocalizations.of(context)!.addCurrentLocation),
                onTap: () {
                  // TODO: 현재 위치 추가 기능
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.addFavoriteHint)),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 앱 정보
          _buildSectionHeader(AppLocalizations.of(context)!.info, settings.isDarkMode),
          _buildSettingsCard(
            settings.isDarkMode,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.grey),
                title: Text(AppLocalizations.of(context)!.appName),
                subtitle: Text('${AppLocalizations.of(context)!.version} 1.2.1'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.code, color: Colors.grey),
                title: Text(AppLocalizations.of(context)!.dataSource),
                subtitle: Text(AppLocalizations.of(context)!.openMeteoApi),
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