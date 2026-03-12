    -- contact_type
    INSERT INTO contact_type (id, name) VALUES
    (1, 'telephone'),
    (2, 'email'),
    (3, 'tg');

    -- document_type
    INSERT INTO document_type (id, name) VALUES
    (1, 'passport'),
    (2, 'snils'),
    (3, 'inn');

    -- employment_status
    INSERT INTO employment_status (id, name) VALUES
    (1, 'employed'),
    (2, 'self_employed'),
    (3, 'business'),
    (4, 'unemployed');

    -- kyc_status
    INSERT INTO kyc_status (id, name) VALUES
    (1, 'pending'),
    (2, 'rejected'),
    (3, 'edd');

    -- aml_status
    INSERT INTO aml_status (id, name) VALUES
    (1, 'low'),
    (2, 'medium'),
    (3, 'high');

    -- account_status
    INSERT INTO account_status (id, name) VALUES
    (1, 'open'),
    (2, 'closed'),
    (3, 'blocked'),
    (4, 'frozen');

    -- currency
    INSERT INTO currency (id, name) VALUES
    (1, 'RUB'),
    (2, 'USD'),
    (3, 'EUR');

    -- account_types
    INSERT INTO account_types (id, name) VALUES
    (1, 'debit'),
    (2, 'credit'),
    (3, 'deposit');

    -- transaction_status
    INSERT INTO transaction_status (id, name) VALUES
    (1, 'pending'),
    (2, 'completed'),
    (3, 'failed'),
    (4, 'cancelled'),
    (5, 'reversed');

    -- transaction_types
    INSERT INTO transaction_types (id, code) VALUES
    (1, 'deposit'),
    (2, 'withdrawal'),
    (3, 'transfer'),
    (4, 'interest'),
    (5, 'fee');

    -- debit_plans
    INSERT INTO debit_plans (id, monthly_fee, interest_rate, transfer_fee) VALUES
    (1, 0, 0.01, 0),
    (2, 99, 0.05, 0.5);

    -- deposit_status
    INSERT INTO deposit_status (id, name) VALUES
    (1, 'active'),
    (2, 'closed'),
    (3, 'early_closed');

    -- deposit_plan
    INSERT INTO deposit_plan (id, name, count_month, minimal_amount, early_withdrawal_rate, early_withdrawal_fee, interest_rate) VALUES
    (1, 'Накопительный', 6, 50000, 0.01, 500, 8.5),
    (2, 'Срочный', 12, 100000, 0.5, 1000, 9.5);

    -- credit_status
    INSERT INTO credit_status (id, name) VALUES
    (1, 'active'),
    (2, 'closed'),
    (3, 'overdue'),
    (4, 'approved'),
    (5, 'rejected');

    -- credit_plans
    INSERT INTO credit_plans (id, name, interest_rate, min_amount, max_amount, min_term_months, max_term_months, late_payment_fee, requires_collateral, requires_income_proof, requires_credit_history, is_active) VALUES
    (1, 'Потребительский кредит', 15.5, 50000, 1000000, 6, 60, 500, 0, 1, 1, 1),
    (2, 'Кредитная карта', 25.0, 10000, 500000, 1, 36, 300, 0, 0, 0, 1);

    -- card_type
    INSERT INTO card_type (id, type_code) VALUES
    (1, 'visa_classic'),
    (2, 'mastercard_gold'),
    (3, 'mir');

    -- card_status
    INSERT INTO card_status (id, status_code) VALUES
    (1, 'active'),
    (2, 'blocked'),
    (3, 'expired'),
    (4, 'lost');

    -- card_category
    INSERT INTO card_category (id, name) VALUES
    (1, 'standard'),
    (2, 'silver'),
    (3, 'gold');

    -- clients
    INSERT INTO clients (id, first_name, middle_name, last_name, password_hash, birth_date, created_at) VALUES
    (1, 'Иван', 'Иванович', 'Иванов', 'hash1234567890', '1990-01-01', CURRENT_DATE),
    (2, 'Петр', 'Петрович', 'Петров', 'hash0987654321', '1985-05-15', CURRENT_DATE);

    -- client_contacts
    INSERT INTO client_contacts (id, client_id, contact_type_id, contact_value, is_verified) VALUES
    (1, 1, 1, '+79161234567', 1),
    (2, 1, 2, 'ivan@email.com', 1),
    (3, 2, 1, '+79169876543', 1),
    (4, 2, 2, 'petr@email.com', 1);

    -- client_documents
    INSERT INTO client_documents (id, client_id, document_type_id, document_value, expire_at) VALUES
    (1, 1, 1, '4510 123456', '2030-01-01'),
    (2, 1, 2, '123-456-789 01', NULL),
    (3, 2, 1, '4510 654321', '2032-05-15'),
    (4, 2, 3, '123456789012', NULL);

    -- client_employee
    INSERT INTO client_employee (id, client_id, status_id, monthly_income, income_currency, is_verified) VALUES
    (1, 1, 1, 100000, 'RUB', 1),
    (2, 2, 1, 150000, 'RUB', 1);

    -- client_address
    INSERT INTO client_address (id, client_id, is_resident, city, country) VALUES
    (1, 1, 1, 'Москва', 'Россия'),
    (2, 2, 1, 'Санкт-Петербург', 'Россия');

    -- client_verification
    INSERT INTO client_verification (id, client_id, kyc_status_id, aml_status_id, verified_at) VALUES
    (1, 1, 1, 1, CURRENT_DATE),
    (2, 2, 1, 1, CURRENT_DATE);

    -- accounts (для Ивана: дебетовый и кредитный)
    INSERT INTO accounts (id, client_id, balance, status_id, currency_id, type_id, account_type_id, created_at) VALUES
    (1, 1, 500000, 1, 1, 1, 1, CURRENT_DATE),  -- дебетовый счет
    (2, 1, 100000, 1, 1, 2, 1, CURRENT_DATE);  -- кредитный счет

    -- accounts (для Петра: дебетовый и вклад)
    INSERT INTO accounts (id, client_id, balance, status_id, currency_id, type_id, account_type_id, created_at) VALUES
    (3, 2, 1000000, 1, 1, 1, 2, CURRENT_DATE),  -- дебетовый счет
    (4, 2, 300000, 1, 1, 3, 1, CURRENT_DATE);  -- счет для вклада (просто счет)

    -- debit_accounts
    INSERT INTO debit_accounts (id, plan_id, opened_at, closed_at) VALUES
    (1, 1, CURRENT_DATE, NULL),  -- для Ивана
    (2, 2, CURRENT_DATE, NULL);  -- для Петра

    -- deposits
    INSERT INTO deposits (id, plan_id, status_id, amount, start_date, end_date, partial_withdrawal_allowed) VALUES
    (1, 1, 1, 300000, CURRENT_DATE, date(CURRENT_DATE, '+6 months'), 0);

    -- credits
    INSERT INTO credits (id, credit_number, client_id, plan_id, status_id, currency_id, disbursement_account_id, repayment_account_id, principal_amount, remaining_amount, issued_date, end_date, payment_due_day, created_at) VALUES
    (1, 'CRED-2024-0001', 1, 1, 1, 1, 1, 1, 500000, 500000, CURRENT_DATE, date(CURRENT_DATE, '+3 years'), 10, CURRENT_TIMESTAMP);

    -- credit_payment_schedule (для кредита Ивана - первые 3 платежа)
    INSERT INTO credit_payment_schedule (id, credit_id, payment_number, due_date, principal_amount, interest_amount, total_amount, remaining_balance, paid_date, paid_amount, status_id) VALUES
    (1, 1, 1, date(CURRENT_DATE, '+1 month'), 13889, 6458, 20347, 486111, NULL, NULL, 1),
    (2, 1, 2, date(CURRENT_DATE, '+2 months'), 13889, 6458, 20347, 472222, NULL, NULL, 1),
    (3, 1, 3, date(CURRENT_DATE, '+3 months'), 13889, 6458, 20347, 458333, NULL, NULL, 1);

    -- payment_status
    INSERT INTO payment_status (id, name) VALUES
        (1, "pending"),
        (2, "complete"),
        (3, "overdue");

    -- cards
    INSERT INTO cards (id, debit_account_id, card_type_id, card_category_id, status_id, card_number_hash, card_number_last4, card_holder_name, expiration_month, expiration_year, cvv_hash, issued_date, activated_date, pin_attempts) VALUES
    (1, 1, 1, 2, 1, 'hash1234567890', '1234', 'IVAN IVANOV', 12, 2026, 'cvvhash123', CURRENT_DATE, CURRENT_DATE, 0),
    (2, 2, 2, 3, 1, 'hash0987654321', '5678', 'PETR PETROV', 10, 2027, 'cvvhash456', CURRENT_DATE, CURRENT_DATE, 0);

    -- Добавление системного пользователя с ID 0
    INSERT INTO clients (id, first_name, middle_name, last_name, password_hash, birth_date, created_at)
    VALUES (0, 'SYSTEM', NULL, 'SYSTEM', 'system', '1970-01-01', CURRENT_DATE);

    -- Добавление системного счета с ID 0
    INSERT INTO accounts (id, client_id, balance, status_id, currency_id, type_id, account_type_id, created_at)
    VALUES (0, 0, 0, 1, 1, 1, 0, CURRENT_DATE);

    -- Добавление системного debit_account с ID 0
    INSERT INTO debit_accounts (id, plan_id, opened_at, closed_at)
    VALUES (0, 1, CURRENT_DATE, NULL);