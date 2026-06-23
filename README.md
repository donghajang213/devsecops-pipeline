# 🛡️ Secure DevSecOps CI/CD Pipeline

## 📌 프로젝트 소개
본 프로젝트는 애플리케이션 개발부터 인프라 배포까지 모든 단계에 보안(Security)을 내재화하는 **DevSecOps 파이프라인 구축기**입니다. 
공공기관 및 엔터프라이즈 환경에서 요구하는 엄격한 보안 표준과 **최소 권한의 원칙(PoLP)**을 준수하도록 설계되었으며, 코드 Push 시 자동으로 취약점을 스캔하고 차단하는 CI(Continuous Integration) 환경을 포함하고 있습니다.

## 🏗 기술 스택
- **Application:** Python 3.10, FastAPI, Uvicorn
- **Containerization:** Docker
- **CI/CD Pipeline:** GitHub Actions
- **Security Tools:** Bandit (SAST), Trivy (Container/Library Scanning)

---

## ✅ 완료된 작업 및 핵심 보안 대처 (What I Did & Solved)

### 1. 최소 권한 원칙(PoLP)이 적용된 안전한 Dockerfile 구축
- **작업 내용:** 컨테이너가 기본적으로 갖는 최고 관리자(Root) 권한을 박탈하고, 제한된 권한을 가진 일반 사용자(`appuser`)를 생성하여 애플리케이션을 구동하도록 격리 환경 설계.
- **보안 효과:** 웹 서버가 해킹당하더라도 해커가 호스트 시스템이나 다른 컨테이너로 권한을 탈취(Privilege Escalation)하는 것을 원천 차단.

### 2. 정적 코드 분석 (SAST) 파이프라인 연동
- **작업 내용:** GitHub Actions를 활용하여 코드 병합 전 `Bandit` 스캐너가 자동으로 실행되도록 구성.
- **보안 효과:** 하드코딩된 비밀번호, 취약한 암호화 알고리즘, 위험한 함수(`eval` 등) 사용 등 소스코드 레벨의 취약점 사전 차단.

### 3. 컨테이너 이미지 스캐닝 및 보안 게이트(Security Gate) 구축
- **작업 내용:** `Trivy` 액션을 파이프라인에 통합하여 도커 빌드 후 이미지 내의 패키지 취약점(CVE) 검사.
- **트러블슈팅 및 대처:** - **[의도적 취약점 테스트]** `urllib3==1.26.4` 구버전을 주입하여 파이프라인이 정상적으로 위험을 감지하고 강제 중단(`Exit Code 1`)하는 방어 메커니즘 검증 성공.
  - **[의존성 충돌 문제]** 테스트 과정에서 너무 오래된 패키지(`requests==2.20.0`) 삽입 시 `pip` 의존성 해결 실패 에러가 발생하여, 최신 FastAPI와 호환되면서 취약점만 존재하는 `urllib3`로 교체하여 해결.
  - **[OS 취약점 노이즈 필터링]** 데비안 베이스 이미지 자체의 제로데이 취약점 때문에 파이프라인이 지속적으로 블록되는 현상 발생. 현재 프로젝트의 포커스에 맞게 Trivy의 스캔 범위를 `vuln-type: 'library'`로 조정하여 애플리케이션 라이브러리 검증에 집중하도록 최적화.

### 4. Git 설정 및 인코딩 트러블슈팅
- **문제:** 윈도우 환경에서 터미널로 `.gitignore`를 생성 시 UTF-16으로 저장되어 Git이 이를 인식하지 못하고 가상환경(`.venv/`)과 캐시 파일(`__pycache__/`)을 계속 추적하는 문제 발생.
- **해결:** 해당 파일을 삭제 후 IDE(VS Code)에서 UTF-8 인코딩으로 재설정하여 명시함으로써 형상 관리의 멱등성 확보.

---

## 🚀 앞으로의 로드맵 (To-Do)

현재 DevSecOps로 다져진 안전하고 튼튼한 인프라 뼈대 위에서, 본격적인 데이터 처리와 인공지능 모델링을 결합할 예정입니다.

- [ ] **Phase 2. Data Engineering (Real-time Streaming)**
  - Python 기반 실시간 데이터 생산자(Producer) 스크립트 작성.
  - Apache Kafka 또는 클라우드 Pub/Sub을 연동하여 쏟아지는 스트리밍 데이터 수집 및 처리 아키텍처 구축.
  
- [ ] **Phase 3. MLOps (Machine Learning Operations)**
  - 스트리밍 파이프라인으로 들어온 데이터를 기반으로 AI 모델 자동 재학습(Retraining) 및 배포 사이클 구축.
  - 모델의 성능 변동성(Data Drift) 모니터링 시스템 추가.