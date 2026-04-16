import sys
from pathlib import Path
from datetime import date
import uuid

sys.path.append(str(Path(__file__).parent.parent))

from db import get_session
from sqlalchemy import select, func
from models import (
    Credits,
    CreditPaymentSchedules,
    Transactions,
    TransactionParties,
    LedgerEntries,
    CreditPayments,
    AccountBalances,
)


def get_credit_snapshot(session, credit_id: int):
    stmt = (
        select(
            Credits.id,
            Credits.remaining_amount,
            Credits.principal_amount,
        )
        .where(Credits.id == credit_id)
    )
    return session.execute(stmt).mappings().first()


def repay_credit(session, credit_id: int = 1):
    before = get_credit_snapshot(session, credit_id)
    print("BEFORE:", dict(before))

    payment = session.execute(
        select(
            CreditPaymentSchedules.id,
            CreditPaymentSchedules.total_amount,
            CreditPaymentSchedules.principal_amount,
        )
        .where(
            CreditPaymentSchedules.credit_id == credit_id,
            CreditPaymentSchedules.status_id == 1,
        )
        .order_by(CreditPaymentSchedules.payment_number)
        .limit(1)
    ).mappings().first()

    tx = Transactions(
        transaction_uuid=str(uuid.uuid4()),
        type_id=6,
        status_id=2,
        amount=payment["total_amount"],
        currency_id=1,
        mcc_id=5411,
        created_at=func.now(),
        completed_at=func.now(),
    )
    session.add(tx)
    session.flush()

    accounts = session.execute(
        select(
            Credits.repayment_account_id,
            Credits.loan_account_id,
        ).where(Credits.id == credit_id)
    ).mappings().first()

    session.add(
        TransactionParties(
            transaction_id=tx.id,
            account_id=accounts["repayment_account_id"],
            direction_id=2,
        )
    )

    session.add(
        TransactionParties(
            transaction_id=tx.id,
            account_id=accounts["loan_account_id"],
            direction_id=1,
        )
    )

    session.add(
        LedgerEntries(
            transaction_id=tx.id,
            account_id=accounts["repayment_account_id"],
            credit=payment["total_amount"],
            debit=0,
        )
    )

    session.add(
        LedgerEntries(
            transaction_id=tx.id,
            account_id=accounts["loan_account_id"],
            credit=0,
            debit=payment["total_amount"],
        )
    )

    session.add(
        CreditPayments(
            credit_id=credit_id,
            payment_date=date.today(),
            amount=payment["total_amount"],
            principal_paid=payment["principal_amount"],
            interest_paid=payment["total_amount"] - payment["principal_amount"],
            schedule_id=payment["id"],
            transaction_id=tx.id,
        )
    )

    with session.no_autoflush:

        session.query(CreditPaymentSchedules).filter(
            CreditPaymentSchedules.id == payment["id"]
        ).update(
            {
                CreditPaymentSchedules.status_id: 2,
                CreditPaymentSchedules.paid_date: date.today(),
                CreditPaymentSchedules.paid_amount: payment["total_amount"],
            }
        )

        session.query(Credits).filter(Credits.id == credit_id).update(
            {
                Credits.remaining_amount: Credits.remaining_amount
                - payment["principal_amount"]
            }
        )

        balance = session.execute(
            select(
                AccountBalances.available_balance,
                AccountBalances.balance,
            )
            .where(AccountBalances.account_id == accounts["repayment_account_id"])
            .order_by(AccountBalances.updated_at.desc())
            .limit(1)
        ).mappings().first()

        session.add(
            AccountBalances(
                account_id=accounts["repayment_account_id"],
                available_balance=balance["available_balance"] - payment["total_amount"],
                balance=balance["balance"] - payment["total_amount"],
                updated_at=func.now(),
            )
        )

    after = get_credit_snapshot(session, credit_id)
    print("AFTER:", dict(after))

    session.rollback()


def main():
    with get_session() as session:
        repay_credit(session, credit_id=1)


if __name__ == "__main__":
    main()
