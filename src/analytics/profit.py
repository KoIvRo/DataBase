import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))

from db import get_session
from sqlalchemy import select, func, desc
from models import Clients, Accounts, Credits, CreditPaymentSchedules, Deposits, DepositPlan


def profit(session):
    """Кто из клиентов самый прибыльный для банка."""

    client_name = (Clients.first_name + " " + Clients.last_name).label("client_name")

    cc = (
        select(
            Clients.id.label("client_id"),
            client_name,
            func.sum(CreditPaymentSchedules.interest_amount).label("total_interest_paid")
        )
        .join(Accounts, Accounts.client_id == Clients.id)
        .join(Credits, Credits.repayment_account_id == Accounts.id)
        .join(CreditPaymentSchedules, CreditPaymentSchedules.credit_id == Credits.id)
        .where(CreditPaymentSchedules.status_id == 2)
        .group_by(Clients.id, client_name)
        .cte("cc")
    )

    cd = (
        select(
            Clients.id.label("client_id"),
            client_name,
            func.sum(
                Deposits.amount * DepositPlan.interest_rate / 100
            ).label("total_interest_earned")
        )
        .join(Accounts, Accounts.client_id == Clients.id)
        .join(Deposits, Deposits.account_id == Accounts.id)
        .join(DepositPlan, DepositPlan.id == Deposits.plan_id)
        .where(Deposits.status_id == 1)
        .group_by(Clients.id, client_name)
        .cte("cd")
    )

    stmt = (
        select(
            cc.c.client_name,
            func.coalesce(cc.c.total_interest_paid, 0).label("interest_paid_to_bank"),
            func.coalesce(cd.c.total_interest_earned, 0).label("interest_earned_by_client"),
            (
                func.coalesce(cc.c.total_interest_paid, 0)
                - func.coalesce(cd.c.total_interest_earned, 0)
            ).label("net_profit_for_bank"),
        )
        .join(cd, cd.c.client_id == cc.c.client_id)
        .order_by(desc("net_profit_for_bank"))
    )

    return session.execute(stmt).mappings().all()

def main() -> None:
    with get_session() as session:
        result = profit(session)

        for row in result:
            print(
                f"{row['client_name']}: "
                f"paid={row['interest_paid_to_bank']}, "
                f"earned={row['interest_earned_by_client']}, "
                f"net={row['net_profit_for_bank']}"
            )



if __name__ == "__main__":
    main()
