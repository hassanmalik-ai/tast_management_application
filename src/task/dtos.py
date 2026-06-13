from pydantic import BaseModel, ConfigDict
from typing import Optional


class TaskSchema(BaseModel):
    id: Optional[int] = None
    title: str
    description: str
    status: bool = False
    user_id: Optional[int] = None

    model_config = ConfigDict(from_attributes=True)

class UpdateTaskSchema(BaseModel):
    title: str
    description: str
    status: bool 
    

