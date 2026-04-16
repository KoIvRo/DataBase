import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))

from db import get_session
from sqlalchemy import select, func, case, distinct
from models import Clients, Accounts, Credits, CreditStatus


def who_is_more_overdue_loans(session):
    """Кто больше просрачивает кредиты: мужчины или женщины."""

    overdue_credit_status = select(CreditStatus.id).where(CreditStatus.name == "overdue")

    gender_case = case(
        (Clients.is_male.is_(True), "Мужчина"),
        else_="Женщина"
    ).label("gender")

    stmt = (
        select(
            gender_case,
            func.count(distinct(Credits.id)).label("total_credits"),
            func.count(
                distinct(
                    case(
                        (Credits.status_id.in_(overdue_credit_status), Credits.id)
                    )
                )
            ).label("overdue_credits"),
            func.sum(
                case(
                    (Credits.status_id.in_(overdue_credit_status), Credits.remaining_amount),
                    else_=0
                )
            ).label("total_overdue_amount"),
            func.count(distinct(Clients.id)).label("clients_count")
        )
        .join(Accounts, Accounts.client_id == Clients.id)
        .join(Credits, Credits.repayment_account_id == Accounts.id)
        .group_by(gender_case)
    )

    return session.execute(stmt).mappings().all()


def main():
    with get_session() as session:
        result = who_is_more_overdue_loans(session)

        for row in result:
            print(
                f"{row['gender']}: "
                f"кредитов={row['total_credits']}, "
                f"просрочек={row['overdue_credits']}, "
                f"сумма={row['total_overdue_amount']}, "
                f"клиентов={row['clients_count']}"
            )


if __name__ == "__main__":
    main()
