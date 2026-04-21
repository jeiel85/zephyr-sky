# Zephyr Sky 앱 배포 가이드 (DEPLOYMENT.md)

이 문서는 Zephyr Sky 앱을 구글 플레이 스토어 및 기타 플랫폼에 배포하기 위한 절차를 설명합니다.

## 1. 구글 플레이 스토어 배포 준비물

### 1.1 구글 플레이 개발자 계정
- [Google Play Console](https://play.google.com/apps/publish/)에 접속하여 개발자 등록 완료 (등록비 약 $25).

### 1.2 앱 서명 키 (Keystore) 생성
안드로이드 앱은 반드시 디지털 서명이 되어야 배포가 가능합니다.
- **패키지명:** `com.jeiel.zephyr_sky`
- **명령어 예시 (로컬 터미널):**
  ```bash
  keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
- 생성 후 `android/key.properties` 파일을 만들어 경로와 비밀번호를 관리해야 합니다. (이 파일은 `.gitignore`에 추가되어야 합니다.)

### 1.3 스토어 등록 정보 (Store Listing)
- **앱 이름:** Zephyr Sky
- **간단한 설명:** 지적인 산들바람처럼, 당신의 일상을 채우는 날씨
- **자세한 설명:** 복잡한 정보는 걷어내고 현재 위치 및 검색한 도시의 핵심 날씨 정보만 유려한 그라데이션 UI로 제공합니다.
- **아이콘:** 512x512 PNG (이미 `assets/icon/app_icon.png`에 준비됨)
- **스크린샷:** 폰, 7인치 태블릿, 10인치 태블릿용 스크린샷 각 2~8장 필요.

---

## 2. 배포 자동화 (CI/CD) 고도화

현재 GitHub Actions를 통해 APK/AAB 빌드는 자동화되어 있습니다. 실제 스토어 배포까지 자동화하려면 다음 단계가 필요합니다.

### 2.1 GitHub Secrets 설정
GitHub 저장소의 **Settings > Secrets and variables > Actions**에 다음 항목을 안전하게 등록해야 합니다.
- `KEYSTORE_BASE64`: 생성한 `.jks` 파일을 Base64로 인코딩한 문자열
- `KEY_PROPERTIES`: 키 파일 경로 및 비밀번호 정보
- `SERVICE_ACCOUNT_JSON`: 구글 커넥트용 서비스 계정 키 (자동 업로드 시 필요)

---

## 3. 현재 배포 상태 (v1.0.0)

- **GitHub Release:** 완료 ([릴리즈 페이지 바로가기](https://github.com/jeiel85/zephyr-sky/releases))
- **Brand Page:** 가동 중 ([소개 페이지 바로가기](https://jeiel85.github.io/zephyr-sky/))
- **배포 파일:** `app-release.apk` (설치용), `app-release.aab` (스토어 업로드용)

## 4. 향후 유지보수 계획
- 새로운 기능 추가 시 `pubspec.yaml`의 `version` 값을 올리고 태그를 푸시합니다.
- 배포가 완료될 때마다 `HISTORY.md`를 갱신하여 이력을 관리합니다.
