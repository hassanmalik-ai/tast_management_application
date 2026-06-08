from pydantic import BaseModel

class User_Schema(BaseModel):
    name: str
    username: str
    email: str
    phone: str
    password: str
    
class User_Response_Schema(BaseModel):
    name: str
    username: str
    email: str
    phone: str
    

class Login_Schema(BaseModel):
    username: str
    password: str

    
