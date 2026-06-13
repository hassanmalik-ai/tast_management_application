from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from src.utils.db import Base

class Task(Base):
    __tablename__ = "tasks"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(String(255), nullable=True)
    status = Column(Boolean, default=False)
    user_id = Column(Integer, ForeignKey("users.id"), onupdate="CASCADE")

    user = relationship("User", back_populates="tasks")



