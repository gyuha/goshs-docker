---
quick_id: 260517-fta
description: "README.md에 goshs-docker 프로젝트 사용 방법 및 설정 설명 작성"
created: 2026-05-17
files_modified:
  - README.md
autonomous: true
---

<objective>
현재 제목 한 줄만 있는 README.md를 실제 사용 가능한 문서로 교체한다.

Purpose: 처음 접한 사용자가 README.md만 읽고도 goshs-docker를 즉시 실행·설정할 수 있어야 한다.
Output: 섹션을 갖춘 README.md — 소개, 빠른 시작, 환경 변수 표, 사용 예시, 해시 생성, 디렉토리 구조.
</objective>

<context>
@/Users/gyuha/workspace/goshs-docker/.planning/PROJECT.md
@/Users/gyuha/workspace/goshs-docker/.env.example
@/Users/gyuha/workspace/goshs-docker/docker-compose.yml
@/Users/gyuha/workspace/goshs-docker/Dockerfile
@/Users/gyuha/workspace/goshs-docker/entrypoint.sh
</context>

<tasks>

<task type="auto">
  <name>Task 1: README.md 작성</name>
  <files>README.md</files>
  <action>
README.md를 아래 구조로 완전히 덮어쓴다. 기존 내용(제목 한 줄)은 버리고 처음부터 작성한다.

**섹션 1 — 프로젝트 소개**
- goshs(Go Simple HTTP Server)가 무엇인지 1~2문장으로 설명
- 이 저장소가 goshs를 Docker Compose로 배포하기 위한 구성 파일임을 명시
- `.env` 파일 하나로 재빌드 없이 기능 ON/OFF 가능하다는 핵심 가치 표기
- goshs 공식 사이트 링크: https://docs.goshs.de

**섹션 2 — 빠른 시작 (Quick Start)**
순서대로 번호 목록:
1. 저장소 클론: `git clone ... && cd goshs-docker`
2. 환경 파일 복사: `cp .env.example .env`
3. `.env` 수정 (필요 시)
4. 컨테이너 시작: `docker compose up -d`
5. 브라우저 접근: `http://localhost:8000` (또는 설정한 포트)

**섹션 3 — 기능 설정 (.env 변수)**
아래 7개 변수를 모두 포함한 Markdown 표:

| 변수명 | 기본값 | 설명 |
|--------|--------|------|
| GOSHS_PORT | 8000 | 서비스 포트. 브라우저 접근 주소에 반영됨 |
| GOSHS_SHARE_DIR | ./shared | 공유할 호스트 디렉토리 경로 (절대·상대 경로 모두 가능) |
| GOSHS_AUTH_ENABLED | false | true 시 Basic Auth 활성화 |
| GOSHS_AUTH_USERNAME | admin | 인증 사용자 이름 (AUTH_ENABLED=true 일 때만 유효) |
| GOSHS_AUTH_PASSWORD | changeme | 인증 비밀번호. 해시 사용 권장 (아래 섹션 참조) |
| GOSHS_TLS_ENABLED | false | true 시 자체 서명 인증서로 HTTPS 활성화 |
| GOSHS_UPLOAD_ENABLED | false | true 시 브라우저에서 파일 업로드 허용 |
| GOSHS_CLIPBOARD_ENABLED | true | false 시 클립보드 공유 비활성화 |

표 아래 주의사항:
- `GOSHS_TLS_ENABLED=true`이면 브라우저에서 `https://`로 접근해야 함
- Basic Auth 없이 HTTPS만으로 외부 공개하지 말 것

**섹션 4 — 사용 예시**
각 시나리오를 `.env` 스니펫과 함께 코드 블록으로 설명:

1. **인증 활성화**
   ```env
   GOSHS_AUTH_ENABLED=true
   GOSHS_AUTH_USERNAME=admin
   GOSHS_AUTH_PASSWORD=changeme
   ```

2. **HTTPS 활성화**
   ```env
   GOSHS_TLS_ENABLED=true
   ```
   접근 주소: `https://localhost:8000` (브라우저 인증서 경고 무시)

3. **파일 업로드 허용**
   ```env
   GOSHS_UPLOAD_ENABLED=true
   GOSHS_SHARE_DIR=/mnt/nas/files
   ```

4. **클립보드 공유 비활성화**
   ```env
   GOSHS_CLIPBOARD_ENABLED=false
   ```

설정 변경 후 적용 방법 한 줄 추가: `docker compose up -d` (재빌드 불필요)

**섹션 5 — 비밀번호 해시 생성**
goshs는 평문 비밀번호 대신 bcrypt 해시를 지원함을 설명. 생성 명령:
```bash
docker exec goshs goshs -H
```
출력된 해시를 `.env`의 `GOSHS_AUTH_PASSWORD`에 넣으면 됨을 명시.
컨테이너가 실행 중이어야 한다는 전제 조건 표기.

**섹션 6 — 디렉토리 구조**
```
goshs-docker/
├── Dockerfile          # goshs 바이너리 다운로드 및 이미지 빌드
├── entrypoint.sh       # .env 환경 변수 → goshs CLI 플래그 변환
├── docker-compose.yml  # 서비스 정의
├── .env.example        # 설정 템플릿 (이 파일을 .env로 복사)
├── .env                # 실제 설정 파일 (git 추적 제외)
└── shared/             # 기본 공유 디렉토리 (GOSHS_SHARE_DIR 기본값)
```

**작성 규칙:**
- 전체 문서를 한국어로 작성한다
- 커맨드/파일명/변수명은 코드 스팬(`` ` ``)으로 표기
- 섹션 헤더는 `##` 레벨 사용
- 과도한 강조(볼드) 남용 금지 — 핵심 주의사항에만 사용
  </action>
  <verify>
    <automated>grep -c "GOSHS_" /Users/gyuha/workspace/goshs-docker/README.md</automated>
  </verify>
  <done>
    - README.md가 6개 섹션(소개, 빠른 시작, 환경 변수 표, 사용 예시, 해시 생성, 디렉토리 구조)을 모두 포함한다
    - `.env.example`의 8개 변수가 모두 표에 나열된다
    - `docker compose up -d` 명령이 빠른 시작 섹션에 명시된다
    - `docker exec goshs goshs -H` 명령이 해시 생성 섹션에 명시된다
  </done>
</task>

</tasks>

<success_criteria>
- README.md를 처음 읽는 사람이 추가 검색 없이 컨테이너를 실행할 수 있다
- `.env.example`의 모든 변수(8개)가 표에 설명된다
- 보안 주의사항(인증 없는 외부 공개 금지)이 명시된다
- 한국어로 일관되게 작성된다
</success_criteria>
