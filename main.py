from fastapi import FastAPI
from src.utils.db import engine, Base


app = FastAPI()

Base.metadata.create_all(bind=engine)


@app.get('/health')
def read_root():
    return {"Hello": "World"}



if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='[IP_ADDRESS]', port=8000)