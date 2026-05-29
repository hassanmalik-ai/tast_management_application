from src.task.dtos import TaskSchema

def create_task(body:TaskSchema):
    print(body.model_dump())
    return {"message": "Task created successfully"}
    

    