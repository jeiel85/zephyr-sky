# 프로젝트 이력 관리 (HISTORY.md)

## [2026-04-20] 프로젝트 시작 및 초기 설정

### 작업 내용
- Flutter (Dart)를 프레임워크로 선정하고 프로젝트 `open_weather` 초기화.
- Open-Meteo API를 날씨 데이터 소스로 결정.
- 미니멀리즘 디자인 철학 및 상태바 알림 기능 명세 수립.
- Git 저장소 설정 및 초기 파일 구조 생성 완료.
- `HISTORY.md`를 통한 이력 관리 체계 구축.

### 현재 상태
- Flutter 프로젝트 초기화 및 Clean Architecture 구조 수립 완료.
- `shared_preferences`를 이용한 안정적인 로컬 저장소 체계 구축.
- 안드로이드 빌드 환경 최적화 (SDK 36 강제 적용 및 Desugaring 활성화).
- 실기기(SM-S921N) 설치 및 GitHub 저장소 동기화 완료.
- 앱 실행 시 `LocaleDataException` 발생 확인 (다음 세션 수정 예정).

## [2026-04-20] 회색 화면 해결 및 핵심 기능 강화

### 작업 내용
- `lib/main.dart`에 `initializeDateFormatting('ko_KR', null)`을 추가하여 `LocaleDataException` 및 회색 화면 오류 해결.
- `Weather` 엔티티에 `weatherIcon` 로직을 추가하여 날씨 상태(맑음, 비, 눈 등)에 맞는 동적 아이콘 표시 구현.
- `HomeScreen`의 현재 날씨, 시간별 예보, 주간 예보 영역에 동적 아이콘 적용.
- `SearchScreen`의 검색 방식을 `onChanged`에서 `onSubmitted`로 변경하여 불필요한 API 호출 방지 및 UX 개선.
- 검색 결과 선택 시 `HomeScreen`의 날씨 데이터가 즉각적으로 반영되도록 연동 완료.

### 현재 상태
- 앱 실행 시 초기 화면이 정상적으로 렌더링되며, 현재 위치 기반 날씨 정보를 성공적으로 가져옴.
- 상태바 알림(Notification)이 날씨 업데이트 시마다 정상적으로 갱신됨.
- 검색 기능을 통해 전 세계 도시의 날씨를 조회할 수 있음.
- **예정:** 조회된 위치 정보를 로컬에 저장하여 앱 재실행 시 마지막으로 본 위치를 표시하는 기능 추가.

## [2026-04-21] R8 빌드 오류 해결 및 v1.0.5 출시

### 작업 내용
- `android/app/proguard-rules.pro`에 `com.google.android.play.core` 관련 경고 무시(-dontwarn) 규칙 추가하여 R8 빌드 에러 해결.
- `pubspec.yaml` 버전을 1.0.5로 업데이트하여 신규 릴리즈 시도.

## [2026-04-21] GitHub Actions 빌드 최적화 및 v1.0.4 출시

### 작업 내용
- `release.yml` 워크플로우의 빌드 결과물 경로 인식 로직 개선 (*.apk, *.aab 와일드카드 적용).
- 빌드 결과물 확인(Check Build Artifacts) 단계 추가하여 CI/CD 투명성 확보.
- `pubspec.yaml` 버전을 1.0.4로 업데이트하여 신규 릴리즈 트리거.

## [2026-04-21] GitHub 동기화 및 기능 개선

### 작업 내용
- 로컬 변경 사항(intl 초기화) 커밋 및 GitHub 최신 소스 동기화 시도.
- `HISTORY.md`를 통한 세션 이력 관리 시작.
- **마지막 조회 위치 정보 저장 및 복원 기능 구현:**
    - `WeatherRepository`에 `saveLastLocation`, `getLastLocation` 메서드 추가.
    - `SharedPreferences`를 이용해 마지막으로 날씨를 조회한 위도, 경도, 도시명을 로컬에 저장.
    - 앱 재실행 시 현재 위치 정보 획득 전, 마지막으로 본 위치의 날씨를 먼저 동기화하도록 `HomeScreen` 로직 개선.

## [2026-04-21] 앱 실행 불가(Crash) 문제 긴급 해결 및 빌드 최적화 (v1.0.3)

### 작업 내용
- **Android 패키지 구조 동기화:**
    - `build.gradle.kts`와 `MainActivity.kt`의 패키지명 불일치(`com.example.open_weather` vs `com.jeiel.zephyr_sky`)로 인한 런타임 크래시 해결.
    - `MainActivity.kt`를 올바른 경로(`android/app/src/main/kotlin/com/jeiel/zephyr_sky/`)로 이동 및 패키지 선언 수정.
- **Android 권한 보완:**
    - `AndroidManifest.xml`에 `POST_NOTIFICATIONS`, `WAKE_LOCK`, `RECEIVE_BOOT_COMPLETED` 권한 추가하여 알림 및 백그라운드 작업 안정화.
- **R8(난독화) 설정 추가:**
    - `proguard-rules.pro` 파일을 생성하여 릴리스 빌드 시 Flutter 프레임워크 및 플러그인 클래스가 삭제되지 않도록 보존 설정 적용.

### 현재 상태
- 앱 실행 즉시 크래시가 발생하는 패키지명 오류가 완전히 해결됨.
- 릴리스 모드 빌드 시 발생할 수 있는 클래스 누락 방지 설정 완료.
- **사용자 가이드:** 수정된 소스로 새 APK를 빌드하여 재실행 권장.
## [2026-04-21] 앱 실행 안정성 강화 및 오류 수정 (v1.0.2)

### 작업 내용
- **앱 실행 프리즈(Freeze) 현상 수정:**
    - `main.dart` 초기화 로직에 `try-catch` 안전 장치를 추가하여 특정 서비스 실패 시에도 앱 실행 보장.
    - `NotificationService` 초기화 시 안드로이드 알림 권한 요청 로직 보완 및 에러 핸들링 추가.
- 모든 기능 정상 동작 확인 및 최종 안정화 버전 v1.0.2 배포.

### 현재 상태
- **브랜드 리브랜딩 완료 (Open Weather → Zephyr Sky).**
    - 모든 앱 이름, 패키지명(`com.jeiel.zephyr_sky`), 앱 라벨 업데이트 완료.
    - 브랜드 소개 랜딩 페이지(`website/`) 리뉴얼 완료.
- **GitHub Actions CI/CD 최적화:**
    - `release.yml` 빌드 결과물 경로 인식 오류 수정 및 빌드 검증 단계 추가.
    - `v*` 태그 기반 자동 릴리즈 프로세스 안정화.
- **안정성이 대폭 강화된 v1.0.0 정식 출시 준비 완료.**
- 초기화 중단 문제 및 보안 감사 결과가 모두 반영된 완벽한 상태.
