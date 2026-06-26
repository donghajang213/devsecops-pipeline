# 1. 베이스 이미지
FROM python:3.10-slim

# 2. 작업 디렉토리
WORKDIR /app

# 3. 의존성 파일 복사
COPY requirements.txt .

# 4. 패키지 설치 및 유저 생성
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \ 
    pip install --no-cache-dir -r requirements.txt && \
    useradd -m appuser && \
    chown -R appuser /app

# 5. 소스 코드 복사
COPY main.py .

# 6. 사용자 전환
USER appuser

# ==========================================
# [추가됨] 7. 헬스체크 (Checkov 보안 규정 준수)
# 30초마다 서버가 정상 응답하는지 찔러보고, 3번 실패하면 비상벨을 울립니다.
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/')" || exit 1
# ==========================================

# 8. 실행 명령어
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]