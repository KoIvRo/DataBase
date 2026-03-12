INSERT INTO account_types (ID, type) VALUES
    (1, 'debit'),
    (2, 'credit'),
    (3, 'saving');


INSERT INTO account_status (ID, name) VALUES
    (1, 'active'),
    (2, 'blocked'),
    (3, 'closed');


INSERT INTO clients (ID, first_name, second_name, passport, phone, email) VALUES
    (0, 'System', 'Client', '0000000000', '+70000000000', 'system@bank.com');


INSERT INTO clients (first_name, second_name, passport, phone, email) VALUES
    ('Ivan', 'Korotaev', '1234567890',  '+79001234567', 'ivan@example.com'),
    ('Yaroslav', 'Romanov', '2345678901', '+79007654321', 'petr@example.com');


INSERT INTO account_plans (ID, name, type_id, credit_limit, interest_rate, monthly_fee) VALUES
    (1, 'Debit Basic', 1, NULL, 1.0, 500),
    (2, 'Credit Standard', 2, 5000, 15.0, 1000),
    (3, 'Saving Premium', 3, NULL, 3.5, 1500);



INSERT INTO accounts (ID, balance, plan_id, status_id) VALUES
    (0, 0, 1, 1); -- Системный аккаунт


INSERT INTO accounts (balance, plan_id, status_id) VALUES
    (100000, 1, 1),
    (500000, 2, 1),
    (200000, 3, 1);


INSERT INTO client_accounts (client_id, account_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (0, 4); -- Системный аккаунт

INSERT INTO accounts (ID, balance, plan_id, status_id) VALUES
    (5, 300000, 3, 1); -- Общий счет
INSERT INTO client_accounts (client_id, account_id) VALUES
    (1, 5),
    (3, 5);

INSERT INTO transaction_types (ID, name) VALUES
    (1, 'deposit'),
    (2, 'withdrawal'),
    (3, 'transfer'),
    (4, 'interest'),
    (5, 'fee');

INSERT INTO interest_rate_history (plan_id, rate, start_date, end_date) VALUES
    (1, 1.0, '2026-01-01', NULL),
    (2, 15.0, '2026-01-01', NULL),
    (3, 3.5, '2026-01-01', NULL);
