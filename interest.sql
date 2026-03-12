-- Начисление процентов

SELECT balance
FROM accounts AS a
WHERE a.type_id = (SELECT id FROM account_types WHERE name = 'deposit');


BEGIN TRANSACTION;

INSERT INTO transactions (transaction_uuid, type_id, status_id, amount, currency_id, created_at)
VALUES ('22222222-3333-4444-5555-666666666666', 4, 2,
    CAST((SELECT d.amount * (dp.interest_rate / 100) / 365 * 30
     FROM deposits d
     JOIN deposit_plan dp ON d.plan_id = dp.id
     WHERE d.id = 1) AS INTEGER),
    1, CURRENT_TIMESTAMP);

INSERT INTO ledger_entries (transaction_id, account_id, amount)
VALUES
    ((SELECT MAX(id) FROM transactions),
     (SELECT a.id FROM accounts a WHERE a.account_type_id = 1 AND a.type_id = 3),
     CAST((SELECT d.amount * (dp.interest_rate / 100) / 365 * 30
      FROM deposits d
      JOIN deposit_plan dp ON d.plan_id = dp.id
      WHERE d.id = 1) AS INTEGER));

INSERT INTO ledger_entries (transaction_id, account_id, amount)
VALUES ((SELECT MAX(id) FROM transactions), 0,
    -CAST((SELECT d.amount * (dp.interest_rate / 100) / 365 * 30
       FROM deposits d
       JOIN deposit_plan dp ON d.plan_id = dp.id
       WHERE d.id = 1) AS INTEGER));

UPDATE accounts
SET balance = balance + CAST((SELECT d.amount * (dp.interest_rate / 100) / 365 * 30
                         FROM deposits d
                         JOIN deposit_plan dp ON d.plan_id = dp.id
                         WHERE d.id = 1) AS INTEGER)
WHERE account_type_id = 1 AND type_id = 3;

UPDATE accounts
SET balance = balance - CAST((SELECT d.amount * (dp.interest_rate / 100) / 365 * 30
                         FROM deposits d
                         JOIN deposit_plan dp ON d.plan_id = dp.id
                         WHERE d.id = 1) AS INTEGER)
WHERE id = 0;

UPDATE deposits
SET amount = amount + CAST((SELECT d.amount * (dp.interest_rate / 100) / 365 * 30
                       FROM deposits d
                       JOIN deposit_plan dp ON d.plan_id = dp.id
                       WHERE d.id = 1) AS INTEGER)
WHERE id = 1;

COMMIT;

-- Вывод для просмотра изменений
SELECT 'СЧЕТ КЛИЕНТА' AS type, id, balance FROM accounts WHERE account_type_id = 1 AND type_id = 3
UNION ALL
SELECT 'СИСТЕМНЫЙ СЧЕТ', id, balance FROM accounts WHERE id = 0
UNION ALL
SELECT 'ВКЛАД', id, amount FROM deposits WHERE id = 1
UNION ALL
SELECT 'ТРАНЗАКЦИЯ', id, amount FROM transactions WHERE id = (SELECT MAX(id) FROM transactions)
UNION ALL
SELECT 'ПРОВОДКИ', transaction_id, amount FROM ledger_entries WHERE transaction_id = (SELECT MAX(id) FROM transactions);