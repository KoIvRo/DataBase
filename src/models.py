from typing import Optional
import datetime
import decimal

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    DECIMAL,
    Date,
    ForeignKey,
    Integer,
    String,
    TIMESTAMP,
    text,
)
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    pass


class AccountStatus(Base):
    __tablename__ = "Account_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class AmlStatus(Base):
    __tablename__ = "Aml_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False, unique=True)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class AuthorizationStatus(Base):
    __tablename__ = "Authorization_Status"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[Optional[str]] = mapped_column(String(20))


class Banks(Base):
    __tablename__ = "Banks"
    __table_args__ = (CheckConstraint("id >= 100000000 AND id <= 999999999"),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(64), nullable=False)


class CardCategory(Base):
    __tablename__ = "Card_Category"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class CardStatus(Base):
    __tablename__ = "Card_Status"

    status_code: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class Clients(Base):
    __tablename__ = "Clients"

    first_name: Mapped[str] = mapped_column(String(64), nullable=False)
    last_name: Mapped[str] = mapped_column(String(64), nullable=False)
    password_hash: Mapped[str] = mapped_column(String(128), nullable=False)
    is_male: Mapped[bool] = mapped_column(Boolean, nullable=False)
    birth_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    created_at: Mapped[datetime.date] = mapped_column(
        Date, nullable=False, server_default=text("CURRENT_DATE")
    )
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    middle_name: Mapped[Optional[str]] = mapped_column(String(64))


class ContactType(Base):
    __tablename__ = "Contact_Type"

    name: Mapped[str] = mapped_column(String(64), nullable=False, unique=True)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class CreditPlans(Base):
    __tablename__ = "Credit_Plans"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    interest_rate: Mapped[decimal.Decimal] = mapped_column(
        DECIMAL(5, 2), nullable=False
    )
    min_term_months: Mapped[int] = mapped_column(Integer, nullable=False)
    max_term_months: Mapped[int] = mapped_column(Integer, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    min_amount: Mapped[Optional[int]] = mapped_column(Integer)
    max_amount: Mapped[Optional[int]] = mapped_column(Integer)
    late_payment_fee: Mapped[Optional[int]] = mapped_column(Integer)
    requires_collateral: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("FALSE")
    )
    requires_income_proof: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("TRUE")
    )
    requires_credit_history: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("TRUE")
    )
    is_active: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("TRUE")
    )


class CreditStatus(Base):
    __tablename__ = "Credit_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class Currency(Base):
    __tablename__ = "Currency"

    name: Mapped[str] = mapped_column(String(3), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class DepositPlan(Base):
    __tablename__ = "Deposit_Plan"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    count_month: Mapped[int] = mapped_column(Integer, nullable=False)
    interest_rate: Mapped[decimal.Decimal] = mapped_column(DECIMAL, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    minimal_amount: Mapped[Optional[int]] = mapped_column(Integer)
    early_withdrawal_rate: Mapped[Optional[decimal.Decimal]] = mapped_column(DECIMAL)
    early_withdrawal_fee: Mapped[Optional[decimal.Decimal]] = mapped_column(DECIMAL)


class DepositStatus(Base):
    __tablename__ = "Deposit_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class Directions(Base):
    __tablename__ = "Directions"

    name: Mapped[str] = mapped_column(String(16), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class DocumentType(Base):
    __tablename__ = "Document_Type"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class EmploymentStatus(Base):
    __tablename__ = "Employment_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class KycStatus(Base):
    __tablename__ = "Kyc_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False, unique=True)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class MccCodes(Base):
    __tablename__ = "Mcc_Codes"
    __table_args__ = (CheckConstraint("id >= 1000 AND id <= 9999"),)

    description: Mapped[str] = mapped_column(String(128), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class PaymentStatus(Base):
    __tablename__ = "Payment_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class TransactionStatus(Base):
    __tablename__ = "Transaction_Status"

    name: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class TransactionTypes(Base):
    __tablename__ = "Transaction_Types"

    code: Mapped[str] = mapped_column(String(32), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True)


class AccountBalances(Base):
    __tablename__ = "Account_Balances"

    account_id: Mapped[int] = mapped_column(ForeignKey("Accounts.id"), nullable=False)
    available_balance: Mapped[int] = mapped_column(
        Integer, nullable=False, server_default=text("0")
    )
    balance: Mapped[int] = mapped_column(
        Integer, nullable=False, server_default=text("0")
    )
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    updated_at: Mapped[Optional[datetime.datetime]] = mapped_column(TIMESTAMP)


class Accounts(Base):
    __tablename__ = "Accounts"

    client_id: Mapped[int] = mapped_column(
        ForeignKey("Clients.id", ondelete="CASCADE"), nullable=False
    )
    status_id: Mapped[int] = mapped_column(
        ForeignKey("Account_Status.id"), nullable=False
    )
    currency_id: Mapped[int] = mapped_column(ForeignKey("Currency.id"), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    created_at: Mapped[Optional[datetime.date]] = mapped_column(
        Date, server_default=text("CURRENT_DATE")
    )


class CardAuthorizations(Base):
    __tablename__ = "Card_Authorizations"

    card_id: Mapped[int] = mapped_column(ForeignKey("Cards.id"), nullable=False)
    transaction_id: Mapped[int] = mapped_column(
        ForeignKey("Transactions.id"), nullable=False
    )
    status_id: Mapped[int] = mapped_column(
        ForeignKey("Authorization_Status.id"), nullable=False
    )
    amount: Mapped[int] = mapped_column(Integer, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    created_at: Mapped[Optional[datetime.datetime]] = mapped_column(
        TIMESTAMP, server_default=text("CURRENT_TIMESTAMP")
    )
    expires_at: Mapped[Optional[datetime.datetime]] = mapped_column(TIMESTAMP)


class Cards(Base):
    __tablename__ = "Cards"
    __table_args__ = (CheckConstraint("expiration_month BETWEEN 1 AND 12"),)

    account_id: Mapped[int] = mapped_column(ForeignKey("Accounts.id"), nullable=False)
    card_category_id: Mapped[int] = mapped_column(
        ForeignKey("Card_Category.id"), nullable=False
    )
    status_id: Mapped[int] = mapped_column(ForeignKey("Card_Status.id"), nullable=False)
    card_number_hash: Mapped[str] = mapped_column(String(256), nullable=False)
    card_number_last4: Mapped[str] = mapped_column(String(4), nullable=False)
    card_holder_name: Mapped[str] = mapped_column(String(100), nullable=False)
    expiration_month: Mapped[int] = mapped_column(Integer, nullable=False)
    expiration_year: Mapped[int] = mapped_column(Integer, nullable=False)
    issued_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    cvv_hash: Mapped[Optional[str]] = mapped_column(String(256))
    activated_date: Mapped[Optional[datetime.date]] = mapped_column(
        Date, server_default=text("CURRENT_DATE")
    )
    pin_attempts: Mapped[Optional[int]] = mapped_column(
        Integer, server_default=text("0")
    )


class ClearingTransactions(Base):
    __tablename__ = "Clearing_Transactions"

    amount: Mapped[int] = mapped_column(Integer, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    authorization_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey("Card_Authorizations.id")
    )
    transaction_id: Mapped[Optional[int]] = mapped_column(ForeignKey("Transactions.id"))
    external_bank: Mapped[Optional[str]] = mapped_column(String(20))
    settlement_date: Mapped[Optional[datetime.date]] = mapped_column(Date)


class ClientAddresses(Base):
    __tablename__ = "Client_Addresses"

    client_id: Mapped[int] = mapped_column(
        ForeignKey("Clients.id", ondelete="CASCADE"), nullable=False, unique=True
    )
    city: Mapped[str] = mapped_column(String(64), nullable=False)
    country: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    is_resident: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("true")
    )


class ClientContacts(Base):
    __tablename__ = "Client_Contacts"

    client_id: Mapped[int] = mapped_column(
        ForeignKey("Clients.id", ondelete="CASCADE"), nullable=False
    )
    contact_type_id: Mapped[int] = mapped_column(
        ForeignKey("Contact_Type.id", ondelete="CASCADE"), nullable=False
    )
    contact_value: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    is_verified: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("false")
    )


class ClientDocuments(Base):
    __tablename__ = "Client_Documents"

    client_id: Mapped[int] = mapped_column(
        ForeignKey("Clients.id", ondelete="CASCADE"), nullable=False
    )
    document_type_id: Mapped[int] = mapped_column(
        ForeignKey("Document_Type.id"), nullable=False, unique=True
    )
    document_value: Mapped[str] = mapped_column(String(64), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    expire_at: Mapped[Optional[datetime.date]] = mapped_column(Date)


class ClientEmployment(Base):
    __tablename__ = "Client_Employment"

    client_id: Mapped[int] = mapped_column(
        ForeignKey("Clients.id", ondelete="CASCADE"), nullable=False, unique=True
    )
    status_id: Mapped[int] = mapped_column(
        ForeignKey("Employment_Status.id"), nullable=False
    )
    currency_id: Mapped[int] = mapped_column(ForeignKey("Currency.id"), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    monthly_income: Mapped[Optional[int]] = mapped_column(Integer)
    is_verified: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("false")
    )


class ClientVerifications(Base):
    __tablename__ = "Client_Verifications"

    client_id: Mapped[int] = mapped_column(
        ForeignKey("Clients.id", ondelete="CASCADE"), nullable=False, unique=True
    )
    kyc_status_id: Mapped[int] = mapped_column(
        ForeignKey("Kyc_Status.id"), nullable=False
    )
    aml_status_id: Mapped[int] = mapped_column(
        ForeignKey("Aml_Status.id"), nullable=False
    )
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    verified_at: Mapped[Optional[datetime.date]] = mapped_column(
        Date, server_default=text("CURRENT_DATE")
    )


class CreditPaymentSchedules(Base):
    __tablename__ = "Credit_Payment_Schedules"
    __table_args__ = (
        CheckConstraint("interest_amount >= 0"),
        CheckConstraint("payment_number > 0"),
        CheckConstraint("principal_amount >= 0"),
        CheckConstraint("total_amount = principal_amount + interest_amount"),
    )

    credit_id: Mapped[int] = mapped_column(
        ForeignKey("Credits.id", ondelete="CASCADE"), nullable=False
    )
    status_id: Mapped[int] = mapped_column(
        ForeignKey("Payment_Status.id"), nullable=False
    )
    payment_number: Mapped[int] = mapped_column(Integer, nullable=False)
    due_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    principal_amount: Mapped[int] = mapped_column(Integer, nullable=False)
    interest_amount: Mapped[int] = mapped_column(Integer, nullable=False)
    total_amount: Mapped[int] = mapped_column(Integer, nullable=False)
    remaining_balance: Mapped[int] = mapped_column(Integer, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    paid_date: Mapped[Optional[datetime.date]] = mapped_column(Date)
    paid_amount: Mapped[Optional[int]] = mapped_column(Integer)


class CreditPayments(Base):
    __tablename__ = "Credit_Payments"
    __table_args__ = (
        CheckConstraint("amount = principal_paid + interest_paid + late_fee_paid"),
        CheckConstraint("amount > 0"),
    )

    credit_id: Mapped[int] = mapped_column(
        ForeignKey("Credits.id", ondelete="CASCADE"), nullable=False
    )
    payment_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    amount: Mapped[int] = mapped_column(Integer, nullable=False)
    principal_paid: Mapped[int] = mapped_column(Integer, nullable=False)
    interest_paid: Mapped[int] = mapped_column(Integer, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    late_fee_paid: Mapped[Optional[int]] = mapped_column(
        Integer, server_default=text("0")
    )
    schedule_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey("Credit_Payment_Schedules.id")
    )
    transaction_id: Mapped[Optional[int]] = mapped_column(Integer)
    receipt_number: Mapped[Optional[str]] = mapped_column(String(50))
    created_at: Mapped[Optional[datetime.datetime]] = mapped_column(
        TIMESTAMP, server_default=text("CURRENT_TIMESTAMP")
    )


class Credits(Base):
    __tablename__ = "Credits"
    __table_args__ = (
        CheckConstraint("end_date > issued_date"),
        CheckConstraint("payment_due_day BETWEEN 1 AND 31"),
        CheckConstraint("principal_amount > 0"),
        CheckConstraint("remaining_amount >= 0"),
    )

    credit_number: Mapped[str] = mapped_column(String(20), nullable=False)
    plan_id: Mapped[int] = mapped_column(ForeignKey("Credit_Plans.id"), nullable=False)
    status_id: Mapped[int] = mapped_column(
        ForeignKey("Credit_Status.id"), nullable=False
    )
    currency_id: Mapped[int] = mapped_column(ForeignKey("Currency.id"), nullable=False)
    loan_account_id: Mapped[int] = mapped_column(
        ForeignKey("Accounts.id"), nullable=False
    )
    repayment_account_id: Mapped[int] = mapped_column(
        ForeignKey("Accounts.id"), nullable=False
    )
    principal_amount: Mapped[int] = mapped_column(Integer, nullable=False)
    remaining_amount: Mapped[int] = mapped_column(Integer, nullable=False)
    issued_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    end_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    payment_due_day: Mapped[int] = mapped_column(Integer, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    created_at: Mapped[Optional[datetime.datetime]] = mapped_column(
        TIMESTAMP, server_default=text("CURRENT_TIMESTAMP")
    )


class Deposits(Base):
    __tablename__ = "Deposits"

    account_id: Mapped[int] = mapped_column(ForeignKey("Accounts.id"), nullable=False)
    plan_id: Mapped[int] = mapped_column(ForeignKey("Deposit_Plan.id"), nullable=False)
    status_id: Mapped[int] = mapped_column(
        ForeignKey("Deposit_Status.id"), nullable=False
    )
    amount: Mapped[int] = mapped_column(Integer, nullable=False)
    start_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    end_date: Mapped[datetime.date] = mapped_column(Date, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    partial_withdrawal_allowed: Mapped[Optional[bool]] = mapped_column(
        Boolean, server_default=text("FALSE")
    )


class InterbankSettlements(Base):
    __tablename__ = "Interbank_Settlements"

    transaction_id: Mapped[int] = mapped_column(
        ForeignKey("Transactions.id"), nullable=False
    )
    bank_id: Mapped[int] = mapped_column(ForeignKey("Banks.id"), nullable=False)
    direction_id: Mapped[int] = mapped_column(
        ForeignKey("Directions.id"), nullable=False
    )
    amount: Mapped[int] = mapped_column(Integer, nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    settlement_date: Mapped[Optional[datetime.date]] = mapped_column(Date)
    created_at: Mapped[Optional[datetime.datetime]] = mapped_column(
        TIMESTAMP, server_default=text("CURRENT_TIMESTAMP")
    )


class LedgerEntries(Base):
    __tablename__ = "Ledger_Entries"
    __table_args__ = (
        CheckConstraint("credit >= 0"),
        CheckConstraint("debit + credit > 0"),
        CheckConstraint("debit >= 0"),
    )

    transaction_id: Mapped[int] = mapped_column(
        ForeignKey("Transactions.id"), nullable=False
    )
    account_id: Mapped[int] = mapped_column(ForeignKey("Accounts.id"), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    debit: Mapped[Optional[int]] = mapped_column(Integer, server_default=text("0"))
    credit: Mapped[Optional[int]] = mapped_column(Integer, server_default=text("0"))
    created_at: Mapped[Optional[datetime.datetime]] = mapped_column(
        TIMESTAMP, server_default=text("CURRENT_TIMESTAMP")
    )


class TransactionParties(Base):
    __tablename__ = "Transaction_Parties"

    transaction_id: Mapped[int] = mapped_column(
        ForeignKey("Transactions.id"), nullable=False
    )
    direction_id: Mapped[int] = mapped_column(
        ForeignKey("Directions.id"), nullable=False
    )
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    account_id: Mapped[Optional[int]] = mapped_column(ForeignKey("Accounts.id"))
    external_account_number: Mapped[Optional[str]] = mapped_column(String(32))
    bank_id: Mapped[Optional[int]] = mapped_column(ForeignKey("Banks.id"))


class Transactions(Base):
    __tablename__ = "Transactions"
    __table_args__ = (CheckConstraint("amount != 0"),)

    transaction_uuid: Mapped[str] = mapped_column(String(36), nullable=False)
    type_id: Mapped[int] = mapped_column(
        ForeignKey("Transaction_Types.id"), nullable=False
    )
    status_id: Mapped[int] = mapped_column(
        ForeignKey("Transaction_Status.id"), nullable=False
    )
    amount: Mapped[int] = mapped_column(Integer, nullable=False)
    currency_id: Mapped[int] = mapped_column(ForeignKey("Currency.id"), nullable=False)
    mcc_id: Mapped[int] = mapped_column(ForeignKey("Mcc_Codes.id"), nullable=False)
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    created_at: Mapped[Optional[datetime.datetime]] = mapped_column(
        TIMESTAMP, server_default=text("CURRENT_TIMESTAMP")
    )
    completed_at: Mapped[Optional[datetime.datetime]] = mapped_column(TIMESTAMP)
