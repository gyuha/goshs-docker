# goshs Docker Compose 구성

## What This Is

goshs(Go Simple HTTP Server)를 Docker Compose로 배포하기 위한 구성 파일 프로젝트다. 홈 서버 환경에서 파일 공유를 목적으로 사용하며, `.env` 파일 기반 환경 변수로 인증, HTTPS/TLS, 파일 업로드, 클립보드 공유 기능을 개별적으로 ON/OFF할 수 있다.

## Core Value

`.env` 파일 하나만 수정하면 goshs의 모든 주요 기능을 재빌드 없이 켜고 끌 수 있어야 한다.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Docker Compose 파일로 goshs 컨테이너 실행
- [ ] `.env` 파일로 기능 ON/OFF 제어 (인증, HTTPS, 업로드, 클립보드)
- [ ] Basic Auth (username/password) 활성화/비활성화
- [ ] HTTPS/TLS 활성화/비활성화 (자체 서명 인증서 포함)
- [ ] 파일 업로드 허용/차단
- [ ] 클립보드 공유 활성화/비활성화
- [ ] 서빙할 디렉토리를 볼륨으로 마운트
- [ ] `docker compose up -d`로 즉시 실행 가능한 구성

### Out of Scope

- Kubernetes 배포 — 홈 서버 단일 컨테이너 환경이 목표
- 외부 CA 인증서 자동 갱신 (Let's Encrypt 등) — 복잡도 증가
- 모니터링/로깅 스택 — 단순 파일 서버가 목표

## Context

- goshs 공식 문서: https://docs.goshs.de/installation/index.html
- goshs는 커맨드라인 플래그로 기능을 제어하며, 환경 변수를 직접 지원하지 않으므로 Docker entrypoint 스크립트로 `.env` → CLI 플래그 변환이 필요하다
- 홈 서버 환경: 항상 켜두는 용도, 재시작 정책 always 적용

## Constraints

- **Tech Stack**: Docker Compose v2, goshs 공식 이미지
- **호환성**: 환경 변수 → CLI 플래그 변환 로직이 goshs CLI 인터페이스에 의존
- **보안**: Basic Auth 없이 HTTPS만으로 공개 노출하지 않도록 문서화

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| 환경 변수 → 플래그 변환 방식 | goshs가 환경 변수를 네이티브 지원하지 않음 | — Pending |
| Docker entrypoint 스크립트 사용 | .env 값을 읽어 goshs 플래그 동적 생성 | — Pending |

---
*Last updated: 2026-05-17 after initialization*

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state
