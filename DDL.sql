CREATE TABLE clients
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(32) NOT NULL,
    second_name VARCHAR(32) NOT NULL,
    passport VARCHAR(10) NOT NULL UNIQUE,

    phone VARCHAR(15) NOT NULL,
    email VARCHAR(320) NOT NULL UNIQUE,

    created_date DATE NOT NULL DEFAULT CURRENT_DATE
);


CREATE TABLE accounts
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    balance INTEGER NOT NULL,

    plan_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,

    open_date DATE NOT NULL DEFAULT CURRENT_DATE,

    FOREIGN KEY (plan_id) REFERENCES account_plans(ID),
    FOREIGN KEY (status_id) REFERENCES account_status(ID)
);


CREATE TABLE client_accounts
(
    client_id INTEGER NOT NULL,
    account_id INTEGER NOT NULL,

    PRIMARY KEY (client_id, account_id),

    FOREIGN KEY (client_id) REFERENCES clients(ID),
    FOREIGN KEY (account_id) REFERENCES accounts(ID)
);


CREATE TABLE account_plans
(
    ID INTEGER PRIMARY KEY,
    name VARCHAR(320) NOT NULL,
    type_id INTEGER NOT NULL,

    credit_limit INTEGER,
    interest_rate DECIMAL,
    monthly_fee DECIMAL,

    FOREIGN KEY (type_id) REFERENCES account_types(ID)
);


CREATE TABLE account_types
(
    ID INTEGER PRIMARY KEY,
    type VARCHAR(320) NOT NULL
);


CREATE TABLE account_status
(
    ID   INTEGER PRIMARY KEY,
    name VARCHAR(320) NOT NULL
);


CREATE TABLE interest_rate_history
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    plan_id INTEGER NOT NULL,
    rate DECIMAL NOT NULL,

    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE,

    FOREIGN KEY (plan_id) REFERENCES account_plans(ID)
);


CREATE TABLE transactions
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    type_id INTEGER NOT NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (type_id) REFERENCES transaction_types(ID)
);


CREATE TABLE ledger_entries
(
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    amount INTEGER NOT NULL,

    account_id INTEGER NOT NULL,
    transaction_id INTEGER NOT NULL,

    FOREIGN KEY (account_id) REFERENCES accounts(ID),
    FOREIGN KEY (transaction_id) REFERENCES transactions(ID)
);


CREATE TABLE transaction_types
(
    ID INTEGER PRIMARY KEY,
    name VARCHAR(320) NOT NULL
);
