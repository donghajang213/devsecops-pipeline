from fastapi import FastAPI

# 테스트용 임시 키 (나중에 지울 것)
AWS_ACCESS_KEY_ID = "AKIA7X3J9L2P5Q8W4E1R"

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "Hello DevSecOps!"}
