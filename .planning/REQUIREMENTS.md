# Requirements: goshs Docker Compose 구성

**Defined:** 2026-05-17
**Core Value:** `.env` 파일 하나만 수정하면 goshs의 모든 주요 기능을 재빌드 없이 켜고 끌 수 있어야 한다.

## v1 Requirements

### 컨테이너 기본 설정

- [ ] **BASE-01**: `docker compose up -d` 명령으로 goshs 컨테이너가 즉시 실행된다
- [ ] **BASE-02**: 서빙할 로컬 디렉토리를 볼륨으로 마운트하여 goshs가 파일을 제공한다
- [ ] **BASE-03**: 컨테이너가 재시작 시 자동으로 복구된다 (restart: always)
- [ ] **BASE-04**: 포트를 `.env`에서 설정 가능하다 (기본: 8000)

### 인증 (Basic Auth)

- [ ] **AUTH-01**: `GOSHS_AUTH_ENABLED=true` 설정 시 Basic Auth가 활성화된다
- [ ] **AUTH-02**: `AUTH_USERNAME`, `AUTH_PASSWORD` 환경 변수로 자격증명을 설정한다
- [ ] **AUTH-03**: `GOSHS_AUTH_ENABLED=false` 설정 시 인증 없이 접근 가능하다

### HTTPS/TLS

- [ ] **TLS-01**: `GOSHS_TLS_ENABLED=true` 설정 시 HTTPS가 활성화된다
- [ ] **TLS-02**: 자체 서명 인증서(self-signed)를 자동 사용한다
- [ ] **TLS-03**: `GOSHS_TLS_ENABLED=false` 설정 시 HTTP로 동작한다

### 파일 업로드

- [ ] **UPLD-01**: `GOSHS_UPLOAD_ENABLED=true` 설정 시 브라우저에서 파일 업로드가 가능하다
- [ ] **UPLD-02**: 업로드된 파일은 서빙 디렉토리와 동일한 위치에 저장된다
- [ ] **UPLD-03**: `GOSHS_UPLOAD_ENABLED=false` 설정 시 다운로드 전용 모드로 동작한다

### 클립보드 공유

- [ ] **CLIP-01**: `GOSHS_CLIPBOARD_ENABLED=true` 설정 시 웹소켓 기반 클립보드 공유가 활성화된다
- [ ] **CLIP-02**: `GOSHS_CLIPBOARD_ENABLED=false` 설정 시 클립보드 기능이 비활성화된다

### 구성 파일 및 문서

- [ ] **DOC-01**: `.env.example` 파일에 모든 설정 옵션과 설명이 문서화된다
- [ ] **DOC-02**: `entrypoint.sh`가 환경 변수를 goshs CLI 플래그로 변환한다

## v2 Requirements

### 추가 기능 (향후)

- **V2-01**: Let's Encrypt 자동 인증서 갱신
- **V2-02**: WebDAV 지원 토글
- **V2-03**: IP 화이트리스트 설정
- **V2-04**: 웹훅 알림 (파일 업로드 시)
- **V2-05**: 읽기 전용 / 업로드 전용 모드 토글

## Out of Scope

| Feature | Reason |
|---------|--------|
| Kubernetes 배포 | 단일 홈 서버 환경이 목표 |
| 외부 CA 인증서 자동 갱신 | v1 복잡도 초과 |
| 모니터링/로깅 스택 | 단순 파일 서버가 목표 |
| 커스텀 Dockerfile 빌드 | 공식 이미지 + entrypoint.sh로 충분 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| BASE-01 | Phase 1 | Pending |
| BASE-02 | Phase 1 | Pending |
| BASE-03 | Phase 1 | Pending |
| BASE-04 | Phase 1 | Pending |
| AUTH-01 | Phase 1 | Pending |
| AUTH-02 | Phase 1 | Pending |
| AUTH-03 | Phase 1 | Pending |
| TLS-01 | Phase 1 | Pending |
| TLS-02 | Phase 1 | Pending |
| TLS-03 | Phase 1 | Pending |
| UPLD-01 | Phase 1 | Pending |
| UPLD-02 | Phase 1 | Pending |
| UPLD-03 | Phase 1 | Pending |
| CLIP-01 | Phase 1 | Pending |
| CLIP-02 | Phase 1 | Pending |
| DOC-01 | Phase 1 | Pending |
| DOC-02 | Phase 1 | Pending |

**Coverage:**
- v1 requirements: 17 total
- Mapped to phases: 17
- Unmapped: 0 ✓

---
*Requirements defined: 2026-05-17*
*Last updated: 2026-05-17 after initial definition*
