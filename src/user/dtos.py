from pydantic import BaseModel

class User_Schema(BaseModel):
    name: str
    username: str
    email: str
    phone: int
    password: str
    
