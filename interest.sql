-- Начисление процентов

-- Выведем текущий баланс и план
SELECT a.ID, a.balance, p.name AS plan, p.interest_rate
FROM accounts AS a
JOIN account_plans AS p ON a.plan_id = p.ID
WHERE a.ID = 3;  -- saving

BEGIN TRANSACTION;
INSERT INTO transactions (type_id) VALUES (4);

-- Вычисляем процент
WITH interest AS (
    SELECT CAST(balance * p.interest_rate / 100 AS INTEGER) AS amount
    FROM accounts AS a
    JOIN account_plans AS p ON a.plan_id = p.ID
    WHERE a.ID = 3
)

INSERT INTO ledger_entries (transaction_id, account_id, amount)
SELECT (SELECT MAX(ID) FROM transactions), 2, (SELECT amount FROM interest);

-- В sqlite работает только для следующего запроса
WITH interest AS (
    SELECT CAST(balance * p.interest_rate / 100 AS INTEGER) AS amount
    FROM accounts AS a
    JOIN account_plans AS p ON a.plan_id = p.ID
    WHERE a.ID = 3
)

INSERT INTO ledger_entries (transaction_id, account_id, amount)
SELECT (SELECT MAX(ID) FROM transactions), 0, -(SELECT amount FROM interest);

-- 4. Обновляем балансы
WITH interest AS (
    SELECT CAST(balance * p.interest_rate / 100 AS INTEGER) AS amount
    FROM accounts AS a
    JOIN account_plans AS p ON a.plan_id = p.ID
    WHERE a.ID = 3
)

UPDATE accounts
SET balance = balance + (SELECT amount FROM interest)
WHERE ID = 3;

WITH interest AS (
    SELECT CAST(balance * p.interest_rate / 100 AS INTEGER) AS amount
    FROM accounts AS a
    JOIN account_plans AS p ON a.plan_id = p.ID
    WHERE a.ID = 3
)

UPDATE accounts
SET balance = balance - (SELECT amount FROM interest)
WHERE ID = 0;

COMMIT;

-- Посмотрим баланс после начисления
SELECT a.ID, a.balance, p.name AS plan
FROM accounts AS a
JOIN account_plans AS p ON a.plan_id = p.ID
WHERE a.ID = 3;

SELECT SUM(amount) AS sum_transaction
FROM ledger_entries
WHERE transaction_id = (SELECT MAX(ID) FROM transactions);
