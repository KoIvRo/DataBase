-- Транзакция пополнения баланса

-- Выведем счет
SELECT a.ID, a.balance, p.name AS plan
FROM accounts AS a
JOIN account_plans AS p ON a.plan_id = p.ID
JOIN client_accounts AS ca ON ca.account_id = a.ID
JOIN clients AS c ON ca.client_id == c.ID
WHERE a.ID == 1;

BEGIN TRANSACTION;
INSERT INTO transactions (type_id) VALUES (1); -- transfer

INSERT INTO ledger_entries (transaction_id, account_id, amount) VALUES
    ((SELECT MAX(ID) FROM transactions), 1, 1000),
    ((SELECT MAX(ID) FROM transactions), 0, -1000);

UPDATE accounts SET balance = balance + 1000 WHERE ID == 1;

UPDATE accounts SET balance = balance - 1000 WHERE ID == 0;

COMMIT;

-- Посмотрим на счет
SELECT a.ID, a.balance, p.name AS plan
FROM accounts AS a
JOIN account_plans AS p ON a.plan_id = p.ID
JOIN client_accounts AS ca ON ca.account_id = a.ID
JOIN clients AS c ON ca.client_id == c.ID
WHERE a.ID == 1;

-- Проверим не пропали ли деньги
SELECT SUM(amount) AS sum_transaction
FROM ledger_entries
WHERE transaction_id = (SELECT MAX(ID) FROM transactions); -- Мы можем так делать так как уровень изоляции serialize
