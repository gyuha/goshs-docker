---
quick_id: 260517-ffo
description: goshs Docker 컨테이너 볼륨 마운트 설정 및 검증
created: 2026-05-17
autonomous: true
files_modified:
  - .env
  - docker-compose.yml
---

<objective>
goshs 컨테이너가 호스트의 공유 디렉토리를 올바르게 마운트하고 서빙하도록 설정을 확인하고 동작을 검증한다.

현재 상태:
- docker-compose.yml: `${GOSHS_SHARE_DIR:-./shared}:/shared` 마운트 이미 선언됨
- .env: `GOSHS_SHARE_DIR=./shared` 설정됨
- `./shared` 디렉토리: 존재하지만 비어있음
- entrypoint.sh: goshs가 `-d /shared`로 실행됨

목표: 호스트 디렉토리 → 컨테이너 `/shared` → goshs serving 경로가 end-to-end로 동작함을 확인한다.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: 마운트 경로 설정 및 테스트 파일 배치</name>
  <files>.env, ./shared/</files>
  <action>
    1. GOSHS_SHARE_DIR이 실제로 사용할 경로를 가리키는지 확인한다.
       - 현재 값: `./shared` (프로젝트 루트 기준 상대경로)
       - 절대경로로 지정하려면 .env에서 `GOSHS_SHARE_DIR=/Users/gyuha/workspace/goshs-docker/shared` 로 변경한다.
       - 상대경로(`./shared`)로 유지해도 `docker compose up` 실행 위치가 프로젝트 루트이면 동작한다.
    2. 마운트 동작 확인용 테스트 파일을 호스트 shared 디렉토리에 생성한다:
       ```
       echo "mount test" > ./shared/mount-test.txt
       ```
    3. GOSHS_UPLOAD_ENABLED=true 로 변경하여 업로드 기능도 함께 활성화할지 결정한다 (선택사항).
  </action>
  <verify>ls -la ./shared/ 로 mount-test.txt가 보임을 확인</verify>
  <done>./shared/ 디렉토리에 파일이 존재하고 GOSHS_SHARE_DIR 경로가 의도한 디렉토리를 가리킴</done>
</task>

<task type="auto">
  <name>Task 2: 컨테이너 기동 및 볼륨 마운트 검증</name>
  <files>docker-compose.yml</files>
  <action>
    1. 컨테이너를 재시작한다:
       ```
       docker compose down && docker compose up -d
       ```
    2. 컨테이너 내부에서 /shared 마운트를 확인한다:
       ```
       docker exec goshs ls -la /shared
       ```
       mount-test.txt가 보이면 마운트 성공.
    3. goshs 웹 UI에서 파일이 노출되는지 확인한다:
       ```
       curl -s http://localhost:8000 | grep -i "mount-test"
       ```
    4. 컨테이너 로그로 goshs 실행 인수를 확인한다:
       ```
       docker logs goshs 2>&1 | head -5
       ```
       `Starting: goshs -d /shared -p 8000` 형태의 라인이 있어야 한다.
  </action>
  <verify>
    docker exec goshs ls /shared 출력에 mount-test.txt 포함
    curl http://localhost:8000 응답에 파일 목록 포함
  </verify>
  <done>
    - 컨테이너가 정상 기동됨
    - 호스트 ./shared 의 파일이 컨테이너 /shared 에서 보임
    - goshs 웹 UI에서 파일 목록 접근 가능
  </done>
</task>

</tasks>

<success_criteria>
- docker exec goshs ls /shared 에 호스트에서 넣은 파일이 표시됨
- http://localhost:8000 에서 파일 목록이 렌더링됨
- docker logs goshs 에서 "Starting: goshs -d /shared" 확인됨
- 호스트에서 ./shared 에 파일을 추가하면 컨테이너 재시작 없이 웹 UI에 즉시 반영됨
</success_criteria>
