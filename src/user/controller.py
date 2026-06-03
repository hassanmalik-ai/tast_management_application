from fastapi import Depends, status,HTTPException
from sqlalchemy.orm import Session
from src.user.dtos import User_Schema
from src.user.model import User
from src.utils.db import get_db
from pwdlib import PasswordHash


hash_context = PasswordHash.recommended()
def get_password_hash(password):
    return hash_context.hash(password)


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
