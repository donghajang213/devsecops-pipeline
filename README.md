# 🛡️ Enterprise-Grade DevSecOps CI/CD Pipeline

## 📌 프로젝트 소개
본 프로젝트는 글로벌 IT 기업 및 금융권 수준의 엄격한 보안 표준을 준수하는 **5중 방어 DevSecOps 파이프라인 구축기**입니다. 
애플리케이션 코드, 인프라 설정(IaC), 외부 라이브러리, 그리고 기밀 정보 유출까지 배포 전 주기에 걸쳐 발생할 수 있는 모든 보안 위협을 GitHub Actions 기반의 자동화된 보안 게이트(Security Gate)를 통해 원천 차단합니다.

## 🏗 핵심 기술 및 1티어 보안 스택 (The Big 5)
- **Application:** Python 3.10, FastAPI, Uvicorn
- **Containerization:** Docker
- **CI/CD Automation:** GitHub Actions
- **Security Tools (Tier 1):**
  1. `GitLeaks` (Secret Scanning)
  2. `Semgrep` (Advanced SAST)
  3. `Checkov` (IaC Scanning)
  4. `Trivy` (SCA & Container Scanning)
  5. `OWASP ZAP` (DAST)

---

## ✅ 완료된 작업 (Phase 1.1 - Foundation & SCA)

### 1. 최소 권한 원칙(PoLP) 기반 Dockerfile 설계
- 최고 관리자(Root) 권한을 박탈하고 `appuser` 일반 계정으로 격리 구동하여 권한 상승 공격(Privilege Escalation) 차단.

### 2. 패키지 및 컨테이너 취약점 스캐닝 (Trivy)
- **트러블슈팅 1 (의존성 충돌):** 오래된 패키지(`requests==2.20.0`) 주입 시 설치 단계에서 파이프라인이 붕괴되는 현상을 방지하기 위해, 의존성 충돌이 없는 `urllib3==1.26.4`로 교체하여 스캐너 정상 작동 검증.
- **트러블슈팅 2 (OS 취약점 노이즈):** 데비안 베이스 이미지 자체의 제로데이 취약점 알람으로 인한 배포 차단(Alert Fatigue) 현상 발생.
- **해결 방안:** 1. Dockerfile 내 기본 도구(`pip`, `setuptools`, `wheel`)를 최신 버전으로 소독(`--upgrade`)
  2. 팀 내 현실적인 보안 임계치 합의를 통해 `severity: 'CRITICAL'`로 차단 기준 조정 및 `vuln-type: 'library'`로 스캔 범위 최적화.

---

## 🚧 현재 진행 중인 작업 (Phase 1.2 - The 5-Layer Defense Deep Dive)

현재 글로벌 표준 1티어 툴들을 도입하여 다중 방어선을 구축하고 있습니다.

- [ ] **Secret Scanning (`GitLeaks`):** 하드코딩된 AWS Key, DB 비밀번호 등 기밀 유출 사전 차단.
- [ ] **IaC Scanning (`Checkov`):** Dockerfile 등 인프라 설정 파일의 보안 규정 준수 여부 검사.
- [ ] **Advanced SAST (`Semgrep`):** 기존 `Bandit`을 대체하여, 실리콘밸리 표준 정적 분석 엔진으로 코드 논리적 취약점 검사.
- [ ] **DAST (`OWASP ZAP`):** 배포된 컨테이너를 대상으로 실제 자동화된 웹 모의 해킹(SQLi, XSS 등) 수행 및 방어력 검증.

---

## 🚀 향후 로드맵 (Phase 2 & 3)

보안 인프라 구축이 완료된 후, 본격적인 데이터 파이프라인 및 AI 사이클을 연동합니다.

- **Phase 2. Data Engineering (Real-time Streaming):** 아파치 카프카(Kafka) 기반 실시간 1초 단위 주식/코인 데이터 스트리밍 파이프라인 구축.
- **Phase 3. MLOps (Machine Learning Operations):** 스트리밍 데이터를 바탕으로 한 AI 모델 자동 재학습(Retraining) 및 무중단 배포 사이클 완성.