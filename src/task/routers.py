from fastapi import APIRouter
from src.task import controller
from src.task.dtos import TaskSchema
from src.utils.db import get_session


router = APIRouter(prefix="/tasks")


@router.post('/create')
def create_task(body:TaskSchema):
    return controller.create_task(body.title , body.description , body.status)