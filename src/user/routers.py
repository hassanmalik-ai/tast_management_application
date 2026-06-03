from fastapi import APIRouter, Depends,HTTPException,status,Response
from sqlalchemy.orm import Session
from src.user.dtos import User_Schema,User_Response_Schema
from src.user.controller import register
from src.utils.db import get_db
from typing import List
from sqlalchemy.orm import Session


user_router = APIRouter(prefix="/users")


@user_router.post("/register",status_code=status.HTTP_201_CREATED,response_model=User_Response_Schema)
def Register_user(body:User_Schema,db:Session=Depends(get_db)):
    return register(body,db)