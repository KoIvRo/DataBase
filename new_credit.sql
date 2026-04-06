-- 1. Оформление нового кредита клиентом
-- Клиент: Анна Сидорова (id=3), сумма 250 000 руб.

SELECT id, client_id, status_id, currency_id, created_at
FROM Accounts
WHERE client_id = 3;

SELECT id, credit_number, principal_amount, remaining_amount, status_id
FROM Credits
WHERE id IN (SELECT credit_id FROM Credit_Payment_Schedules WHERE credit_id IN (
    SELECT id FROM Credits WHERE loan_account_id IN (
        SELECT id FROM Accounts WHERE client_id = 3
    )
));

SELECT cps.id, cps.credit_id, cps.payment_number, cps.total_amount, cps.status_id
FROM Credit_Payment_Schedules cps
WHERE cps.credit_id IN (
    SELECT id FROM Credits WHERE loan_account_id IN (
        SELECT id FROM Accounts WHERE client_id = 3
    )
);


BEGIN TRANSACTION;

-- Создаем ссудный счет
INSERT INTO Accounts (client_id, status_id, currency_id, created_at)
VALUES (3, 1, 1, CURRENT_DATE);

-- Создаем запись о кредите
INSERT INTO Credits (
    credit_number, plan_id, status_id, currency_id,
    loan_account_id, repayment_account_id,
    principal_amount, remaining_amount,
    issued_date, end_date, payment_due_day, created_at
) VALUES (
    'CRED-2025-0001', 1, 5, 1,
    (SELECT last_insert_rowid()), 8,
    250000, 250000,
    CURRENT_DATE, DATE(CURRENT_DATE, '+24 months'), 15,
    CURRENT_TIMESTAMP
);

-- id Кредита
CREATE TEMP TABLE temp_credit_id AS
SELECT last_insert_rowid() AS credit_id;

-- График платежей
INSERT INTO Credit_Payment_Schedules (
    credit_id, status_id, payment_number, due_date,
    principal_amount, interest_amount, total_amount, remaining_balance
) VALUES (
    (SELECT credit_id FROM temp_credit_id), 1, 1, DATE(CURRENT_DATE, '+1 month'),
    10417, 3229, 13646, 239583
);

INSERT INTO Credit_Payment_Schedules (
    credit_id, status_id, payment_number, due_date,
    principal_amount, interest_amount, total_amount, remaining_balance
) VALUES (
    (SELECT credit_id FROM temp_credit_id), 1, 2, DATE(CURRENT_DATE, '+2 months'),
    10417, 3229, 13646, 229166
);

INSERT INTO Credit_Payment_Schedules (
    credit_id, status_id, payment_number, due_date,
    principal_amount, interest_amount, total_amount, remaining_balance
) VALUES (
    (SELECT credit_id FROM temp_credit_id), 1, 3, DATE(CURRENT_DATE, '+3 months'),
    10417, 3229, 13646, 218749
);

DROP TABLE temp_credit_id;

COMMIT;

SELECT id, client_id, status_id, currency_id, created_at
FROM Accounts
WHERE client_id = 3
ORDER BY id DESC
LIMIT 1;

SELECT id, credit_number, principal_amount, remaining_amount, status_id, loan_account_id
FROM Credits
WHERE credit_number = 'CRED-2025-0001';

SELECT cps.payment_number, cps.due_date,
       cps.principal_amount, cps.interest_amount,
       cps.total_amount, cps.remaining_balance, cps.status_id
FROM Credit_Payment_Schedules cps
WHERE cps.credit_id = (SELECT id FROM Credits WHERE credit_number = 'CRED-2025-0001')
ORDER BY cps.payment_number;

SELECT c.id, c.credit_number, c.principal_amount, c.remaining_amount, c.status_id
FROM Credits c
WHERE c.loan_account_id IN (SELECT id FROM Accounts WHERE client_id = 3);


SELECT a.currency_id, SUM(ab.balance)
FROM Account_Balances AS ab
JOIN Accounts AS a ON ab.account_id = a.id
WHERE a.currency_id = 1
GROUP BY a.currency_id
HAVING SUM(ab.balance) > 100000
ORDER BY a.currency_id;

SELECT
    ab.id,
    ab.account_id,
    LAG(ab.balance) OVER (PARTITION BY ab.account_id ORDER BY ab.updated_at DESC) as lag,
    updated_at
FROM Account_Balances AS ab
ORDER BY account_id;

