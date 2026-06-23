# 1. 베이스 이미지: 가볍고 보안 취약점이 적은 slim 버전을 사용합니다.
FROM python:3.10-slim

# 2. 작업 디렉토리: 컨테이너 내부에서 코드가 위치할 기본 폴더를 /app 으로 설정합니다.
WORKDIR /app

# 3. 의존성 파일 복사: 패키지 목록 파일을 먼저 복사합니다.
COPY requirements.txt .

# 4. 패키지 설치 및 유저 생성 (가장 중요!)
# && 연산자를 사용해 세 가지 리눅스 명령어를 한 번에 실행합니다.
# ① pip 패키지 설치
# ② useradd 명령어로 홈 디렉토리(-m)를 가진 'appuser'라는 일반 계정 생성
# ③ chown 명령어로 /app 폴더의 소유권을 root에서 appuser로 변경 (권한 부여)
RUN pip install --no-cache-dir -r requirements.txt && \
    useradd -m appuser && \
    chown -R appuser /app

# 5. 소스 코드 복사: 메인 로직을 가져옵니다.
COPY main.py .

# 6. 사용자 전환 (보안의 핵심!): 
# 이 줄을 기점으로, 아래 명령어들은 최고 관리자(Root)가 아닌 'appuser' 권한으로만 실행됩니다.
USER appuser

# 7. 실행 명령어: uvicorn으로 FastAPI 서버를 구동합니다.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]