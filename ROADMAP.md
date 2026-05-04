# Zephyr Sky 개발 로드맵 - 상위 날씨 앱 기능 분석 기반

## 프로젝트 개요
**목표:** 상위 TOP 5 날씨 앱들의 모든 기능을 분석하여, 오픈소스 기반(Open-Meteo API)을 유지하면서 완전한 날씨 앱 개발

### 참고한 상위 날씨 앱
1. **The Weather Channel** - 전 세계 가장 정확한 날씨 앱 (University of Reading 연구)
2. **AccuWeather** - MinuteCast, RealFeel, 45일 예보
3. **WeatherBug** - Lightning detection, Outdoor Sports
4. **Dark Sky (Apple Weather)** - 미세한 시간별 예보, 하이퍼로컬
5. **CARROT Weather** - 독특한 UX, 커스터마이징

---

## 현재 앱 상태 (v1.3.0)

### ✅ 구현 완료 기능
| 기능 | 파일 | 상태 |
|------|------|------|
| 현재 위치 날씨 조회 | location_service.dart | 완료 |
| 전 세계 도시 검색 | search_screen.dart | 완료 |
| 시간별 예보 (48시간) | weather_model.dart | 완료 |
| 일별 예보 (16일) | weather_model.dart | 완료 |
| 날씨 아이콘/설명 | weather_helper.dart | 완료 |
| 동적 그라데이션 UI | home_screen.dart | 완료 |
| 다크 모드 / 라이트 모드 | settings_provider.dart | 완료 |
| 단위 설정 (°C / °F) | settings_provider.dart | 완료 |
| 즐겨찾기 위치 관리 | weather_repository_impl.dart | 완료 |
| 마지막 위치 저장 | weather_repository_impl.dart | 완료 |
| 날씨 캐싱 | weather_repository_impl.dart | 완료 |
| 상태바 알림 | notification_service.dart | 완료 |
| AQI (대기질 지수) | weather_model.dart | 완료 |
| UV Index (자외선 지수) | weather_model.dart | 완료 |
| 강수 확률 | weather_model.dart | 완료 |
| 일출/일몰 시간 | weather_model.dart | 완료 |
| 상세 기상 정보 (기압, 시정, 이슬점) | weather_model.dart | 완료 |
| 날씨 상세 그래프 | weather_chart.dart | 완료 |
| 안드로이드 홈 스크린 위젯 | home_widget_service.dart | 완료 |
| 날씨 경고 (강풍, 한파, 폭염, UV, 대기질) | notification_service.dart | 완료 |
| 야외 활동 지수 | weather.dart | 완료 |

---

## 🗺️ 개발 로드맵 (5단계)

### Phase 1: 확장 날씨 데이터 표시 (AQI, UV, 48시간 예보 등) - [HIGH PRIORITY]
**설명:** 사용자에게 즉시 유용한 날씨 지표들을 추가합니다.

#### 포함 기능:
- 🌬️ **AQI (空气质量 지수)** - 대기오염 상태 표시
- ☀️ **UV Index (자외선 지수)** - 자외선 노출 수준
- 🌧️ **강수 확률 (Precipitation Probability)**
- 🌅 **일출/일몰 시간**
- 📊 **상세 기상 정보** (기압, 시정, 이슬점, 구름량)
- ⏰ **시간대별 예보 48시간으로 확장** (현재 24시간)
- 📅 **일별 예보 16일로 확장** (현재 7일)

#### 기술 구현:
- Open-Meteo Weather API의 확장된 파라미터 활용
- Open-Meteo Air Quality API 통합

---

### Phase 2: 날씨 알림 및 경고 시스템
**설명:** 사용자를 다양한 날씨 상황으로부터 보호하는 경고 시스템

#### 포함 기능:
- ⚠️ **강한 바람 경고**
- ❄️ **한파/추위 경고**
- 🌊 **태풍/호우 경고**
- 🌡️ **고온/저온 경고**
- 📱 **시간대별 푸시 알림** (사용자 설정)
- ⏰ **일출/일몰 알림**
- 🌙 **야간 날씨 요약 알림**

#### 기술 구현:
- Flutter Local Notifications 확장
- 날씨 임계값 기반 경고 로직

---

### Phase 3: 사용자 경험 (UX) 강화
**설명:** 상위 날씨 앱들의 차별화된 UX 기능을 수용

#### 포함 기능:
- 🔄 **Pull-to-refresh 개선** (물리적 새로고침 시각 피드백)
- 🎨 **다크 모드 / 라이트 모드 전환**
- 🌡️ **단위 설정** (°C / °F 토글)
- 🌍 **언어 설정** (한국어 + 영어)
- 📍 **즐겨찾기 위치 관리** (여러 지역 저장)
- 🏠 **위치 관리 화면** (편집/삭제/기본 위치 설정)
- 📊 **날씨 상세 그래프** (온도 추이, 강수량 시각화)

#### 기술 구현:
- ThemeProvider 상태 관리
- SharedPreferences에 설정 저장
- 위치 관리 CRUD 기능

---

### Phase 4: 위젯 및 시스템 통합
**설명:** 홈 화면 위젯 및 시스템 레벨 통합

#### 포함 기능:
- 📲 **안드로이드 홈 스크린 위젯**
- 🔔 **실시간 업데이트 위젯**
- ⏱️ **위젯 클릭 시 앱 실행**
- 🔋 **배터리 효율적인 업데이트 스케줄**

#### 기술 구현:
- home_widget 패키지 활용
- 백그라운드 서비스 최적화

---

### Phase 5: 고급 기능 및 최적화
**설명:** 전문가급 날씨 기능 및 성능 최적화

#### 포함 기능:
- 🛰️ **레이다/위성 imagery (외부 API 연동)**
- 🏃 **야외 활동 지수** (운동, 자외선, 대기오염 등)
- 🤖 **AI 기반 날씨 요약** (OpenAI API 연동 - 선택적)
- 📈 **기후 데이터 분석** (월별 평균, 기록적 날씨)
- 🌐 **오프라인 모드 최적화**
- 🔒 **개인정보 보호 강화**
- 🧪 **단위 테스트 커버리지 80%+**

---

## 📋 GitHub 이슈로 생성할 작업 목록

```
Phase 1 (현재):
- [Phase 1] 확장 날씨 데이터 표시 (AQI, UV, 48시간 예보 등)

Phase 2:
- [Phase 2] 날씨 알림 및 경고 시스템
- [Phase 2] Severe Weather Alerts 구현

Phase 3:
- [Phase 3] 다크 모드 / 라이트 모드 전환
- [Phase 3] 단위 설정 (°C / °F)
- [Phase 3] 즐겨찾기 위치 관리
- [Phase 3] 날씨 상세 그래프

Phase 4:
- [Phase 4] 안드로이드 홈 스크린 위젯
- [Phase 4] 실시간 업데이트 위젯

Phase 5:
- [Phase 5] 야외 활동 지수
- [Phase 5] 단위 테스트 추가
```

---

## 🛠️ 기술 스택 확장

### 기존 스택
- Flutter / Dart
- Riverpod (상태 관리)
- Open-Meteo API (날씨)
- SharedPreferences (로컬 저장소)

### 추가 필요 패키지 (Phase별)
| Phase | 패키지 | 용도 |
|-------|--------|------|
| 1 | http (기존) | Air Quality API |
| 2 | flutter_local_notifications (기존) | 알림 확장 |
| 3 | fl_chart | 날씨 그래프 |
| 4 | home_widget | 안드로이드 위젯 |
| 5 | - | 테스트 도구 |

---

## 📌 우선 구현 권장 순서

1. **Phase 1** → 가장 사용자에게 직접적인 가치 제공
2. **Phase 3** → UX 개선으로 사용자 만족도 향상
3. **Phase 2** → 날씨 경고는 필수 안전 기능
4. **Phase 4** → 위젯은 편의성 제공
5. **Phase 5** → 전문가급 기능으로 차별화

---

## ✅ 체크리스트

### Phase 1 완료 조건
- [x] AQI 표시 UI
- [x] UV Index 표시 UI
- [x] 강수 확률 표시 UI
- [x] 일출/일몰 시간 표시 UI
- [x] 상세 기상 정보 (기압, 시정, 이슬점)
- [x] 48시간 예보
- [x] 16일 예보
- [x] 빌드 성공

### Phase 2 완료 조건
- [x] 강한 바람 경고
- [x] 한파/추위 경고
- [x] 고온/저온 경고
- [x] UV 경고
- [x] 대기질 경고
- [x] 상태바 알림
- [ ] 시간대별 푸시 알림 (사용자 설정) — 미구현
- [ ] 일출/일몰 알림 — 미구현
- [ ] 야간 날씨 요약 알림 — 미구현

### Phase 3 완료 조건
- [x] Pull-to-refresh
- [x] 다크 모드 / 라이트 모드 전환
- [x] 단위 설정 (°C / °F)
- [x] 언어 설정 (한국어 + 영어) — [#1](https://github.com/jeiel85/zephyr-sky/issues/1)
- [x] 즐겨찾기 위치 관리
- [x] 위치 관리 화면 (편집/삭제/기본 위치 설정)
- [x] 날씨 상세 그래프

### Phase 4 완료 조건
- [x] 안드로이드 홈 스크린 위젯
- [x] 위젯 클릭 시 앱 실행
- [ ] 실시간 업데이트 위젯 (주기적 갱신) — 미구현
- [ ] 배터리 효율적인 업데이트 스케줄 — 미구현

### Phase 5 완료 조건
- [x] 야외 활동 지수
- [ ] 레이다/위성 imagery — 미정
- [ ] AI 기반 날씨 요약 — 미정
- [ ] 기후 데이터 분석 — 미정
- [x] 오프라인 모드 최적화 — [#2](https://github.com/jeiel85/zephyr-sky/issues/2)
- [ ] 개인정보 보호 강화 (지속적 개선)
- [ ] 단위 테스트 커버리지 80%+ — [#3](https://github.com/jeiel85/zephyr-sky/issues/3)

---

*로드맵 작성일: 2026-04-22*
*최종 업데이트: 2026-05-04*
*문서 관리: HISTORY.md에 각 Phase 완료 시 기록*