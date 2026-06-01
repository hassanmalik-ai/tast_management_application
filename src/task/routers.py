from fastapi import APIRouter, Depends,HTTPException,status,Response
from sqlalchemy.orm import Session
from src.task.dtos import TaskSchema,UpdateTaskSchema
from src.task.model import Task
from src.utils.db import get_db
from typing import List
from sqlalchemy.orm import Session


router = APIRouter(prefix="/tasks")


@router.post('/create',response_model=list[TaskSchema],status_code=status.HTTP_201_CREATED)
def create_task(body:TaskSchema,db = Depends(get_db)):
    return controller.create_task(body,db)

@router.get('/get-all',response_model=List[TaskSchema],status_code=status.HTTP_200_OK)
def get_all_task(db = Depends(get_db)):
    return controller.get_all_task(db)


@router.get('/get-one/{id}',response_model=TaskSchema,status_code=status.HTTP_200_OK)
def get_one_task(id:int,db = Depends(get_db)):
    return controller.get_one_task(id,db)

@router.put('/update/{id}',response_model=TaskSchema,status_code=status.HTTP_200_OK)
def update_task(id:int,body:TaskSchema,db = Depends(get_db)):
    return controller.update_task(id,body,db)

@router.delete('/delete/{id}',response_model=TaskSchema,status_code=status.HTTP_200_OK)
def delete_task(id:int,db = Depends(get_db)):
    return controller.delete_task(id,db)

