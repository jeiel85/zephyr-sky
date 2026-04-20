# Open Weather (오픈 웨더)

**완전 오픈 소스, 프라이버시 중심, 미니멀리즘 날씨 앱**

Open Weather는 사용자의 위치 정보를 존중하고 광고 없이 깨끗한 날씨 정보를 제공하는 Flutter 기반의 날씨 애플리케이션입니다. F-Droid와 구글 플레이 스토어 배포를 목표로 개발되었습니다.

## ✨ 주요 기능
- **실시간 날씨:** Open-Meteo API를 통한 정확한 날씨 데이터 (API Key 불필요)
- **상태바 알림:** 지속적인 알림바를 통해 위치, 현재 날씨, 최고/최저 기온을 항시 확인
- **예보 정보:** 향후 24시간 시간별 예보 및 7일간의 주간 예보 제공
- **위치 검색:** 전 세계 도시 검색 및 날씨 조회 기능
- **미니멀 디자인:** 날씨 상태에 따라 변하는 아름다운 그라데이션 배경과 깔끔한 UI

## 🛠 기술 스택
- **프레임워크:** Flutter (Dart)
- **상태 관리:** Riverpod (State Management)
- **데이터 소스:** Open-Meteo API (FOSS 친화적)
- **로컬 저장소:** Isar DB (캐싱 용도)
- **아키텍처:** Clean Architecture (Domain, Data, Presentation)

## 🏗 빌드 가이드 (Build Instructions)
1. **Flutter SDK 설치:** [공식 가이드](https://docs.flutter.dev/get-started/install)를 따라 설치하세요.
2. **저장소 클론:**
   ```bash
   git clone https://github.com/your-username/open-weather.git
   cd open-weather
   ```
3. **의존성 설치:**
   ```bash
   flutter pub get
   ```
4. **앱 실행:**
   ```bash
   flutter run
   ```
5. **APK 빌드:**
   ```bash
   flutter build apk --release
   ```

*참고: Windows 환경에서 빌드 시 '개발자 모드'를 활성화해야 심볼릭 링크 오류가 발생하지 않습니다.*

## 📜 라이선스 (License)
이 프로젝트는 **MIT 라이선스** 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 확인하세요.

---
**Privacy First:** 이 앱은 어떠한 사용자 데이터도 수집하거나 외부 서버로 전송하지 않습니다.
