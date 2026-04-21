import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/weather_provider.dart';
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
    ],
  );
  
  try {
    // 알림 서비스 초기화 (앱 실행을 방해하지 않도록 try-catch 보호)
    await container.read(notificationServiceProvider).init();
  } catch (e) {
    debugPrint('서비스 초기화 오류: $e');
  }
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const OpenWeatherApp(),
    ),
  );
}

class OpenWeatherApp extends StatelessWidget {
  const OpenWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const HomeScreen(),
    );
  }
}
