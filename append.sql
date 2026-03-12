-- Оплата кредитного платежа

-- Вывод для просмотра изменений
SELECT 'СЧЕТ КЛИЕНТА' AS type, id, balance FROM accounts WHERE id = (SELECT repayment_account_id FROM credits WHERE id = 1)
UNION ALL
SELECT 'СИСТЕМНЫЙ СЧЕТ', id, balance FROM accounts WHERE id = 0
UNION ALL
SELECT 'КРЕДИТ (ОСТАТОК)', id, remaining_amount FROM credits WHERE id = 1
UNION ALL
SELECT 'ПЛАТЕЖ В ГРАФИКЕ', payment_number, (SELECT name FROM payment_status WHERE id = status_id) FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1
UNION ALL
SELECT 'ТРАНЗАКЦИЯ', id, amount FROM transactions WHERE transaction_uuid = '33333333-4444-5555-6666-777777777777'
UNION ALL
SELECT 'ПРОВОДКИ', transaction_id, amount FROM ledger_entries WHERE transaction_id = (SELECT id FROM transactions WHERE transaction_uuid = '33333333-4444-5555-6666-777777777777');

BEGIN TRANSACTION;

INSERT INTO transactions (transaction_uuid, type_id, status_id, amount, currency_id, created_at)
SELECT '33333333-4444-5555-6666-777777777777', 2, 2, total_amount, 1, CURRENT_TIMESTAMP
FROM credit_payment_schedule
WHERE credit_id = 1 AND payment_number = 1;

INSERT INTO ledger_entries (transaction_id, account_id, amount)
VALUES (
    (SELECT id FROM transactions WHERE transaction_uuid = '33333333-4444-5555-6666-777777777777'),
    (SELECT repayment_account_id FROM credits WHERE id = 1),
    - (SELECT total_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1)
);

INSERT INTO ledger_entries (transaction_id, account_id, amount)
VALUES (
    (SELECT id FROM transactions WHERE transaction_uuid = '33333333-4444-5555-6666-777777777777'),
    0,
    (SELECT total_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1)
);

UPDATE accounts
SET balance = balance - (SELECT total_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1)
WHERE id = (SELECT repayment_account_id FROM credits WHERE id = 1);

UPDATE accounts
SET balance = balance + (SELECT total_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1)
WHERE id = 0;

UPDATE credits
SET remaining_amount = remaining_amount - (SELECT principal_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1)
WHERE id = 1;

UPDATE credit_payment_schedule
SET status_id = (SELECT id FROM payment_status WHERE name = 'complete'),
    paid_date = CURRENT_DATE,
    paid_amount = (SELECT total_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1)
WHERE credit_id = 1 AND payment_number = 1;

INSERT INTO credit_payments (
    credit_id, payment_date, amount, principal_paid, interest_paid,
    late_fee_paid, schedule_id, transaction_id, receipt_number
)
VALUES (
    1,
    CURRENT_DATE,
    (SELECT total_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1),
    (SELECT principal_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1),
    (SELECT interest_amount FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1),
    0,
    (SELECT id FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1),
    (SELECT id FROM transactions WHERE transaction_uuid = '33333333-4444-5555-6666-777777777777'),
    'PAY-001'
);

COMMIT;

-- Вывод для просмотра изменений
SELECT 'СЧЕТ КЛИЕНТА' AS type, id, balance FROM accounts WHERE id = (SELECT repayment_account_id FROM credits WHERE id = 1)
UNION ALL
SELECT 'СИСТЕМНЫЙ СЧЕТ', id, balance FROM accounts WHERE id = 0
UNION ALL
SELECT 'КРЕДИТ (ОСТАТОК)', id, remaining_amount FROM credits WHERE id = 1
UNION ALL
SELECT 'ПЛАТЕЖ В ГРАФИКЕ', payment_number, (SELECT name FROM payment_status WHERE id = status_id) FROM credit_payment_schedule WHERE credit_id = 1 AND payment_number = 1
UNION ALL
SELECT 'ТРАНЗАКЦИЯ', id, amount FROM transactions WHERE transaction_uuid = '33333333-4444-5555-6666-777777777777'
UNION ALL
SELECT 'ПРОВОДКИ', transaction_id, amount FROM ledger_entries WHERE transaction_id = (SELECT id FROM transactions WHERE transaction_uuid = '33333333-4444-5555-6666-777777777777');