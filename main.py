from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.utils.db import engine, Base
from src.task.model import Task
from src.task.routers import router
from src.user.routers import user_router
from src.utils.db import get_db


Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Task Management API",
    description="Backend API for the Task Management Application",
    version="1.0.0",
)

# CORS middleware — allow Flutter frontend to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, restrict to specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router)
app.include_router(user_router)


@app.get("/", tags=["Health"])
def health_check():
    return {"status": "ok", "message": "Task Management API is running"}


if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='127.0.0.1', port=8000)