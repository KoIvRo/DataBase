-- Перевод между счетами

-- Выведем все счета с которых можно переводить
SELECT a.ID, a.balance
FROM accounts AS a
JOIN account_plans AS p ON p.ID == a.plan_id
JOIN account_types as t ON p.type_id == t.ID
WHERE t.type == "debit" OR t.type == "saving";

BEGIN TRANSACTION;
INSERT INTO transactions (type_id) VALUES (3);

INSERT INTO ledger_entries (transaction_id, account_id, amount) VALUES
    ((SELECT MAX(ID) FROM transactions), 1, 5000),
    ((SELECT MAX(ID) FROM transactions), 3, -5000);

UPDATE accounts SET balance = balance + 5000 WHERE ID == 1;

UPDATE accounts SET balance = balance - 5000 WHERE ID == 3;

COMMIT;

-- Проверим результат
SELECT a.ID, a.balance
FROM accounts AS a
JOIN account_plans AS p ON p.ID == a.plan_id
JOIN account_types as t ON p.type_id == t.ID
WHERE t.type == "debit" OR t.type == "saving";

SELECT SUM(amount) AS sum_transaction
FROM ledger_entries
WHERE transaction_id = (SELECT MAX(ID) FROM transactions);