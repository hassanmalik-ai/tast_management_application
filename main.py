from fastapi import FastAPI
from src.utils.db import engine, Base
from src.task.model import Task
from src.task.routers import router
from src.utils.db import get_session
from src.task.dtos import TaskSchema
from src.task.controller import create_task



Base.metadata.create_all(bind=engine)

app = FastAPI()
app.include_router(router)

@app.get("/")
def home():
    return {"message": "Welcome to the Task Management Application"}

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='127.0.0.1', port=8000)