from fastapi import APIRouter, Depends
from src.task import controller
from src.task.dtos import TaskSchema
from src.utils.db import get_db


router = APIRouter(prefix="/tasks")


@router.post('/create')
def create_task(body:TaskSchema,db = Depends(get_db)):
    return controller.create_task(body,db)

@router.get('/get-all')
def get_all_task(db = Depends(get_db)):
    return controller.get_all_task(db)


