# goshs-docker

[goshs](https://docs.goshs.de)(Go Simple HTTP Server)를 Docker Compose로 배포하기 위한 구성 파일 모음입니다.

`.env` 파일 하나만 수정하면 인증, HTTPS, 파일 업로드, 클립보드 공유 기능을 재빌드 없이 켜고 끌 수 있습니다.

## 빠른 시작

```bash
# 1. 저장소 클론
git clone https://github.com/gyuha/goshs-docker.git
cd goshs-docker

# 2. 환경 파일 복사
cp .env.example .env

# 3. .env 수정 (필요한 경우)
# vi .env

# 4. 컨테이너 시작 (첫 실행 시 이미지 빌드 포함)
docker compose up -d

# 5. 브라우저에서 접근
# http://localhost:8000
```

## 기능 설정

`.env` 파일에서 아래 변수를 수정하여 기능을 제어합니다. 변경 후 `docker compose restart`로 적용합니다.

| 변수명 | 기본값 | 설명 |
|--------|--------|------|
| `GOSHS_PORT` | `8000` | 서비스 포트. 브라우저 접근 주소(`http://호스트:포트`)에 반영됨 |
| `GOSHS_SHARE_DIR` | `./shared` | 공유할 호스트 디렉토리 경로. 절대 경로 또는 상대 경로 모두 가능 |
| `GOSHS_AUTH_ENABLED` | `false` | `true` 시 Basic Auth(username/password) 활성화 |
| `GOSHS_AUTH_USERNAME` | `admin` | 인증 사용자 이름. `GOSHS_AUTH_ENABLED=true`일 때만 유효 |
| `GOSHS_AUTH_PASSWORD` | `changeme` | 인증 비밀번호. 평문 또는 bcrypt 해시 사용 가능 |
| `GOSHS_TLS_ENABLED` | `false` | `true` 시 자체 서명 인증서로 HTTPS 활성화 |
| `GOSHS_UPLOAD_ENABLED` | `false` | `true` 시 브라우저에서 파일 업로드 허용 |
| `GOSHS_CLIPBOARD_ENABLED` | `true` | `false` 시 웹소켓 클립보드 공유 비활성화 |

> **주의:** `GOSHS_TLS_ENABLED=true`이면 브라우저 주소를 `https://`로 변경해야 합니다.
> Basic Auth 없이 서버를 외부에 공개하지 마세요.

## 사용 예시

설정 변경 후 `docker compose restart`로 적용합니다. 재빌드는 필요 없습니다.

### 인증 활성화

```env
GOSHS_AUTH_ENABLED=true
GOSHS_AUTH_USERNAME=admin
GOSHS_AUTH_PASSWORD=changeme
```

### HTTPS 활성화

```env
GOSHS_TLS_ENABLED=true
```

자체 서명 인증서이므로 브라우저에서 보안 경고가 표시됩니다. 무시하고 진행하거나, 터미널에서는 `curl -k https://localhost:8000`으로 접근합니다.

### 파일 업로드 허용

```env
GOSHS_UPLOAD_ENABLED=true
GOSHS_SHARE_DIR=/mnt/nas/files
```

업로드된 파일은 `GOSHS_SHARE_DIR`로 지정한 디렉토리에 저장됩니다.

### 클립보드 공유 비활성화

```env
GOSHS_CLIPBOARD_ENABLED=false
```

## 비밀번호 해시 생성

평문 비밀번호 대신 bcrypt 해시를 사용하면 보안이 강화됩니다.

```bash
# 컨테이너가 실행 중인 상태에서 실행
docker exec -it goshs goshs -H
```

프롬프트에 비밀번호를 입력하면 해시 값이 출력됩니다. 출력된 해시를 `.env`의 `GOSHS_AUTH_PASSWORD`에 붙여넣습니다.

```env
GOSHS_AUTH_ENABLED=true
GOSHS_AUTH_USERNAME=admin
GOSHS_AUTH_PASSWORD=$2a$14$ydRJ//Ob4SctB/D7o.rvU.LmPs/vwXkeXCbtpCqzgOJDSShLgiY52
```

> 해시에 `$` 문자가 포함되어 있으면 `.env` 파일에 직접 저장할 때 별도의 이스케이프가 필요 없습니다.

## 디렉토리 구조

```
goshs-docker/
├── Dockerfile          # goshs v2.0.8 바이너리 다운로드 및 Alpine 이미지 빌드
├── entrypoint.sh       # .env 환경 변수 → goshs CLI 플래그 변환
├── docker-compose.yml  # 서비스 정의 (포트, 볼륨, 환경 파일)
├── .env.example        # 설정 템플릿 — 이 파일을 .env로 복사하여 사용
├── .env                # 실제 설정 파일 (git 추적 제외)
└── shared/             # 기본 공유 디렉토리 (GOSHS_SHARE_DIR 기본값)
```

## 참고

- goshs 공식 문서: https://docs.goshs.de
- goshs GitHub: https://github.com/patrickhener/goshs
