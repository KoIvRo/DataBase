from models import Base
from sqlalchemy import create_engine
from contextlib import contextmanager
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "sqlite:///./identifier.sqlite"

engine = create_engine(DATABASE_URL)

Base.metadata.create_all(engine)

SessionLocal = sessionmaker(bind=engine)

@contextmanager
def get_session():
    """Получение соединения с бд."""
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()
