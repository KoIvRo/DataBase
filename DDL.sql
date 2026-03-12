-- DDL

-- МОДУЛЬ КЛИЕНТОВ
CREATE TABLE clients
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(64) NOT NULL,
    middle_name VARCHAR(64),
    last_name VARCHAR(64) NOT NULL,
    password_hash VARCHAR(128) NOT NULL,

    birth_date DATE NOT NULL,
    created_at DATE NOT NULL DEFAULT CURRENT_DATE
);


CREATE TABLE client_contacts
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,

    contact_type_id INTEGER NOT NULL,
    contact_value VARCHAR(64) NOT NULL,
    is_verified BOOLEAN default false,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (contact_type_id) REFERENCES contact_type(id) ON DELETE CASCADE
);


CREATE TABLE client_documents
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,

    document_type_id INTEGER NOT NULL,
    document_value VARCHAR(64) NOT NULL,
    expire_at DATE,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (document_type_id) REFERENCES document_type(id)
);


CREATE TABLE client_employee
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL UNIQUE,

    status_id INTEGER NOT NULL,
    monthly_income INTEGER,
    income_currency VARCHAR(3) DEFAULT 'RUB',
    is_verified BOOLEAN DEFAULT false,

    FOREIGN KEY (status_id) REFERENCES employment_status(id),
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);


CREATE TABLE client_address
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL UNIQUE,
    is_resident BOOLEAN DEFAULT true,
    city VARCHAR(64) NOT NULL,
    country VARCHAR(64) NOT NULL,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);


CREATE TABLE client_verification
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL UNIQUE,

    kyc_status_id INTEGER NOT NULL,
    aml_status_id INTEGER NOT NULL,
    verified_at DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (kyc_status_id) REFERENCES kyc_status(id),
    FOREIGN KEY (aml_status_id) REFERENCES aml_status(id)
);


CREATE TABLE contact_type
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- telephone, email, tg
);

CREATE TABLE document_type
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- passport, snils, inn
);

CREATE TABLE employment_status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- employed, self_employed, business, unemployed
);

CREATE TABLE kyc_status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- pending, rejected, edd
);

CREATE TABLE aml_status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- low, medium, high
);


-- МОДУЛЬ СЧЕТОВ
CREATE TABLE accounts
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,

    balance INTEGER NOT NULL,

    status_id INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,
    type_id INTEGER NOT NULL,
    account_type_id INTEGER NOT NULL, -- id в соответствующей таблице например в credit

    created_at DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES account_status(id),
    FOREIGN KEY (currency_id) REFERENCES currency(id),
    FOREIGN KEY (type_id) REFERENCES account_types(id)
);


CREATE TABLE account_status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- open, closed, blocked, frozen
);

CREATE TABLE currency
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(3) NOT NULL UNIQUE -- USD, RUB, YAN
);

CREATE TABLE account_types
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE
);


-- МОДУЛЬ ДЕБЕТОВЫХ СЧЕТОВ
CREATE TABLE debit_accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- это account_type_id из accounts
    plan_id INTEGER NOT NULL,

    opened_at DATE NOT NULL DEFAULT CURRENT_DATE,
    closed_at DATE,

    FOREIGN KEY (plan_id) REFERENCES debit_plans(id)
);

CREATE TABLE debit_plans
(
    id INTEGER PRIMARY KEY,
    monthly_fee INTEGER DEFAULT 0, -- плата за обслуживание
    interest_rate DECIMAL DEFAULT 0, -- процент на остаток
    transfer_fee DECIMAL DEFAULT 0 -- процент на остаток
);


-- МОДУЛЬ ВКЛАДОВ
CREATE TABLE deposits
(
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- это account_type_id из accounts
    plan_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL, -- active, closed, early_closed

    -- Сумма вклада
    amount INTEGER NOT NULL,

    -- Даты
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    partial_withdrawal_allowed BOOLEAN DEFAULT FALSE,

    -- Счет для зачисления процентов и возврата

    FOREIGN KEY (status_id) REFERENCES deposit_status(id),
    FOREIGN KEY (plan_id) REFERENCES deposit_plan(id)
);

CREATE TABLE deposit_plan
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE,
    count_month INTEGER NOT NULL,

    minimal_amount INTEGER,
    early_withdrawal_rate DECIMAL, -- ставка при досрочном снятии
    early_withdrawal_fee DECIMAL,
    interest_rate DECIMAL NOT NULL
);

CREATE TABLE deposit_status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- active, closed, early_closed
);

-- МОУДЛЬ КРЕДИТОВ
CREATE TABLE credits (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- это account_type_id из accounts
    credit_number VARCHAR(20) UNIQUE NOT NULL, -- номер кредитного договора

    client_id INTEGER NOT NULL,
    plan_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,

    disbursement_account_id INTEGER NOT NULL, -- accounts.id (куда дали деньги)
    repayment_account_id INTEGER NOT NULL,    -- accounts.id (откуда платят)

    principal_amount INTEGER NOT NULL, -- сумма кредита
    remaining_amount INTEGER NOT NULL, -- остаток долга

    issued_date DATE NOT NULL, -- дата выдачи
    end_date DATE NOT NULL, -- дата окончания по договору
    payment_due_day INTEGER NOT NULL CHECK(payment_due_day BETWEEN 1 AND 31), -- число платежа

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (plan_id) REFERENCES credit_plans(id),
    FOREIGN KEY (status_id) REFERENCES credit_status(id),
    FOREIGN KEY (currency_id) REFERENCES currency(id),
    FOREIGN KEY (disbursement_account_id) REFERENCES accounts(id),
    FOREIGN KEY (repayment_account_id) REFERENCES accounts(id),

    CHECK (principal_amount > 0),
    CHECK (remaining_amount >= 0),
    CHECK (end_date > issued_date)
);


CREATE TABLE credit_plans (
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE, -- Потребительский, Ипотека, Автокредит

    interest_rate DECIMAL(5,2) NOT NULL, -- процентная ставка
    min_amount INTEGER, -- минимальная сумма
    max_amount INTEGER, -- максимальная сумма
    min_term_months INTEGER NOT NULL, -- минимальный срок
    max_term_months INTEGER NOT NULL, -- максимальный срок

    late_payment_fee INTEGER, -- штраф за просрочку

    requires_collateral BOOLEAN DEFAULT FALSE, -- нужен ли залог
    requires_income_proof BOOLEAN DEFAULT TRUE, -- нужен ли доход
    requires_credit_history BOOLEAN DEFAULT TRUE, -- нужна ли кредитная история

    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE credit_status (
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- active, closed, overdue, restructured, approved, rejected
);


CREATE TABLE credit_payment_schedule (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    credit_id INTEGER NOT NULL,

    status_id INTEGER NOT NULL,

    payment_number INTEGER NOT NULL, -- номер платежа по порядку
    due_date DATE NOT NULL, -- дата платежа

    principal_amount INTEGER NOT NULL, -- сумма в погашение основного долга
    interest_amount INTEGER NOT NULL, -- сумма процентов
    total_amount INTEGER NOT NULL, -- всего к оплате

    remaining_balance INTEGER NOT NULL, -- остаток долга после платежа

    paid_date DATE,
    paid_amount INTEGER,

    FOREIGN KEY (credit_id) REFERENCES credits(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES payment_status(id),

    CHECK (payment_number > 0),
    CHECK (principal_amount >= 0),
    CHECK (interest_amount >= 0),
    CHECK (total_amount = principal_amount + interest_amount)
);

CREATE TABLE payment_status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE credit_payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    credit_id INTEGER NOT NULL,

    payment_date DATE NOT NULL,
    amount INTEGER NOT NULL,

    principal_paid INTEGER NOT NULL,
    interest_paid INTEGER NOT NULL,
    late_fee_paid INTEGER DEFAULT 0,

    schedule_id INTEGER, -- ссылка на график платежей
    transaction_id INTEGER, -- ссылка на транзакцию

    receipt_number VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (credit_id) REFERENCES credits(id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES credit_payment_schedule(id),

    CHECK (amount = principal_paid + interest_paid + late_fee_paid),
    CHECK (amount > 0)
);


-- МОДУЛЬ КАРТ
CREATE TABLE cards (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    debit_account_id INTEGER NOT NULL,
    card_type_id INTEGER NOT NULL,
    card_category_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,

    card_number_hash VARCHAR(256) NOT NULL,
    card_number_last4 VARCHAR(4) NOT NULL,
    card_holder_name VARCHAR(100) NOT NULL,
    expiration_month INTEGER NOT NULL CHECK(expiration_month BETWEEN 1 AND 12),
    expiration_year INTEGER NOT NULL,
    cvv_hash VARCHAR(256),
    issued_date DATE NOT NULL,
    activated_date DATE DEFAULT CURRENT_DATE,
    pin_attempts INTEGER DEFAULT 0,

    FOREIGN KEY (debit_account_id) REFERENCES debit_accounts(id),
    FOREIGN KEY (card_type_id) REFERENCES card_type(id),
    FOREIGN KEY (status_id) REFERENCES card_status(id),
    FOREIGN KEY (card_category_id) REFERENCES card_category(id)
);


CREATE TABLE card_type (
    id INTEGER PRIMARY KEY,
    type_code VARCHAR(20) UNIQUE NOT NULL -- visa_classic, mastercard_gold, mir
);


CREATE TABLE card_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    status_code VARCHAR(64) NOT NULL UNIQUE -- active, blocked, expired, lost
);

CREATE TABLE card_category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(64) NOT NULL UNIQUE -- standard, silver, gold
);


-- Модуль транзакции
CREATE TABLE transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_uuid VARCHAR(36) UNIQUE NOT NULL, -- глобальный уникальный ID

    type_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,

    amount INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,

    -- Временные метки
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,

    FOREIGN KEY (type_id) REFERENCES transaction_types(id),
    FOREIGN KEY (status_id) REFERENCES transaction_status(id),
    FOREIGN KEY (currency_id) REFERENCES currency(id),

    CHECK (amount != 0)
);


CREATE TABLE ledger_entries
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    amount INTEGER NOT NULL,

    account_id INTEGER NOT NULL,
    transaction_id INTEGER NOT NULL,

    FOREIGN KEY (account_id) REFERENCES accounts(ID),
    FOREIGN KEY (transaction_id) REFERENCES transactions(ID),

    CHECK (amount != 0)
);


CREATE TABLE transaction_status (
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) UNIQUE NOT NULL -- pending, completed, failed, cancelled, reversed
);


CREATE TABLE transaction_types (
    id INTEGER PRIMARY KEY,
    code VARCHAR(30) UNIQUE NOT NULL -- deposit, withdrawal, transfer, interest, fee
);
