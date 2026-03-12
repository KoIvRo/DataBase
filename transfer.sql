-- Перевод между счетами

SELECT
    a.id AS account_id,
    a.balance,
    c.first_name || ' ' || c.last_name AS client_name
FROM accounts a
JOIN clients c ON a.client_id = c.id
WHERE a.type_id = (SELECT id FROM account_types WHERE name = 'debit')
ORDER BY a.id;

-- Выполняем перевод
BEGIN TRANSACTION;

INSERT INTO transactions (transaction_uuid, type_id, status_id, amount, currency_id, created_at)
VALUES (
    '11111111-2222-3333-4444-555555555555',
    (SELECT id FROM transaction_types WHERE code = 'transfer'),
    (SELECT id FROM transaction_status WHERE name = 'completed'),
    5000,
    (SELECT currency_id FROM accounts WHERE id = 1),
    CURRENT_TIMESTAMP
);

INSERT INTO ledger_entries (transaction_id, account_id, amount) VALUES
    ((SELECT MAX(id) FROM transactions), 1, -5000),
    ((SELECT MAX(id) FROM transactions), 3, 5000);

UPDATE accounts SET balance = balance - 5000 WHERE id = 1;
UPDATE accounts SET balance = balance + 5000 WHERE id = 3;

COMMIT;

-- Проверим результат
SELECT
    a.id AS account_id,
    a.balance,
    c.first_name || ' ' || c.last_name AS client_name
FROM accounts a
JOIN clients c ON a.client_id = c.id
WHERE a.type_id = (SELECT id FROM account_types WHERE name = 'debit')
ORDER BY a.id;

-- Проверим баланс транзакций
SELECT
    SUM(amount) AS balance_check
FROM ledger_entries
WHERE transaction_id = (SELECT MAX(id) FROM transactions);
