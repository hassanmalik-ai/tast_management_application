from fastapi import APIRouter, Depends,HTTPException,status,Response,Request
from sqlalchemy.orm import Session
from src.user.dtos import User_Schema,User_Response_Schema,Login_Schema
from src.user.controller import register,login,token_authetication
from src.utils.db import get_db
from typing import List
from sqlalchemy.orm import Session



user_router = APIRouter(prefix="/users")


@user_router.post("/register",status_code=status.HTTP_201_CREATED,response_model=User_Response_Schema)
def Register_user(body:User_Schema,db:Session=Depends(get_db)):
    return register(body,db)


@user_router.post("/login",status_code=status.HTTP_200_OK)
def Login_user(body:Login_Schema,db:Session=Depends(get_db)):
    return login(body,db)

@user_router.get("/token-auth",status_code=status.HTTP_200_OK,response_model=User_Response_Schema)
def Token_authetication(req:Request,db:Session=Depends(get_db)):
    return token_authetication(req,db)

