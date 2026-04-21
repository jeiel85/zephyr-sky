import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/weather_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  // 플러그인 초기화를 위해 필요
  WidgetsFlutterBinding.ensureInitialized();
  
  // SharedPreferences 초기화
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // 프로바이더 컨테이너 초기 생성 및 알림 서비스 초기화
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
  );
  
  await container.read(notificationServiceProvider).init();
  
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
      title: 'Open Weather',
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
