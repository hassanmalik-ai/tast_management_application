from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from src.utils.settings import settings


Base = declarative_base()
DB_CONNECTION=settings.DB_CONNECTION
engine = create_engine(DB_CONNECTION)
SessionLocal = sessionmaker(bind=engine)

def get_session():
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()
