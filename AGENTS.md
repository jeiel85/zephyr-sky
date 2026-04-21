# Zephyr Sky Project Agent Guide (AGENTS.md)

이 파일은 이 프로젝트에 참여하는 AI 에이전트를 위한 핵심 지침서입니다. 에이전트는 작업을 시작하기 전 이 문서를 반드시 숙지해야 합니다.

## 1. 프로젝트 개요 및 아키텍처
- **프로젝트 명**: Zephyr Sky (Sophisticated Minimalist Weather App)
- **디자인 철학**: 정제된 그라데이션 UI, 최소한의 정보 노출, 유려한 애니메이션.
- **아키텍처**: Clean Architecture
    - `lib/core/`: 공통 유틸리티, 테마, 서비스 초기화
    - `lib/data/`: API 소스, 리포지토리 구현체, 데이터 모델
    - `lib/domain/`: 엔티티, 리포지토리 인터페이스, 유스케이스
    - `lib/presentation/`: UI 레이어 (Screens, Widgets), Provider 상태 관리

## 2. 에이전트 행동 강령 (Agent Rules)
- **언어 설정**: 모든 답변과 커밋 메시지는 **한글**로 작성합니다.
- **이력 관리**: 모든 주요 변경 사항은 즉시 `HISTORY.md`에 기록하고 Git에 커밋합니다.
- **코드 스타일**: 
    - Flutter Stable 채널 사용.
    - `Provider`를 이용한 상태 관리.
    - 비즈니스 로직은 `domain` 및 `data` 레이어에, UI 로직은 `presentation` 레이어에 엄격히 분리.
- **빌드 및 배포**:
    - 안드로이드 빌드 시 SDK 36 규격을 준수하고, R8 관련 Proguard 규칙(`android/app/proguard-rules.pro`)을 유지할 것.
    - GitHub Actions 워크플로우(`release.yml`, `pages.yml`) 수정 시 권한 설정을 엄격히 검토할 것.

## 3. 핵심 기술 스택
- **Framework**: Flutter
- **State Management**: Provider
- **Local Storage**: SharedPreferences (마지막 위치 저장용 등)
- **API**: Open-Meteo API
- **CI/CD**: GitHub Actions (APK 릴리즈 및 GitHub Pages 배포)

## 4. 문서 체계
에이전트는 다음 문서들을 항상 최신 상태로 유지해야 합니다.
- `HISTORY.md`: 일일 작업 이력 및 현재 이슈 트래킹.
- `DEPLOYMENT.md`: 배포 환경 설정 및 스토어 등록 정보.
- `AGENTS.md`: 본 문서 (지침 및 규칙).

## 5. 자주 발생하는 문제 및 해결 (Troubleshooting for Agents)
- **Localization**: `initializeDateFormatting('ko_KR', null)` 호출 필수.
- **Android Package Name**: `com.jeiel.zephyr_sky` (폴더 구조와 `build.gradle.kts` 일치 확인).
- **GitHub Pages**: 배포 소스가 "GitHub Actions"로 설정되어 있는지 항상 확인할 것.
