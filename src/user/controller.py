from fastapi import Depends, status,HTTPException
from sqlalchemy.orm import Session
from src.user.dtos import User_Schema,Login_Schema
from src.user.model import User
from src.utils.db import get_db
from pwdlib import PasswordHash
import jwt
from src.utils.settings import settings
from datetime import datetime, timedelta


EXP_TIME = 30

hash_context = PasswordHash.recommended()
def get_password_hash(password):
    return hash_context.hash(password)


def verify_password(plain_password, hashed_password):
    return hash_context.verify(plain_password, hashed_password)




## Registration

def register(body:User_Schema,db:Session=Depends(get_db)):
    user_exists=db.query(User).filter(User.username==body.username).first()
    if user_exists:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="User already exists")
    
    email_exists=db.query(User).filter(User.email==body.email).first()
    if email_exists:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="Email already exists")
    
    phone_exists=db.query(User).filter(User.phone==body.phone).first()
    if phone_exists:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="Phone already exists")



    hashed_password=get_password_hash(body.password)
    user=User(
        name=body.name,
        username=body.username,
        email=body.email,
        phone=body.phone,
        hash_password=hashed_password,
    )

    db.add(user)
    db.commit()
    db.refresh(user)
    return user


## Login

def login(body:Login_Schema,db:Session=Depends(get_db)):
    user_exists=db.query(User).filter(User.username==body.username).first()
    if not user_exists:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="User not found")
    
    if not verify_password(body.password, user_exists.hash_password):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,detail="you enter wrong password")

    
    expire_time=datetime.utcnow() + timedelta(minutes=settings.EXP_TIME)
    token = jwt.encode({"user_id":user_exists.id, "exp":expire_time},settings.SECRET_KEY,algorithm=settings.ALGORITHM)
    return {"token":token}
