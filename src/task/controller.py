from fastapi import Depends,HTTPException
from sqlalchemy.orm import Session
from src.task.dtos import TaskSchema
from src.task.model import Task
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
    return create_task(body,db)


def get_all_task(db: Session = Depends(get_db)):
    tasks = db.query(Task).all()
    return get_all_task(db)

def get_one_task(id:int,db:Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return get_one_task(id,db)

def update_task(id:int,body:TaskSchema,db:Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    task.title = body.title
    task.description = body.description
    task.status = body.status
    db.commit()
    db.refresh(task)
    return update_task(id,body,db)

def delete_task(id:int,db:Session = Depends(get_db)):
    task = db.query(Task).filter(Task.id == id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    db.delete(task)
    db.commit()
    return delete_task(id,db)