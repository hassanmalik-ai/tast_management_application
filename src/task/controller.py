from src.task.dtos import TaskSchema

def create_task(body:TaskSchema):
    print(body)
    return {"message": "Task created successfully"}
    

    