import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/location_service.dart';
import '../../core/utils/notification_service.dart';
import 'home_screen.dart';
import '../../l10n/app_localizations.dart';

/// 온볼딩 페이지 데이터
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}

/// 온볼딩 화면
class OnboardingScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const OnboardingScreen({super.key, required this.prefs});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _getPages(l10n);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: pages[_currentPage].gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 스킵 버튼
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    l10n.skip,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              // 페이지 뷰
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(pages[index]);
                  },
                ),
              ),
              
              // 인디케이터와 버튼
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // 페이지 인디케이터
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // 다음/시작 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: pages[_currentPage].gradientColors[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                _currentPage == pages.length - 1
                                    ? l10n.start
                                    : l10n.next,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 온볼딩 페이지 데이터 생성
  List<OnboardingPageData> _getPages(AppLocalizations l10n) {
    return [
      OnboardingPageData(
        title: l10n.onboardingWelcomeTitle,
        description: l10n.onboardingWelcomeDesc,
        icon: Icons.wb_sunny_outlined,
        gradientColors: const [Color(0xFF1e3c72), Color(0xFF2a5298)],
      ),
      OnboardingPageData(
        title: l10n.onboardingLocationTitle,
        description: l10n.onboardingLocationDesc,
        icon: Icons.location_on_outlined,
        gradientColors: const [Color(0xFF2193b0), Color(0xFF6dd5ed)],
      ),
      OnboardingPageData(
        title: l10n.onboardingNotificationTitle,
        description: l10n.onboardingNotificationDesc,
        icon: Icons.notifications_outlined,
        gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      OnboardingPageData(
        title: l10n.onboardingReadyTitle,
        description: l10n.onboardingReadyDesc,
        icon: Icons.check_circle_outline,
        gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
      ),
    ];
  }

  /// 페이지 위젯 빌드
  Widget _buildPage(OnboardingPageData page) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          
          // 제목
          Text(
            page.title,
            style: GoogleFonts.lato(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // 설명
          Text(
            page.description,
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 다음 버튼 클릭
  Future<void> _onNextPressed() async {
    HapticFeedback.lightImpact();
    
    final pages = _getPages(AppLocalizations.of(context)!);
    
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _requestPermissionsAndComplete();
    }
  }

  /// 권한 요청 및 온볼딩 완료
  Future<void> _requestPermissionsAndComplete() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 위치 권한 요청
      final locationService = LocationService();
      await locationService.getCurrentPosition().catchError((_) {
        // 권한 거부되어도 계속 진행
      });

      // 알림 권한 요청
      final notificationService = NotificationService();
      await notificationService.init((locale) => AppLocalizations.of(context)!);

      await _completeOnboarding();
    } catch (e) {
      // 오류가 발생해도 온볼딩 완료
      await _completeOnboarding();
    }
  }

  /// 온볼딩 완료 처리
  Future<void> _completeOnboarding() async {
    await widget.prefs.setBool('seen_onboarding', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
