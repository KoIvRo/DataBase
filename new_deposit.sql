-- 3. Открытие вклада клиентом
-- Клиент: Петр Романов (id=2) открывает вклад 150 000 руб.

SELECT id, client_id, status_id, currency_id
FROM Accounts
WHERE client_id = 2;

SELECT account_id, available_balance, balance
FROM Account_Balances
WHERE account_id = 5
ORDER BY updated_at DESC
LIMIT 1;

SELECT d.id, d.amount, d.status_id, d.start_date, d.end_date
FROM Deposits d
JOIN Accounts a ON d.account_id = a.id
WHERE a.client_id = 2;

BEGIN TRANSACTION;

INSERT INTO Accounts (client_id, status_id, currency_id, created_at)
VALUES (2, 1, 1, CURRENT_DATE);

CREATE TEMP TABLE temp_deposit_account AS
SELECT last_insert_rowid() AS account_id;

INSERT INTO Deposits (
    account_id, plan_id, status_id, amount,
    start_date, end_date, partial_withdrawal_allowed
) VALUES (
    (SELECT account_id FROM temp_deposit_account),
    1, 1, 150000,
    CURRENT_DATE, DATE(CURRENT_DATE, '+6 months'), 1
);


INSERT INTO Transactions (
    transaction_uuid, type_id, status_id, amount,
    currency_id, mcc_id, created_at, completed_at
) VALUES (
    'deposit-' || strftime('%s', 'now') || '-' || random(),
    4, 2, 150000,
    1, 5411, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

CREATE TEMP TABLE temp_transaction_id AS
SELECT last_insert_rowid() AS trans_id;

INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id)
VALUES
    ((SELECT trans_id FROM temp_transaction_id), 5, 2),
    ((SELECT trans_id FROM temp_transaction_id), (SELECT account_id FROM temp_deposit_account), 1);

INSERT INTO Ledger_Entries (transaction_id, account_id, credit, debit)
VALUES
    ((SELECT trans_id FROM temp_transaction_id), 5, 150000, 0),
    ((SELECT trans_id FROM temp_transaction_id), (SELECT account_id FROM temp_deposit_account), 0, 150000);

CREATE TEMP TABLE temp_balance_before AS
SELECT available_balance, balance
FROM Account_Balances
WHERE account_id = 5
ORDER BY updated_at DESC
LIMIT 1;

INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at)
VALUES
    (5,
     (SELECT available_balance FROM temp_balance_before) - 150000,
     (SELECT balance FROM temp_balance_before) - 150000,
     CURRENT_TIMESTAMP),
    ((SELECT account_id FROM temp_deposit_account), 150000, 150000, CURRENT_TIMESTAMP);

DROP TABLE temp_deposit_account;
DROP TABLE temp_transaction_id;
DROP TABLE temp_balance_before;

COMMIT;

SELECT id, client_id, status_id, currency_id
FROM Accounts
WHERE client_id = 2;

SELECT d.id, d.amount, d.status_id, d.start_date, d.end_date, d.account_id
FROM Deposits d
WHERE d.id = (SELECT deposit_id FROM (SELECT last_insert_rowid() AS deposit_id UNION ALL SELECT 0) LIMIT 1);

SELECT account_id, available_balance, balance
FROM Account_Balances
WHERE account_id = 5
ORDER BY updated_at DESC
LIMIT 1;

SELECT ab.account_id, ab.available_balance, ab.balance
FROM Account_Balances ab
WHERE ab.account_id = (SELECT id FROM Accounts WHERE client_id = 2 ORDER BY id DESC LIMIT 1)
ORDER BY ab.updated_at DESC
LIMIT 1;

SELECT d.id, d.amount, d.status_id, d.start_date, d.end_date
FROM Deposits d
JOIN Accounts a ON d.account_id = a.id
WHERE a.client_id = 2
ORDER BY d.id DESC;

SELECT id, transaction_uuid, type_id, amount, status_id
FROM Transactions
ORDER BY id DESC
LIMIT 1;