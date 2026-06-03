from fastapi import Depends, status
from sqlalchemy.orm import Session
from src.user.dtos import User_Schema
from src.user.model import User
from src.utils.db import get_db

def register(body:User_Schema,db:Session=Depends(get_db)):
    print(body)
    return {"message":"User registered successfully"}       