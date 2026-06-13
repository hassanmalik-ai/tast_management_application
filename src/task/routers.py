from fastapi import APIRouter, Depends,HTTPException,status,Response
from sqlalchemy.orm import Session
from src.task.dtos import TaskSchema,UpdateTaskSchema
from src.task.model import Task
from src.utils.db import get_db
from typing import List
from src.task import controller
from src.utils.helper import token_authetication
from src.user.model import User

router = APIRouter(prefix="/tasks")


@router.post('/create',response_model=TaskSchema,status_code=status.HTTP_201_CREATED)
def create_task(body:TaskSchema,db:Session = Depends(get_db),user=Depends(token_authetication)):
    return controller.create_task(body,db,user.id,user)

@router.get('/get-all',response_model=List[TaskSchema],status_code=status.HTTP_200_OK)
def get_all_task(db:Session = Depends(get_db),user=Depends(token_authetication)):
    return controller.get_all_task(db,user.id,user)

@router.get('/get-one/{id}',response_model=TaskSchema,status_code=status.HTTP_200_OK)
def get_one_task(id:int,db:Session = Depends(get_db),user=Depends(token_authetication)):
    return controller.get_one_task(id,db,user.id,user)

@router.put('/update/{id}',response_model=TaskSchema,status_code=status.HTTP_200_OK)
def update_task(id:int,body:TaskSchema,db:Session = Depends(get_db),user=Depends(token_authetication)):
    return controller.update_task(id,body,db,user.id,user)

@router.delete('/delete/{id}',response_model=TaskSchema,status_code=status.HTTP_200_OK)
def delete_task(id:int,db:Session = Depends(get_db),user=Depends(token_authetication)):
    return controller.delete_task(id,db,user.id,user)

