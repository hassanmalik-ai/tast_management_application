from src.task.dtos import TaskSchema
from sqlalchemy.orm import Session
from src.task.model import Task
from fastapi import Depends
from src.utils.db import get_db
from fastapi import HTTPException


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

def get_one_task(id:int,db:Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"task": task}

def update_task(id:int,body:TaskSchema,db:Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    task.title = body.title
    task.description = body.description
    task.status = body.status
    db.commit()
    db.refresh(task)
    return {"message": "Task updated successfully",
    "task": task}

def delete_task(id:int,db:Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    db.delete(task)
    db.commit()
    return {"message": "Task deleted successfully"}