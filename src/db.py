from models import Base
from sqlalchemy import create_engine
from contextlib import contextmanager
from sqlalchemy.orm import sessionmaker, Session
from typing import Generator

DATABASE_URL = "sqlite:///./identifier.sqlite"

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(bind=engine)

Base.metadata.create_all(engine)

@contextmanager
def get_session() -> Generator[Session, None, None]:
    """Получение соединения с бд."""
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()
