# 프로젝트 이력 관리 (HISTORY.md)

## [2026-04-20] 프로젝트 시작 및 초기 설정

### 작업 내용
- Flutter (Dart)를 프레임워크로 선정하고 프로젝트 `open_weather` 초기화.
- Open-Meteo API를 날씨 데이터 소스로 결정.
- 미니멀리즘 디자인 철학 및 상태바 알림 기능 명세 수립.
- Git 저장소 설정 및 초기 파일 구조 생성 완료.
- `HISTORY.md`를 통한 이력 관리 체계 구축.

### 현재 상태
- Flutter 기본 템플릿 프로젝트가 생성됨.
- 로컬 `D:\flutter` 경로의 SDK를 연동함.
- `http`, `geolocator`, `flutter_riverpod`, `isar`, `flutter_local_notifications` 등 주요 패키지 설치 완료.
- 클린 아키텍처 기반 폴더 구조 설계 및 데이터 레이어 구현 완료.
- 프리젠테이션 레이어(UI) 및 상태 관리(Riverpod) 기본 구현 완료.
- 상태바 알림 기능 구현 및 날씨 데이터 연동 완료.
- 위치 검색 기능(`SearchScreen`) 추가 및 전반적인 UI 디자인 개선 완료.

## [2026-04-20] 위치 검색 기능 추가 및 UI 고도화

### 작업 내용
- `SearchScreen` 구현 (도시 이름 기반 위치 검색 및 선택 기능).
- Open-Meteo Geocoding API 연동 (`searchLocation` 메서드 확장).
- `searchResultsProvider` 및 `SearchNotifier` 추가.
- `HomeScreen` 레이아웃 개선 (검색 및 새로고침 버튼 배치).
- 날씨 상태에 따른 동적 그라데이션 배경 로직 정교화.
