-- DDL

-- МОДУЛЬ КЛИЕНТОВ
CREATE TABLE Clients
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(64) NOT NULL,
    middle_name VARCHAR(64),
    last_name VARCHAR(64) NOT NULL,
    password_hash VARCHAR(128) NOT NULL,

    birth_date DATE NOT NULL,
    created_at DATE NOT NULL DEFAULT CURRENT_DATE
);


CREATE TABLE Client_Contacts
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,

    contact_type_id INTEGER NOT NULL,
    contact_value VARCHAR(64) NOT NULL,
    is_verified BOOLEAN default false,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (contact_type_id) REFERENCES contact_type(id) ON DELETE CASCADE
);


CREATE TABLE Client_Documents
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,

    document_type_id INTEGER NOT NULL,
    document_value VARCHAR(64) NOT NULL,
    expire_at DATE,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (document_type_id) REFERENCES document_type(id)
);


CREATE TABLE Client_Employment
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL UNIQUE,

    status_id INTEGER NOT NULL,
    monthly_income INTEGER,
    currency_id INTEGER NOT NULL,
    is_verified BOOLEAN DEFAULT false,

    FOREIGN KEY (status_id) REFERENCES employment_status(id),
    FOREIGN KEY (currency_id) REFERENCES currency(id),
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);


CREATE TABLE Client_Addresses
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL UNIQUE,
    is_resident BOOLEAN DEFAULT true,
    city VARCHAR(64) NOT NULL,
    country VARCHAR(64) NOT NULL,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);


CREATE TABLE Client_Verifications
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


CREATE TABLE Contact_Type
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- telephone, email, tg
);

CREATE TABLE Document_Type
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- passport, snils, inn
);

CREATE TABLE Employment_Status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- employed, self_employed, business, unemployed
);

CREATE TABLE Kyc_Status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- pending, rejected, edd
);

CREATE TABLE Aml_Status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- low, medium, high
);





-- МОДУЛЬ СЧЕТОВ
CREATE TABLE Accounts
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,

    status_id INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,

    created_at DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES account_status(id),
    FOREIGN KEY (currency_id) REFERENCES currency(id)
);


CREATE TABLE Account_Balances
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,

    available_balance INTEGER NOT NULL DEFAULT 0,
    balance INTEGER NOT NULL DEFAULT 0,

    updated_at TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);


CREATE TABLE Account_Status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- open, closed, blocked, frozen
);





-- МОДУЛЬ ВКЛАДОВ
CREATE TABLE Deposits
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
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
    FOREIGN KEY (plan_id) REFERENCES deposit_plan(id),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE TABLE Deposit_Plan
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE,
    count_month INTEGER NOT NULL,

    minimal_amount INTEGER,
    early_withdrawal_rate DECIMAL, -- ставка при досрочном снятии
    early_withdrawal_fee DECIMAL,
    interest_rate DECIMAL NOT NULL
);

CREATE TABLE Deposit_Status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- active, closed, early_closed
);




-- МОУДЛЬ КРЕДИТОВ
CREATE TABLE Credits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    credit_number VARCHAR(20) UNIQUE NOT NULL, -- номер кредитного договора

    plan_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,

    loan_account_id INTEGER NOT NULL, -- accounts.id (куда дали деньги)
    repayment_account_id INTEGER NOT NULL,    -- accounts.id (откуда платят)

    principal_amount INTEGER NOT NULL, -- сумма кредита
    remaining_amount INTEGER NOT NULL, -- остаток долга

    issued_date DATE NOT NULL, -- дата выдачи
    end_date DATE NOT NULL, -- дата окончания по договору
    payment_due_day INTEGER NOT NULL CHECK(payment_due_day BETWEEN 1 AND 31), -- число платежа

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (plan_id) REFERENCES credit_plans(id),
    FOREIGN KEY (status_id) REFERENCES credit_status(id),
    FOREIGN KEY (currency_id) REFERENCES currency(id),
    FOREIGN KEY (loan_account_id) REFERENCES accounts(id),
    FOREIGN KEY (repayment_account_id) REFERENCES accounts(id),

    CHECK (principal_amount > 0),
    CHECK (remaining_amount >= 0),
    CHECK (end_date > issued_date)
);


CREATE TABLE Credit_Plans (
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

CREATE TABLE Credit_Status (
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE -- active, closed, overdue, restructured, approved, rejected
);


CREATE TABLE Credit_Payment_Schedules (
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

CREATE TABLE Payment_Status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE Credit_Payments (
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
    FOREIGN KEY (schedule_id) REFERENCES credit_payment_schedules(id),

    CHECK (amount = principal_paid + interest_paid + late_fee_paid),
    CHECK (amount > 0)
);





-- МОДУЛЬ КАРТ
CREATE TABLE Cards (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_id INTEGER NOT NULL,
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

    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (status_id) REFERENCES card_status(id),
    FOREIGN KEY (card_category_id) REFERENCES card_category(id)
);


CREATE TABLE Card_Authorizations -- HOLD
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    card_id INTEGER NOT NULL,
    transaction_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,

    amount INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,

    FOREIGN KEY (status_id) REFERENCES authorization_status(id),
    FOREIGN KEY (card_id) REFERENCES cards(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id)
);

CREATE TABLE Authorization_Status
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(20) -- authorized, captured, expired
);

CREATE TABLE Card_Status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    status_code VARCHAR(64) NOT NULL UNIQUE -- active, blocked, expired, lost
);

CREATE TABLE Card_Category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(64) NOT NULL UNIQUE -- standard, silver, gold
);





-- Модуль транзакции
CREATE TABLE Transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_uuid VARCHAR(36) UNIQUE NOT NULL, -- глобальный уникальный ID

    type_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,

    amount INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,
    mcc_id INTEGER NOT NULL,

    -- Временные метки
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,

    FOREIGN KEY (mcc_id) REFERENCES mcc_codes(id),
    FOREIGN KEY (type_id) REFERENCES transaction_types(id),
    FOREIGN KEY (status_id) REFERENCES transaction_status(id),
    FOREIGN KEY (currency_id) REFERENCES currency(id),

    CHECK (amount != 0)
);

CREATE TABLE Transaction_Parties
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    transaction_id INTEGER NOT NULL,

    account_id INTEGER, -- внутренний счет в банке
    external_account_number VARCHAR(32), -- для межбанка
    bank_id INTEGER, -- БИК для external_account_number

    direction_id INTEGER NOT NULL, -- 'source' или 'destination'

    FOREIGN KEY (direction_id) REFERENCES directions(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (bank_id) REFERENCES banks(id)
);

CREATE TABLE Interbank_Settlements
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_id INTEGER NOT NULL,

    bank_id INTEGER NOT NULL, -- БИК
    direction_id INTEGER NOT NULL, -- incoming, outgoing
    amount INTEGER NOT NULL,
    settlement_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (direction_id) REFERENCES directions(id),
    FOREIGN KEY (bank_id) REFERENCES banks(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id)
);

CREATE TABLE Ledger_Entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    transaction_id INTEGER NOT NULL,
    account_id INTEGER NOT NULL,

    debit INTEGER DEFAULT 0,
    credit INTEGER DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (account_id) REFERENCES accounts(id),

    CHECK (debit >= 0),
    CHECK (credit >= 0),
    CHECK (debit + credit > 0)
);

CREATE TABLE Transaction_Status (
    id INTEGER PRIMARY KEY,
    name VARCHAR(64) UNIQUE NOT NULL -- pending, completed, failed, cancelled, reversed
);

CREATE TABLE Transaction_Types
(
    id INTEGER PRIMARY KEY,
    code VARCHAR(32) UNIQUE NOT NULL
);
/*
internal_transfer
interbank_transfer
card_payment
deposit_open
deposit_interest
credit_payment
*/

CREATE TABLE Clearing_Transactions
(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    authorization_id INTEGER,
    transaction_id INTEGER,
    external_bank VARCHAR(20),
    amount INTEGER NOT NULL,
    settlement_date DATE,

    FOREIGN KEY (authorization_id) REFERENCES card_authorizations(id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id)
);

CREATE TABLE Directions
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(16) NOT NULL -- in, out
);




CREATE TABLE Currency
(
    id INTEGER PRIMARY KEY,
    name VARCHAR(3) NOT NULL UNIQUE -- USD, RUB, YAN
);

CREATE TABLE Banks
(
    id INTEGER PRIMARY KEY NOT NULL,
    name VARCHAR(64) NOT NULL UNIQUE,
    CHECK(id >= 100000000 AND id <= 999999999) -- БИК для россий начинается с 4
);

CREATE TABLE Mcc_Codes ( -- Merchant Category Code
    id INTEGER PRIMARY KEY,
    description VARCHAR(128) NOT NULL,
    CHECK(id >= 1000 AND id <= 9999)
);


/*
ВНУТРИ БАНКА
Инициирование ->
Проверка доступного баланса ->
Internal ledger ->
Баланс получателя обновляется почти сразу

МЕЖБАНК
Инициирование ->
Дебет клиента А ->
Клиринг/передача через ЦБ ->
Кредит счета клиента В ->
Баланс получателя обновляется

ЭКВАЙРИНГ
Авторизация (HOLD) ->
Клиринг через платёжную систему ->
Списание с ledger ->
Merchant получает деньги ->
Клиент видит completed
*/
