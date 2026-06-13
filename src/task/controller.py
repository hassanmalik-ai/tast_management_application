from fastapi import Depends,HTTPException
from sqlalchemy.orm import Session
from src.task.dtos import TaskSchema, UpdateTaskSchema
from src.task.model import Task
from src.utils.db import get_db
from src.user.model import User


def create_task(body: TaskSchema, db: Session, user_id: int):
    data = body.model_dump()
    task = Task(
        title=data["title"],
        description=data["description"],
        status=data["status"],
        user_id=user_id
    )
    db.add(task)
    db.commit()
    db.refresh(task)
    return task


def get_all_task(db: Session, user_id: int):
    tasks = db.query(Task).filter(Task.user_id == user_id).all()
    return tasks

def get_one_task(id: int, db: Session, user_id: int):
    task = db.query(Task).filter(Task.id == id, Task.user_id == user_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task

def update_task(id: int, body: UpdateTaskSchema, db: Session, user_id: int):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    if task.user_id != user_id:
        raise HTTPException(status_code=401, detail="You are not allowed to update this")
    
    task.title = body.title
    task.description = body.description
    task.status = body.status
    db.commit()
    db.refresh(task)
    return task

def delete_task(id: int, db: Session, user_id: int):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    if task.user_id != user_id:
        raise HTTPException(status_code=401, detail="You are not allowed to delete this")
    db.delete(task)
    db.commit()
    return task