# 1. 베이스 이미지
FROM python:3.10-slim

# 2. 작업 디렉터리
WORKDIR /app

# 3. 의존성 파일 복사 (캐싱 최적화)
COPY requirements.txt .

# 4. 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# 5. 보안: non-root 사용자 생성
RUN adduser --disabled-password --no-create-home appuser
USER appuser

# 6. 애플리케이션 코드 복사 (코드만 포함, 모델은 S3에서 다운로드)
COPY app/ ./app/
# 주의: COPY models/ ./models/ 는 사용하지 않음!
# 로컬 개발: models/ 폴더에서 로드, 운영: S3에서 동적 다운로드
# model.py가 MODEL_S3_BUCKET 환경변수 유무에 따라 자동 분기

# 7. 포트 문서화
EXPOSE 8000

# 8. 실행 명령
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]