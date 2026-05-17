#!/bin/sh
set -e

ARGS="-d /shared"
ARGS="$ARGS -p ${GOSHS_PORT:-8000}"

# Basic Auth  (-b user:pass)
if [ "${GOSHS_AUTH_ENABLED:-false}" = "true" ]; then
    if [ -z "${GOSHS_AUTH_USERNAME}" ] || [ -z "${GOSHS_AUTH_PASSWORD}" ]; then
        echo "ERROR: GOSHS_AUTH_ENABLED=true 이면 GOSHS_AUTH_USERNAME 과 GOSHS_AUTH_PASSWORD 가 필요합니다"
        exit 1
    fi
    ARGS="$ARGS -b ${GOSHS_AUTH_USERNAME}:${GOSHS_AUTH_PASSWORD}"
fi

# HTTPS/TLS  (-s -ss: 자체 서명 인증서)
if [ "${GOSHS_TLS_ENABLED:-false}" = "true" ]; then
    ARGS="$ARGS -s -ss"
fi

# 파일 업로드  (-uf: 업로드 활성화 | -ro: 읽기 전용으로 업로드 차단)
if [ "${GOSHS_UPLOAD_ENABLED:-false}" = "true" ]; then
    ARGS="$ARGS -uf /shared"
else
    ARGS="$ARGS -ro"
fi

# 클립보드 공유  (-nc: 비활성화)
if [ "${GOSHS_CLIPBOARD_ENABLED:-true}" = "false" ]; then
    ARGS="$ARGS -nc"
fi

echo "Starting: goshs $ARGS"
exec goshs $ARGS
