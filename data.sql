-- contact_type
INSERT INTO Contact_Type (id, name) VALUES
(1, 'telephone'),
(2, 'email'),
(3, 'tg');

-- document_type
INSERT INTO Document_Type (id, name) VALUES
(1, 'passport'),
(2, 'snils'),
(3, 'inn');

-- employment_status
INSERT INTO Employment_Status (id, name) VALUES
(1, 'employed'),
(2, 'self_employed'),
(3, 'business'),
(4, 'unemployed');

-- kyc_status
INSERT INTO Kyc_Status (id, name) VALUES
(1, 'pending'),
(2, 'rejected'),
(3, 'edd');

-- aml_status
INSERT INTO Aml_Status (id, name) VALUES
(1, 'low'),
(2, 'medium'),
(3, 'high');

-- account_status
INSERT INTO Account_Status (id, name) VALUES
(1, 'open'),
(2, 'closed'),
(3, 'blocked'),
(4, 'frozen');

-- currency
INSERT INTO Currency (id, name) VALUES
(1, 'RUB'),
(2, 'USD'),
(3, 'EUR');

-- transaction_status
INSERT INTO Transaction_Status (id, name) VALUES
(1, 'pending'),
(2, 'completed'),
(3, 'failed'),
(4, 'cancelled'),
(5, 'reversed');

-- transaction_types
INSERT INTO Transaction_Types (id, code) VALUES
(1, 'internal_transfer'),
(2, 'interbank_transfer'),
(3, 'card_payment'),
(4, 'deposit_open'),
(5, 'deposit_interest'),
(6, 'credit_payment'),
(7, 'cashback_accrual');

-- directions
INSERT INTO Directions (id, name) VALUES
(1, 'in'),
(2, 'out');

-- payment_status
INSERT INTO Payment_Status (id, name) VALUES
(1, 'pending'),
(2, 'completed'),
(3, 'overdue'),
(4, 'partial');

-- authorization_status
INSERT INTO Authorization_Status (id, name) VALUES
(1, 'authorized'),
(2, 'captured'),
(3, 'expired'),
(4, 'voided');

-- card_status
INSERT INTO Card_Status (id, status_code) VALUES
(1, 'active'),
(2, 'blocked'),
(3, 'expired'),
(4, 'lost');

-- card_category
INSERT INTO Card_Category (id, name) VALUES
(1, 'standard'),
(2, 'silver'),
(3, 'gold');

-- deposit_status
INSERT INTO Deposit_Status (id, name) VALUES
(1, 'active'),
(2, 'closed'),
(3, 'early_closed');

-- deposit_plan
INSERT INTO Deposit_Plan (id, name, count_month, minimal_amount, early_withdrawal_rate, early_withdrawal_fee, interest_rate) VALUES
(1, 'Накопительный', 6, 50000, 0.01, 500, 8.5),
(2, 'Срочный', 12, 100000, 0.5, 1000, 9.5);

-- credit_status
INSERT INTO Credit_Status (id, name) VALUES
(1, 'active'),
(2, 'closed'),
(3, 'overdue'),
(4, 'restructured'),
(5, 'approved'),
(6, 'rejected');

-- credit_plans
INSERT INTO Credit_Plans (id, name, interest_rate, min_amount, max_amount, min_term_months, max_term_months, late_payment_fee, requires_collateral, requires_income_proof, requires_credit_history, is_active) VALUES
(1, 'Потребительский кредит', 15.5, 50000, 1000000, 6, 60, 500, 0, 1, 1, 1),
(2, 'Кредитная карта', 25.0, 10000, 500000, 1, 36, 300, 0, 0, 0, 1);

-- mcc_codes
INSERT INTO Mcc_Codes (id, description) VALUES
(5411, 'Продуктовые магазины и супермаркеты'),
(5812, 'Рестораны, кафе, столовые'),
(5541, 'Автозаправочные станции'),
(5814, 'Фастфуд и рестораны быстрого питания'),
(5691, 'Одежда и аксессуары'),
(5732, 'Электроника и бытовая техника');

-- banks
INSERT INTO Banks (id, name) VALUES
(123456789, 'Т-Банк'),
(987654321, 'Сбербанк'),
(456789123, 'Альфа-Банк');

-- Добавление системного пользователя
INSERT INTO Clients (id, first_name, middle_name, last_name, password_hash, birth_date, created_at)
VALUES (0, 'SYSTEM', NULL, 'SYSTEM', 'system_hash', '1970-01-01', CURRENT_DATE);

-- Основные клиенты
INSERT INTO Clients (id, first_name, middle_name, last_name, password_hash, birth_date, created_at) VALUES
(1, 'Иван', 'Романович', 'Коротаев', 'hash1234567890', '1990-01-01', CURRENT_DATE),
(2, 'Ярослав', 'Романович', 'Романов', 'hash0987654321', '1985-05-15', CURRENT_DATE),
(3, 'Анна', 'Сергеевна', 'Сидорова', 'hash1122334455', '1995-03-20', CURRENT_DATE),
(4, 'Михаил', 'Алексеевич', 'Кузнецов', 'hash5544332211', '1988-07-10', CURRENT_DATE);

-- client_contacts
INSERT INTO Client_Contacts (client_id, contact_type_id, contact_value, is_verified) VALUES
(1, 1, '+79161234567', 1),
(1, 2, 'ivan@email.com', 1),
(1, 3, '@ivan_ivanov', 1),
(2, 1, '+79169876543', 1),
(2, 2, 'petr@email.com', 1),
(3, 1, '+79261112233', 1),
(3, 2, 'anna@email.com', 1),
(4, 1, '+79264445566', 1),
(4, 2, 'mikhail@email.com', 0);

-- client_documents
INSERT INTO Client_Documents (client_id, document_type_id, document_value, expire_at) VALUES
(1, 1, '4510 123456', '2030-01-01'),
(1, 2, '123-456-789 01', NULL),
(1, 3, '123456789012', NULL),
(2, 1, '4510 654321', '2032-05-15'),
(2, 3, '987654321098', NULL),
(3, 1, '4510 111222', '2035-03-20'),
(3, 2, '987-654-321 01', NULL),
(4, 1, '4510 333444', '2031-07-10'),
(4, 3, '555666777888', NULL);

-- client_employment
INSERT INTO Client_Employment (client_id, status_id, monthly_income, currency_id, is_verified) VALUES
(1, 1, 100000, 1, 1),
(2, 1, 150000, 1, 1),
(3, 2, 80000, 1, 1),
(4, 3, 200000, 1, 0);

-- client_addresses
INSERT INTO Client_Addresses (client_id, is_resident, city, country) VALUES
(1, 1, 'Москва', 'Россия'),
(2, 1, 'Санкт-Петербург', 'Россия'),
(3, 1, 'Казань', 'Россия'),
(4, 0, 'Минск', 'Беларусь');

-- client_verifications
INSERT INTO Client_Verifications (client_id, kyc_status_id, aml_status_id, verified_at) VALUES
(1, 1, 1, CURRENT_DATE),
(2, 1, 1, CURRENT_DATE),
(3, 1, 1, CURRENT_DATE),
(4, 2, 2, NULL);

-- Добавление системного счета
INSERT INTO Accounts (id, client_id, status_id, currency_id, created_at)
VALUES (0, 0, 1, 1, CURRENT_DATE);

-- Счета для клиентов
INSERT INTO Accounts (id, client_id, status_id, currency_id, created_at) VALUES
-- Иван: дебетовые и кредитные счета
(1, 1, 1, 1, CURRENT_DATE),  -- основной рублевый счет
(2, 1, 1, 2, CURRENT_DATE),  -- валютный счет USD
(3, 1, 1, 1, CURRENT_DATE),  -- накопительный счет
(4, 1, 1, 1, CURRENT_DATE),  -- кредитный счет

-- Петр: счета
(5, 2, 1, 1, CURRENT_DATE),  -- основной рублевый счет
(6, 2, 1, 1, CURRENT_DATE),  -- накопительный счет
(7, 2, 1, 1, CURRENT_DATE),  -- счет для вклада

-- Анна: счета
(8, 3, 1, 1, CURRENT_DATE),  -- основной рублевый счет
(9, 3, 1, 1, CURRENT_DATE),  -- накопительный счет

-- Михаил: счета
(10, 4, 3, 1, CURRENT_DATE); -- заблокированный счет

-- account_balances (начальные балансы)
INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at) VALUES
-- Иван
(1, 500000, 500000, CURRENT_TIMESTAMP),
(2, 10000, 10000, CURRENT_TIMESTAMP),
(3, 200000, 200000, CURRENT_TIMESTAMP),
(4, 0, 0, CURRENT_TIMESTAMP),

-- Петр
(5, 1000000, 1000000, CURRENT_TIMESTAMP),
(6, 300000, 300000, CURRENT_TIMESTAMP),
(7, 500000, 500000, CURRENT_TIMESTAMP),

-- Анна
(8, 250000, 250000, CURRENT_TIMESTAMP),
(9, 100000, 100000, CURRENT_TIMESTAMP),

-- Михаил
(10, 0, 0, CURRENT_TIMESTAMP);

INSERT INTO Cards (account_id, card_category_id, status_id, card_number_hash, card_number_last4,
                   card_holder_name, expiration_month, expiration_year, cvv_hash,
                   issued_date, activated_date, pin_attempts) VALUES
-- Карты Ивана
(1, 2, 1, 'hash_5125121234567890', '7890', 'IVAN IVANOV', 12, 2028, 'cvv_hash_123',
 CURRENT_DATE, CURRENT_DATE, 0),
(1, 3, 1, 'hash_5125129876543210', '3210', 'IVAN IVANOV', 12, 2029, 'cvv_hash_456',
 CURRENT_DATE, CURRENT_DATE, 0),

-- Карты Петра
(5, 2, 1, 'hash_51251255556666', '6666', 'PETR PETROV', 10, 2027, 'cvv_hash_789',
 CURRENT_DATE, CURRENT_DATE, 0),
(5, 3, 1, 'hash_51251277778888', '8888', 'PETR PETROV', 10, 2028, 'cvv_hash_012',
 CURRENT_DATE, CURRENT_DATE, 0),

-- Карты Анны
(8, 1, 1, 'hash_51251299990000', '0000', 'ANNA SIDOROVA', 5, 2026, 'cvv_hash_345',
 CURRENT_DATE, CURRENT_DATE, 2);

INSERT INTO Deposits (account_id, plan_id, status_id, amount, start_date, end_date, partial_withdrawal_allowed) VALUES
-- Вклад Ивана
(3, 1, 1, 200000, CURRENT_DATE, DATE(CURRENT_DATE, '+6 months'), 1),

-- Вклад Петра
(7, 2, 1, 500000, CURRENT_DATE, DATE(CURRENT_DATE, '+12 months'), 0);

INSERT INTO Credits (credit_number, plan_id, status_id, currency_id,
                     loan_account_id, repayment_account_id,
                     principal_amount, remaining_amount,
                     issued_date, end_date, payment_due_day, created_at) VALUES
-- Кредит Ивана
('CRED-2024-0001', 1, 1, 1, 4, 1, 500000, 500000,
 CURRENT_DATE, DATE(CURRENT_DATE, '+36 months'), 10, CURRENT_TIMESTAMP),

-- Кредит Анны
('CRED-2024-0002', 2, 1, 1, 9, 8, 100000, 100000,
 CURRENT_DATE, DATE(CURRENT_DATE, '+12 months'), 15, CURRENT_TIMESTAMP);

-- credit_payment_schedules
INSERT INTO Credit_Payment_Schedules (credit_id, status_id, payment_number, due_date,
                                       principal_amount, interest_amount, total_amount,
                                       remaining_balance, paid_date, paid_amount) VALUES
-- График для кредита Ивана (3 платежа)
(1, 1, 1, DATE(CURRENT_DATE, '+1 month'), 13889, 6458, 20347, 486111, NULL, NULL),
(1, 1, 2, DATE(CURRENT_DATE, '+2 months'), 13889, 6458, 20347, 472222, NULL, NULL),
(1, 1, 3, DATE(CURRENT_DATE, '+3 months'), 13889, 6458, 20347, 458333, NULL, NULL),

-- График для кредита Анны (3 платежа)
(2, 1, 1, DATE(CURRENT_DATE, '+1 month'), 8333, 2083, 10416, 91667, NULL, NULL),
(2, 1, 2, DATE(CURRENT_DATE, '+2 months'), 8333, 2083, 10416, 83334, NULL, NULL),
(2, 1, 3, DATE(CURRENT_DATE, '+3 months'), 8333, 2083, 10416, 75001, NULL, NULL);

-- 1. Внутренний перевод между счетами Ивана
INSERT INTO Transactions (transaction_uuid, type_id, status_id, amount, currency_id, mcc_id, created_at, completed_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 1, 2, 50000, 1, 5411,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id) VALUES
(1, 1, 2),  -- источник (out)
(1, 3, 1);  -- назначение (in)

INSERT INTO Ledger_Entries (transaction_id, account_id, credit, debit) VALUES
(1, 1, 50000, 0),   -- списание с основного счета
(1, 3, 0, 50000);   -- зачисление на накопительный

INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at) VALUES
(1, 450000, 450000, CURRENT_TIMESTAMP),
(3, 250000, 250000, CURRENT_TIMESTAMP);

-- 2. Межбанковский перевод от Ивана в Т-Банк
INSERT INTO Transactions (transaction_uuid, type_id, status_id, amount, currency_id, mcc_id, created_at, completed_at) VALUES
('660e8400-e29b-41d4-a716-446655440002', 2, 2, 10000, 1, 5411,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Transaction_Parties (transaction_id, account_id, external_account_number, bank_id, direction_id) VALUES
(2, 1, NULL, NULL, 2),  -- источник (наш клиент)
(2, NULL, '2200123456789012', 123456789, 1);  -- назначение (Т-Банк)

INSERT INTO Ledger_Entries (transaction_id, account_id, credit, debit) VALUES
(2, 1, 10000, 0);  -- списание с клиента

INSERT INTO Interbank_Settlements (transaction_id, bank_id, direction_id, amount, settlement_date) VALUES
(2, 123456789, 2, 10000, CURRENT_DATE);

INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at) VALUES
(1, 440000, 440000, CURRENT_TIMESTAMP);

-- 3. Карточный платеж Петра в супермаркете (MCC 5411)
INSERT INTO Transactions (transaction_uuid, type_id, status_id, amount, currency_id, mcc_id, created_at, completed_at) VALUES
('770e8400-e29b-41d4-a716-446655440003', 3, 2, 3500, 1, 5411,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id) VALUES
(3, 5, 2);  -- списание со счета Петра

INSERT INTO Ledger_Entries (transaction_id, account_id, credit, debit) VALUES
(3, 5, 3500, 0);  -- списание

INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at) VALUES
(5, 996500, 996500, CURRENT_TIMESTAMP);

-- 4. Кредитный платеж Ивана (погашение кредита)
INSERT INTO Transactions (transaction_uuid, type_id, status_id, amount, currency_id, mcc_id, created_at, completed_at) VALUES
('880e8400-e29b-41d4-a716-446655440004', 6, 2, 20347, 1, 5732,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id) VALUES
(4, 1, 2),  -- списание с основного счета
(4, 4, 1);  -- зачисление на кредитный счет

INSERT INTO Ledger_Entries (transaction_id, account_id, credit, debit) VALUES
(4, 1, 20347, 0),   -- списание
(4, 4, 0, 20347);   -- зачисление

INSERT INTO Credit_Payments (credit_id, payment_date, amount, principal_paid, interest_paid, schedule_id, transaction_id) VALUES
(1, CURRENT_DATE, 20347, 13889, 6458, 1, 4);

UPDATE Credit_Payment_Schedules
SET status_id = 2, paid_date = CURRENT_DATE, paid_amount = 20347
WHERE id = 1;

UPDATE Credits SET remaining_amount = remaining_amount - 13889 WHERE id = 1;

INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at) VALUES
(1, 419653, 419653, CURRENT_TIMESTAMP),
(4, 20347, 20347, CURRENT_TIMESTAMP);

-- 5. Начисление процентов по вкладу Ивана
INSERT INTO Transactions (transaction_uuid, type_id, status_id, amount, currency_id, mcc_id, created_at, completed_at) VALUES
('990e8400-e29b-41d4-a716-446655440005', 5, 2, 1417, 1, 5411,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id) VALUES
(5, 3, 1);  -- зачисление на накопительный счет

INSERT INTO Ledger_Entries (transaction_id, account_id, debit) VALUES
(5, 3, 1417);

INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at) VALUES
(3, 251417, 251417, CURRENT_TIMESTAMP);

-- 6. Карточная авторизация (холд) для Анны
INSERT INTO Transactions (transaction_uuid, type_id, status_id, amount, currency_id, mcc_id, created_at) VALUES
('aa0e8400-e29b-41d4-a716-446655440006', 3, 1, 15000, 1, 5812,
 CURRENT_TIMESTAMP);  -- pending (холд)

INSERT INTO Transaction_Parties (transaction_id, account_id, direction_id) VALUES
(6, 8, 2);

INSERT INTO Card_Authorizations (card_id, transaction_id, status_id, amount, created_at, expires_at) VALUES
(5, 6, 1, 15000, CURRENT_TIMESTAMP, DATETIME('now', '+7 days'));

-- 7. Клиринг по карточной авторизации Анны
INSERT INTO Clearing_Transactions (authorization_id, transaction_id, external_bank, amount, settlement_date) VALUES
(1, 6, 'AcquiringBank', 15000, CURRENT_DATE);

-- Обновляем статус авторизации и транзакции
UPDATE Card_Authorizations SET status_id = 2 WHERE id = 1;  -- captured
UPDATE Transactions SET status_id = 2, completed_at = CURRENT_TIMESTAMP WHERE id = 6;

INSERT INTO Ledger_Entries (transaction_id, account_id, credit) VALUES
(6, 8, 15000);

INSERT INTO Account_Balances (account_id, available_balance, balance, updated_at) VALUES
(8, 235000, 235000, CURRENT_TIMESTAMP);
