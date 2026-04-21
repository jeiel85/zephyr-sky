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

## [2026-04-21] GitHub 동기화 및 기능 개선

### 작업 내용
- 로컬 변경 사항(intl 초기화) 커밋 및 GitHub 최신 소스 동기화 시도.
- `HISTORY.md`를 통한 세션 이력 관리 시작.
- **마지막 조회 위치 정보 저장 및 복원 기능 구현:**
    - `WeatherRepository`에 `saveLastLocation`, `getLastLocation` 메서드 추가.
    - `SharedPreferences`를 이용해 마지막으로 날씨를 조회한 위도, 경도, 도시명을 로컬에 저장.
    - 앱 재실행 시 현재 위치 정보 획득 전, 마지막으로 본 위치의 날씨를 먼저 동기화하도록 `HomeScreen` 로직 개선.
### 현재 상태
- GitHub 최신 소스 동기화 및 충돌 해결 완료.
- 마지막 조회 위치 저장 기능 구현 및 검증 완료.
- 상세 날씨 데이터 시각화 및 UI/UX 폴리싱 완료.
- **GitHub Actions 릴리즈 자동화 강화 및 Pages(github.io) 자동 배포 시스템 구축.**
    - `main` 브랜치 푸시 시 Flutter Web 빌드 및 GitHub Pages(`https://jeiel85.github.io/open-weather/`) 자동 배포.
    - 태그 푸시 시 릴리즈 자동 생성 권한 최적화.
- **프로젝트 핵심 기능 명세 및 모든 자동화 시스템 구축 완료.**

    - APK 및 AAB(App Bundle) 동시 자동 빌드 설정 구축.
- **프로젝트 핵심 기능 명세 구현 완료.**
