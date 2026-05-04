#!/bin/bash
# 키스토어 생성 스크립트
# 용도: Play Store 출시용 서명 키 생성

echo "=========================================="
echo "  Zephyr Sky - 키스토어 생성 도구"
echo "=========================================="
echo ""

# 현재 디렉토리 확인
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_DIR="$SCRIPT_DIR/android/app"
KEYSTORE_FILE="$ANDROID_DIR/release.keystore"

echo "📂 작업 디렉토리: $ANDROID_DIR"
echo ""

# 이미 키스토어가 존재하는지 확인
if [ -f "$KEYSTORE_FILE" ]; then
    echo "⚠️  경고: $KEYSTORE_FILE 이 이미 존재합니다."
    read -p "덮어쓰시겠습니까? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "❌ 작업이 취소되었습니다."
        exit 1
    fi
fi

echo ""
echo "🔐 키스토어 생성을 시작합니다..."
echo "안전한 비밀번호를 입력하세요 (최소 6자 이상)"
echo ""

# 키스토어 생성
keytool -genkey -v \
  -keystore "$KEYSTORE_FILE" \
  -alias zephyr_sky \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# 결과 확인
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 키스토어 생성 완료!"
    echo "📄 파일 위치: $KEYSTORE_FILE"
    echo ""
    echo "⚠️  중요: 아래 정보를 안전한 곳에 보관하세요!"
    echo "=========================================="
    echo "KEYSTORE_FILE: release.keystore"
    echo "KEY_ALIAS: zephyr_sky"
    echo "=========================================="
    echo ""
    echo "📝 GitHub Secrets 설정 시 필요한 정보:"
    echo "1. RELEASE_STORE_FILE: release.keystore"
    echo "2. RELEASE_STORE_PASSWORD: (입력한 비밀번호)"
    echo "3. RELEASE_KEY_ALIAS: zephyr_sky"
    echo "4. RELEASE_KEY_PASSWORD: (입력한 키 비밀번호)"
    echo ""
    echo "🔒 보안 주의사항:"
    echo "- 키스토어 파일과 비밀번호를 안전하게 보관하세요"
    echo "- 절대 Git에 커밋하지 마세요!"
    echo "- .gitignore에 release.keystore가 포함되어 있는지 확인하세요"
    echo ""
else
    echo ""
    echo "❌ 키스토어 생성 실패!"
    exit 1
fi

# .gitignore 확인
GITIGNORE="$SCRIPT_DIR/.gitignore"
if [ -f "$GITIGNORE" ]; then
    if ! grep -q "release.keystore" "$GITIGNORE"; then
        echo "📝 .gitignore에 release.keystore 추가 중..."
        echo "" >> "$GITIGNORE"
        echo "# Keystore files (Play Store signing)"
        echo "release.keystore" >> "$GITIGNORE"
        echo "*.keystore" >> "$GITIGNORE"
        echo "✅ .gitignore 업데이트 완료"
    else
        echo "✅ .gitignore에 이미 release.keystore가 포함되어 있습니다"
    fi
else
    echo "⚠️  .gitignore 파일이 없습니다. 수동으로 추가해주세요:"
    echo "release.keystore"
    echo "*.keystore"
fi

echo ""
echo "=========================================="
echo "  키스토어 설정이 완료되었습니다!"
echo "=========================================="
