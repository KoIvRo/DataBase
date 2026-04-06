-- 2. Погашение кредита клиентом
-- Клиент: Иван Коротаев погашает очередной платеж по кредиту id=1

-- Смотрим непогашенные платежи по графику
SELECT id, payment_number, total_amount, status_id, paid_date
FROM Credit_Payment_Schedules
WHERE credit_id = 1
ORDER BY payment_number;

-- Смотрим остаток по кредиту
SELECT id, remaining_amount, principal_amount
FROM Credits
WHERE id = 1;

-- Смотрим баланс счета клиента
SELECT account_id, available_balance, balance
FROM Account_Balances
WHERE account_id = (SELECT repayment_account_id FROM Credits WHERE id = 1)
ORDER BY updated_at DESC
LIMIT 1;

-- Смотрим историю транзакций
SELECT id, transaction_uuid, type_id, amount, status_id
FROM Transactions
ORDER BY id DESC
LIMIT 5;

BEGIN TRANSACTION;

-- 2.1 Находим следующий непогашенный платеж
CREATE TEMP TABLE temp_payment AS
SELECT
    id AS schedule_id,
    credit_id,
    total_amount,
    principal_amount
FROM Credit_Payment_Schedules
WHERE credit_id = 1 AND status_id = 1
ORDER BY payment_number
LIMIT 1;

-- 2.2 Создаем транзакцию
INSERT INTO Transactions (
    transaction_uuid, type_id, status_id, amount,
    currency_id, mcc_id, created_at, completed_at
) VALUES (
    random(),
    6, 2, (SELECT total_amount FROM temp_payment),
    1, 5411, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- 2.3 Получаем ID новой транзакции
-- Сохраняем в переменную через временную таблицу
CREATE TEMP TABLE temp_transaction_id AS
SELECT last_insert_rowid() AS trans_id;

-- 2.4 Записываем отправителя (счет клиента)
INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id)
SELECT trans_id, (SELECT repayment_account_id FROM Credits WHERE id = 1), 2
FROM temp_transaction_id;

-- 2.5 Записываем получателя (кредитный счет)
INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id)
SELECT trans_id, (SELECT loan_account_id FROM Credits WHERE id = 1), 1
FROM temp_transaction_id;

-- 2.6 Проводка для счета клиента (списание)
INSERT INTO Ledger_Entries (transaction_id, account_id, credit, debit)
SELECT
    trans_id,
    (SELECT repayment_account_id FROM Credits WHERE id = 1),
    (SELECT total_amount FROM temp_payment),
    0
FROM temp_transaction_id;

-- 2.7 Проводка для кредитного счета (зачисление)
INSERT INTO Ledger_Entries (transaction_id, account_id, credit, debit)
SELECT
    trans_id,
    (SELECT loan_account_id FROM Credits WHERE id = 1),
    0,
    (SELECT total_amount FROM temp_payment)
FROM temp_transaction_id;

-- 2.8 Записываем платеж
INSERT INTO Credit_Payments (
    credit_id, payment_date, amount,
    principal_paid, interest_paid, schedule_id, transaction_id
)
SELECT
    credit_id,
    CURRENT_DATE,
    total_amount,
    principal_amount,
    total_amount - principal_amount,
    schedule_id,
    (SELECT trans_id FROM temp_transaction_id)
FROM temp_payment;

-- 2.9 Обновляем статус платежа в графике
UPDATE Credit_Payment_Schedules
SET
    status_id = 2,
    paid_date = CURRENT_DATE,
    paid_amount = (SELECT total_amount FROM temp_payment)
WHERE id = (SELECT schedule_id FROM temp_payment);

-- 2.10 Обновляем остаток по кредиту
UPDATE Credits
SET remaining_amount = remaining_amount - (SELECT principal_amount FROM temp_payment)
WHERE id = 1;

-- 2.11 Получаем текущий баланс счета клиента
CREATE TEMP TABLE temp_current_balance AS
SELECT available_balance, balance
FROM Account_Balances
WHERE account_id = (SELECT repayment_account_id FROM Credits WHERE id = 1)
ORDER BY updated_at DESC
LIMIT 1;

-- 2.12 Обновляем баланс счета клиента
INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at)
SELECT
    (SELECT repayment_account_id FROM Credits WHERE id = 1),
    (SELECT available_balance FROM temp_current_balance) - (SELECT total_amount FROM temp_payment),
    (SELECT balance FROM temp_current_balance) - (SELECT total_amount FROM temp_payment),
    CURRENT_TIMESTAMP;

-- 2.13 Удаляем временные таблицы
DROP TABLE temp_payment;
DROP TABLE temp_transaction_id;
DROP TABLE temp_current_balance;

COMMIT;

-- Смотрим, что изменилось

-- Смотрим непогашенные платежи по графику
SELECT id, payment_number, total_amount, status_id, paid_date
FROM Credit_Payment_Schedules
WHERE credit_id = 1
ORDER BY payment_number;

-- Смотрим остаток по кредиту
SELECT id, remaining_amount, principal_amount
FROM Credits
WHERE id = 1;

-- Смотрим новый баланс счета клиента
SELECT account_id, available_balance, balance
FROM Account_Balances
WHERE account_id = (SELECT repayment_account_id FROM Credits WHERE id = 1)
ORDER BY updated_at DESC
LIMIT 1;

-- Смотрим историю транзакций
SELECT id, transaction_uuid, type_id, amount, status_id
FROM Transactions
ORDER BY id DESC
LIMIT 5;

-- Смотрим платеж по кредиту
SELECT id, credit_id, payment_date, amount, principal_paid, interest_paid, schedule_id
FROM Credit_Payments
ORDER BY id DESC
LIMIT 1;

-- Смотрим стороны транзакции
SELECT tp.transaction_id, tp.account_id, tp.direction_id, a.client_id
FROM Transaction_Parties tp
JOIN Accounts a ON tp.account_id = a.id
ORDER BY tp.id DESC
LIMIT 2;

-- Смотрим проводки
SELECT transaction_id, account_id, credit, debit
FROM Ledger_Entries
ORDER BY id DESC
LIMIT 2;
