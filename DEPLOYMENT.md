# Zephyr Sky 앱 배포 가이드 (DEPLOYMENT.md)

이 문서는 Zephyr Sky 앱 빌드 및 배포 절차를 설명합니다.

---

## 1. 빌드 자동화 구조

GitHub Actions를 통해 릴리즈 APK 빌드가 자동화되어 있습니다.

### 트리거 조건
- **일반 푸시** (`git push`) → 소스코드만 업로드, 빌드 없음
- **태그 푸시** (`git tag v1.x.x && git push origin v1.x.x`) → 빌드 + APK 생성 + GitHub 릴리즈 자동 등록

### 배포 흐름
```
코드 수정 → git push (일반) → 개발 중 계속 반복
배포할 때 → pubspec.yaml 버전 업 → git push → git tag vX.X.X → git push origin vX.X.X
          → GitHub Actions 자동 빌드 → GitHub Releases에 APK 자동 등록
```

---

## 2. 릴리즈 서명 설정 (완료)

### 2.1 키스토어 정보
릴리즈 APK는 릴리즈 키스토어로 서명됩니다. 키스토어 파일은 git에 포함되지 않으며 GitHub Secrets에 등록되어 CI에서 자동으로 복원됩니다.

- **파일명:** `release.keystore`
- **Key Alias:** `zephyr-sky`
- **패키지명:** `com.jeiel.zephyr_sky`

> **중요:** 키스토어 파일과 비밀번호를 분실하면 동일 앱으로 업데이트 배포가 불가능합니다. 반드시 안전한 곳에 백업하세요.

### 2.2 GitHub Secrets 등록 항목
GitHub 저장소 **Settings > Secrets and variables > Actions**에 아래 4개가 등록되어 있습니다.

| Secret 이름 | 설명 |
|-------------|------|
| `RELEASE_KEYSTORE_BASE64` | 키스토어 파일 Base64 인코딩 값 |
| `RELEASE_STORE_PASSWORD` | 키스토어 비밀번호 |
| `RELEASE_KEY_ALIAS` | 키 별칭 (`zephyr-sky`) |
| `RELEASE_KEY_PASSWORD` | 키 비밀번호 |

어느 PC에서 작업하더라도 태그 푸시만 하면 동일한 서명의 릴리즈 APK가 생성됩니다.

---

## 3. 버전 관리 체계

### 버전 정의 위치
버전은 **`pubspec.yaml` 한 곳에서만 관리**합니다.

```yaml
version: 1.0.8+8   # 형식: 버전명+빌드번호
```

- `android/app/build.gradle.kts`는 `flutter.versionCode` / `flutter.versionName`으로 pubspec을 자동 참조
- 별도로 버전을 수정할 파일 없음
- **단, CI 빌드 시 빌드 번호(`+N`)는 GitHub Actions 실행 번호로 자동 덮어씌워짐** (버전명 `X.X.X`은 pubspec 값 그대로 사용)

### 버전 업 및 배포 절차

```bash
# 1. pubspec.yaml 버전 수정 (버전명과 빌드번호 함께 올림)
#    예: version: 1.0.8+8 → version: 1.0.9+9

# 2. 커밋 및 푸시
git add pubspec.yaml
git commit -m "chore: 버전 X.X.X으로 업"
git push origin main

# 3. 태그 생성 및 푸시 (빌드 트리거 — 이 시점에 APK 빌드 시작)
git tag vX.X.X
git push origin vX.X.X
```

빌드 진행 상황: https://github.com/jeiel85/zephyr-sky/actions  
릴리즈 페이지: https://github.com/jeiel85/zephyr-sky/releases

---

## 4. 현재 배포 상태

- **GitHub Release:** 운영 중 ([릴리즈 페이지](https://github.com/jeiel85/zephyr-sky/releases))
- **Brand Page:** 운영 중 ([소개 페이지](https://jeiel85.github.io/zephyr-sky/))
    - **주의:** GitHub 저장소의 **Settings > Pages > Build and deployment > Source**가 반드시 **"GitHub Actions"**로 설정되어 있어야 합니다.
- **배포 파일:** `app-release.apk` (릴리즈 서명 APK)

---

## 5. 구글 플레이 스토어 배포 (향후)

### 스토어 등록 정보
- **앱 이름:** Zephyr Sky
- **간단한 설명:** 지적인 산들바람처럼, 당신의 일상을 채우는 날씨
- **자세한 설명:** 복잡한 정보는 걷어내고 현재 위치 및 검색한 도시의 핵심 날씨 정보만 유려한 그라데이션 UI로 제공합니다.
- **아이콘:** 512x512 PNG (`assets/icon/app_icon.png`)
- **스크린샷:** 폰, 7인치 태블릿, 10인치 태블릿용 스크린샷 각 2~8장 필요

플레이 스토어 자동 배포가 필요할 경우 AAB 빌드 및 `SERVICE_ACCOUNT_JSON` 시크릿 추가가 필요합니다.

---

## 6. 유지보수
- 배포가 완료될 때마다 `HISTORY.md`를 갱신하여 이력을 관리합니다.
