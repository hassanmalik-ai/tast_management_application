from src.task.dtos import TaskSchema
from sqlalchemy.orm import Session
from src.task.model import Task
from fastapi import Depends
from src.utils.db import get_db


def create_task(body:TaskSchema, db: Session = Depends(get_db)):
    data = body.model_dump()
    task = Task(
        title=data["title"],
        description=data["description"],
        status=data["status"]
    )
    db.add(task)
    db.commit()
    db.refresh(task)
    return {"message": "Task created successfully",
    "task": task}


def get_all_task(db: Session = Depends(get_db)):
    tasks = db.query(Task).all()
    return {"tasks": tasks}

