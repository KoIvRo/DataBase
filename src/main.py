from db import get_session
from sqlalchemy import text


if __name__ == "__main__":
    with get_session() as session:
        result = session.execute(text("SELECT * FROM clients;"))
        for row in result:
            print(f"ID: {row.id}, Name: {row.first_name}")
