from fastapi import FastAPI
from src.utils.db import engine, Base
from src.task.model import Task
from src.task.routers import router
from src.user.routers import user_router
from src.utils.db import get_db




Base.metadata.create_all(bind=engine)

app = FastAPI()
app.include_router(router)
app.include_router(user_router)


if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='127.0.0.1', port=8000)