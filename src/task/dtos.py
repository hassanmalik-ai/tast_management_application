from pydantic import BaseModel


class TaskSchema(BaseModel):
    title: str
    description: str
    status: bool = False

class UpdateTaskSchema(BaseModel):
    title: str
    description: str
    status: bool 
