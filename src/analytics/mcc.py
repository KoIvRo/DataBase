import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))

from sqlalchemy import select, func, desc
from db import get_session
from models import MccCodes, Transactions, TransactionParties, TransactionStatus, Directions

def get_top_mcc(session):
    """Взять топ 5 mcc по сумме транзакции."""

    comleted_status = select(TransactionStatus.id).where(TransactionStatus.name == "completed")
    outcoming_directions = select(Directions.id).where(Directions.name == "out")

    stmt = (
        select(
            MccCodes.id.label("mcc_id"),
            MccCodes.description.label("description"),
            func.count(Transactions.id).label("transaction_count"),
            func.sum(Transactions.amount).label("total_amount"),
            func.count(func.distinct(TransactionParties.account_id)).label("unique_accounts")
        )
        .join(Transactions, Transactions.mcc_id == MccCodes.id)
        .join(TransactionParties, TransactionParties.transaction_id == Transactions.id)
        .where(TransactionParties.direction_id.in_(outcoming_directions))
        .where(Transactions.status_id.in_(comleted_status))
        .group_by(MccCodes.id)
        .order_by(desc("total_amount"))
        .limit(5)
    )

    return session.execute(stmt).mappings().all()

def main() -> None:
    with get_session() as session:
        result = get_top_mcc(session)

        for row in result:
            print(
                f"mcc: {row['mcc_id']}: "
                f"description= {row['description']}"
                f"count={row['transaction_count']}, "
                f"amout={row['total_amount']}, "
                f"count_accounts={row['unique_accounts']}"
            )

if __name__ == "__main__":
    main()
