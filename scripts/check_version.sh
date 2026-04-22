#!/usr/bin/env bash
# 태그 푸시 전 버전 일치 여부를 검증하는 스크립트
# 사용법: ./scripts/check_version.sh v1.2.1
#         인자 없이 실행 시 pubspec.yaml 버전 기반으로 예상 태그를 안내

set -e

PUBSPEC="pubspec.yaml"

# pubspec.yaml에서 버전명(X.X.X) 추출 (빌드번호 제외)
PUBSPEC_VERSION=$(grep "^version:" "$PUBSPEC" | sed 's/version: //' | cut -d'+' -f1 | tr -d '[:space:]')
PUBSPEC_BUILD=$(grep "^version:" "$PUBSPEC" | sed 's/version: //' | cut -d'+' -f2 | tr -d '[:space:]')
EXPECTED_TAG="v${PUBSPEC_VERSION}"

echo "========================================="
echo "  Zephyr Sky 배포 전 버전 체크"
echo "========================================="
echo "  pubspec.yaml 버전 : ${PUBSPEC_VERSION}+${PUBSPEC_BUILD}"
echo "  예상 태그          : ${EXPECTED_TAG}"

# 인자로 태그를 받은 경우 일치 여부 검증
if [ -n "$1" ]; then
  INPUT_TAG="$1"
  echo "  입력한 태그        : ${INPUT_TAG}"
  echo "-----------------------------------------"

  if [ "$INPUT_TAG" != "$EXPECTED_TAG" ]; then
    echo "  [FAIL] 태그 불일치!"
    echo ""
    echo "  pubspec.yaml 버전이 ${PUBSPEC_VERSION}이므로 태그는 ${EXPECTED_TAG} 여야 합니다."
    echo "  입력한 태그: ${INPUT_TAG}"
    echo ""
    echo "  해결 방법:"
    echo "    1) pubspec.yaml 버전을 태그에 맞게 수정하거나"
    echo "    2) 태그를 ${EXPECTED_TAG} 로 변경하세요."
    exit 1
  fi

  echo "  [PASS] 태그와 pubspec.yaml 버전이 일치합니다."
else
  echo "-----------------------------------------"
  echo "  [INFO] 태그 인자가 없습니다."
  echo "         태그 푸시 전 아래 명령으로 검증하세요:"
  echo ""
  echo "    ./scripts/check_version.sh ${EXPECTED_TAG}"
  echo ""
fi

# 커밋되지 않은 변경사항 확인
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "-----------------------------------------"
  echo "  [WARN] 커밋되지 않은 변경사항이 있습니다."
  echo "         태그 푸시 전에 모든 변경사항을 커밋하세요."
  git status --short
  exit 1
fi

# 로컬 브랜치가 origin/main 에 반영됐는지 확인
git fetch origin --quiet
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)
if [ "$LOCAL" != "$REMOTE" ]; then
  echo "-----------------------------------------"
  echo "  [WARN] 로컬 커밋이 origin/main에 반영되지 않았습니다."
  echo "         git push origin main 을 먼저 실행하세요."
  exit 1
fi

echo "========================================="
echo "  모든 검사 통과 - 태그 푸시 준비 완료"
echo ""
echo "  다음 명령으로 배포를 시작하세요:"
echo "    git tag ${EXPECTED_TAG}"
echo "    git push origin ${EXPECTED_TAG}"
echo "========================================="
