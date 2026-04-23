import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/weather_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  // 플러그인 초기화를 위해 필요
  WidgetsFlutterBinding.ensureInitialized();
  
  SharedPreferences? sharedPreferences;

  try {
    // 날짜 포맷팅 초기화 (ko_KR 로케일 지원)
    await initializeDateFormatting('ko_KR', null);
    
    // SharedPreferences 초기화
    sharedPreferences = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint('기본 초기화 오류: $e');
  }
  
  // 프로바이더 컨테이너 초기 생성
  final container = ProviderContainer(
    overrides: [
      if (sharedPreferences != null)
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      if (sharedPreferences != null)
        settingsProvider.overrideWith((ref) => SettingsNotifier(sharedPreferences!)),
    ],
  );

  try {
    // 플러그인 초기화 + 채널 생성 (권한 요청은 설정 화면에서 처리)
    await container.read(notificationServiceProvider).init();
  } catch (e) {
    debugPrint('알림 서비스 초기화 오류: $e');
  }

  // 설정에서 다크 모드 로드
  final settings = container.read(settingsProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: OpenWeatherApp(initialDarkMode: settings.isDarkMode),
    ),
  );
}

class OpenWeatherApp extends StatelessWidget {
  final bool initialDarkMode;
  
  const OpenWeatherApp({super.key, this.initialDarkMode = false});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final settings = ref.watch(settingsProvider);
        
        return MaterialApp(
          title: 'Zephyr Sky',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.latoTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.latoTextTheme(
              ThemeData.dark().textTheme,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
