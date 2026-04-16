import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))

from db import get_session
from sqlalchemy import select, case
from models import (
    Clients,
    ClientVerifications,
    KycStatus,
    ClientDocuments,
    ClientEmployment,
    ClientAddresses,
)


def get_kyc_issues(session):
    """Проверка KYC проблем у клиентов"""

    full_name = (Clients.first_name + " " + Clients.last_name).label("name")

    problem_case = case(
        (ClientDocuments.id.is_(None), "Нет документов"),
        (ClientEmployment.id.is_(None), "Нет данных о доходах"),
        (ClientAddresses.id.is_(None), "Нет адреса"),
        else_="OK",
    ).label("problem")

    stmt = (
        select(
            Clients.id,
            full_name,
            KycStatus.name.label("kyc_status"),
            problem_case,
        )
        .join(ClientVerifications, ClientVerifications.client_id == Clients.id)
        .join(KycStatus, KycStatus.id == ClientVerifications.kyc_status_id)
        .outerjoin(ClientDocuments, ClientDocuments.client_id == Clients.id)
        .outerjoin(ClientEmployment, ClientEmployment.client_id == Clients.id)
        .outerjoin(ClientAddresses, ClientAddresses.client_id == Clients.id)
        .where(KycStatus.name.in_(["pending", "rejected", "edd"]))
        .group_by(
            Clients.id,
            Clients.first_name,
            Clients.last_name,
            KycStatus.name,
            ClientDocuments.id,
            ClientEmployment.id,
            ClientAddresses.id,
        )
    )

    return session.execute(stmt).mappings().all()


def main():
    with get_session() as session:
        result = get_kyc_issues(session)

        for row in result:
            print(
                f"{row['id']} | {row['name']} | "
                f"{row['kyc_status']} | {row['problem']}"
            )


if __name__ == "__main__":
    main()
