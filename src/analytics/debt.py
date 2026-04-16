import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))

from db import get_session
from sqlalchemy import select, func, desc
from models import Clients, Accounts, Credits, CreditStatus


def debt(session):
    """Топ-3 клиентов с самой большой задолженностью."""
    active_credits = (
        select(CreditStatus.id)
        .where(CreditStatus.id.in_([1, 3]))
        .scalar_subquery()
    )

    stmt = (
        select(
            Clients.id.label("client_id"),
            (Clients.last_name + " " + Clients.first_name).label("full_name"),
            func.count(Credits.id).label("count_credits"),
            func.sum(Credits.remaining_amount).label("remaining")
        )
        .join(Accounts, Accounts.client_id == Clients.id)
        .join(Credits, Accounts.id == Credits.repayment_account_id)
        .where(Credits.status_id.in_(active_credits))
        .group_by(Clients.id, Clients.last_name, Clients.first_name)
        .order_by(desc("remaining"))
        .limit(3)
    )

    return session.execute(stmt).mappings().all()

def main():
    with get_session() as session:
        result = debt(session)

        for row in result:
            print(
                f"full name: {row['full_name']}, "
                f"count credits={row['count_credits']}, "
                f"remaining={row['remaining']}"
            )


if __name__ == "__main__":
    main()
