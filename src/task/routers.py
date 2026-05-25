from fastapi import APIRouter
from src.task import controller

router = APIRouter(prefix="/tasks")


@router.post('/create')
def create_task():
    return controller.create_task()