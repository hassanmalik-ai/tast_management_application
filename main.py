from fastapi import FastAPI
from src.utils.db import engine, Base
from src.task.model import Task
from src.task.routers import router



Base.metadata.create_all(bind=engine)

app = FastAPI()
app.include_router(task_router())

    

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='[IP_ADDRESS]', port=8000)