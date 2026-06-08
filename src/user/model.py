from sqlalchemy import Column, Integer, String, Boolean, DateTime
from src.utils.db import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    username = Column(String(255), nullable=False)
    email = Column(String(255), nullable=False)
    phone = Column(String(255), nullable=False)
    hash_password = Column(String(255), nullable=False)
    