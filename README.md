# 🌤️ Zephyr Sky (제퍼 스카이)

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.1.0-blue?style=for-the-badge)

**아름다운 그라데이션을 갖춘 세련된 미니멀리스트 날씨 앱**

*상위 날씨 앱 분석 기반의 종합 날씨 앱*

</div>

---

## ✨ 주요 기능

### 🌡️ 날씨 정보
| 기능 | 설명 |
|------|------|
| **현재 날씨** | 실시간 위치 기반 날씨 정보 |
| **48시간 시간별 예보** | 시간별 온도, 날씨 상태, 강수 확률 |
| **16일 일별 예보** | 일별 최고/최저 기온, 날씨, UV 지수 |
| **AQI (대기질 지수)** | 실시간 대기질 상태 및 등급 |
| **UV Index** | 자외선 지수 및 위험 등급 |
| **강수 확률** | 시간별/일별 강수 확률 |
| **일출/일몰** | 일출, 일몰 시간 정보 |
| **상세 기상 정보** | 기압, 시정, 이슬점, 구름량 |

### 🎨 UI/UX
| 기능 | 설명 |
|------|------|
| **동적 그라데이션** | 날씨 상태에 따라 변하는 배경 |
| **다크 모드** | 어두운 테마 지원 |
| **날씨 그래프** | fl_chart 기반 기온 추이, 강수 확률 시각화 |
| **야외 활동 지수** | 날씨 기반 활동 권장 점수 (0-100) |

### ⚙️ 설정 및 사용자 맞춤화
| 기능 | 설명 |
|------|------|
| **단위 설정** | °C / °F 전환 |
| **즐겨찾기 위치** | 여러 지역 저장 및 관리 |
| **날씨 경고** | 강한 바람, 한파, 고온, 자외선, 대기질 경고 |
| **상태바 알림** | 앱 미실행 시에도 날씨 확인 |

### 📱 시스템 통합
| 기능 | 설명 |
|------|------|
| **안드로이드 위젯** | 홈 스크린 날씨 위젯 |
| **GitHub Actions CI/CD** | 자동 빌드 및 배포 |
| **APK/AAB 릴리즈** | 자동 생성 및 배포 |

---

## 🛠️ 기술 스택

### Framework & Language
<div>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter) **Flutter** - 크로스 플랫폼 UI 프레임워크

![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart) **Dart** - 타입 안전한 프로그래밍 언어

</div>

### State Management & Dependencies
| 패키지 | 용도 |
|--------|------|
| **flutter_riverpod** | 상태 관리 (Provider 패턴) |
| **shared_preferences** | 로컬 데이터 저장 |
| **flutter_local_notifications** | 날씨 알림 및 경고 |
| **geolocator** | 위치 정보 서비스 |
| **http** | API 통신 (Open-Meteo) |
| **fl_chart** | 날씨 데이터 시각화 (그래프) |
| **home_widget** | 안드로이드 홈 스크린 위젯 |
| **google_fonts** | 커스텀 타이포그래피 (Lato) |
| **intl** | 다국어 지원 (한국어) |

### Data Source
<div>

![Open-Meteo](https://img.shields.io/badge/Open--Meteo-FF6B35?style=flat-square&logo=open-meteo) **Open-Meteo API** - 무료 날씨 및 대기질 API

*API 키 불필요 • 일일 10,000회 무료 요청*

</div>

### CI/CD
<div>

![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=github-actions) **GitHub Actions** - 자동 빌드 및 배포

![GitHub Pages](https://img.shields.io/badge/GitHub_Pages-222222?style=flat-square&logo=github) **GitHub Pages** - 브랜드 페이지 호스팅

</div>

---

## 📂 프로젝트 구조 (Clean Architecture)

```
lib/
├── main.dart                          # 앱 진입점
├── core/
│   └── utils/                         # 공통 유틸리티
│       ├── location_service.dart      # 위치 서비스
│       ├── notification_service.dart  # 알림 서비스
│       ├── home_widget_service.dart   # 위젯 서비스
│       └── weather_helper.dart        # 날씨 헬퍼
├── data/
│   ├── models/                        # 데이터 모델
│   │   └── weather_model.dart
│   ├── repositories/                  # 저장소 구현
│   │   └── weather_repository_impl.dart
│   └── sources/                       # API 소스
│       └── weather_api_source.dart    # Open-Meteo API
├── domain/
│   ├── entities/                      # 도메인 엔티티
│   │   └── weather.dart
│   └── repositories/                  # 저장소 인터페이스
│       └── weather_repository.dart
└── presentation/
    ├── providers/                     # Riverpod 프로바이더
    │   ├── weather_provider.dart
    │   └── settings_provider.dart
    ├── screens/                       # 화면
    │   ├── home_screen.dart
    │   ├── search_screen.dart
    │   └── settings_screen.dart
    └── widgets/                       # 위젯
        └── weather_chart.dart
```

---

## 📱 스크린샷 기능 미리보기

| 화면 | 설명 |
|------|------|
| **홈 화면** | 현재 날씨, 기온 그래프, 시간별/일별 예보, 야외 활동 지수 |
| **검색 화면** | 전 세계 도시 검색 |
| **설정 화면** | 다크 모드, 단위, 알림, 즐겨찾기 관리 |

---

## 🚀 시작하기

### 필수 요구사항
- **Flutter SDK:** 3.0 이상
- **Dart SDK:** 3.0 이상
- **Android SDK:** API 21+

### 설치 및 실행

```bash
# 레포지토리 클론
git clone https://github.com/jeiel85/zephyr-sky.git
cd zephyr-sky

# 의존성 설치
flutter pub get

# 개발 모드 실행
flutter run

# 릴리스 빌드
flutter build apk --release
```

---

## 📦 배포

### 자동 배포 (권장)
버전 태그를 푸시하면 자동으로 빌드 및 배포됩니다:

```bash
# 버전 업데이트 (pubspec.yaml)
# 예: version: 1.1.0+1

# 커밋 및 태그 푸시
git add .
git commit -m "Release v1.1.0"
git tag v1.1.0
git push origin main
git push origin v1.1.0
```

### 수동 다운로드
- **GitHub Releases:** [https://github.com/jeiel85/zephyr-sky/releases](https://github.com/jeiel85/zephyr-sky/releases)
- **Brand Page:** [https://jeiel85.github.io/zephyr-sky/](https://jeiel85.github.io/zephyr-sky/)

---

## 🧪 테스트 실행

```bash
# 단위 테스트
flutter test

# 테스트 커버리지 확인
flutter test --coverage
```

---

## 📄 라이선스

MIT 라이선스 - 상세 내용은 [LICENSE](LICENSE)를 참조하세요.

---

## 🙏 감사의 글

- [Open-Meteo](https://open-meteo.com/) - 무료 날씨 API 제공
- [Flutter](https://flutter.dev/) - 최고의 크로스 플랫폼 프레임워크
- Contributors 및 사용자 여러분

---

<div align="center">

**❤️ [Jeiel](https://github.com/jeiel85)이 사랑을 담아 만들었습니다**

*날씨가 당신의 하루를 밝게 비추기를 바랍니다 ☀️*

</div>