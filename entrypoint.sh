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

# HTTPS/TLS
if [ "${GOSHS_TLS_ENABLED:-false}" = "true" ]; then
    TLS_MODE="${GOSHS_TLS_MODE:-self-signed}"
    case "$TLS_MODE" in
        self-signed)
            ARGS="$ARGS -s -ss"
            ;;
        letsencrypt)
            if [ -z "${GOSHS_TLS_DOMAIN}" ] || [ -z "${GOSHS_TLS_EMAIL}" ]; then
                echo "ERROR: GOSHS_TLS_MODE=letsencrypt 이면 GOSHS_TLS_DOMAIN 과 GOSHS_TLS_EMAIL 이 필요합니다"
                exit 1
            fi
            ARGS="$ARGS -s -sl -sld ${GOSHS_TLS_DOMAIN} -sle ${GOSHS_TLS_EMAIL}"
            ;;
        custom)
            CERT="${GOSHS_TLS_CERT_FILE:-/certs/cert.pem}"
            KEY="${GOSHS_TLS_KEY_FILE:-/certs/key.pem}"
            if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
                echo "ERROR: GOSHS_TLS_MODE=custom 이면 $CERT 와 $KEY 가 존재해야 합니다"
                exit 1
            fi
            ARGS="$ARGS -s -sk ${KEY} -sc ${CERT}"
            ;;
        *)
            echo "ERROR: GOSHS_TLS_MODE='${TLS_MODE}' 는 유효하지 않습니다 (self-signed|letsencrypt|custom)"
            exit 1
            ;;
    esac
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
