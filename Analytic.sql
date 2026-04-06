-- АНАЛИТИЧЕСКИЕ ЗАПРОСЫ

-- 1. Кто больше просрочивает кредиты: мужчины или женщины?
SELECT
    CASE
        WHEN is_male = true THEN 'Мужчина'
        ELSE 'Женщина'
    END AS gender,
    COUNT(DISTINCT cr.id) AS total_credits,
    COUNT(DISTINCT CASE WHEN cr.status_id = 3 THEN cr.id END) AS overdue_credits,
    SUM(CASE WHEN cr.status_id = 3 THEN cr.remaining_amount ELSE 0 END) AS total_overdue_amount,
    COUNT(DISTINCT c.id) AS clients_count
FROM Clients c
JOIN Accounts a ON a.client_id = c.id
JOIN Credits cr ON cr.repayment_account_id = a.id
WHERE c.id != 0
GROUP BY gender;

-- 2. Топ-5 MCC-кодов по сумме транзакций
SELECT
    mcc.id,
    mcc.description,
    COUNT(t.id) AS transaction_count,
    SUM(t.amount) AS total_amount,
    ROUND(AVG(t.amount), 2) AS avg_amount,
    COUNT(DISTINCT tp.account_id) AS unique_accounts
FROM Mcc_Codes mcc
JOIN Transactions t ON t.mcc_id = mcc.id
JOIN Transaction_Parties tp ON tp.transaction_id = t.id AND tp.direction_id = 2
WHERE t.status_id = 2
GROUP BY mcc.id, mcc.description
ORDER BY total_amount DESC
LIMIT 5;

-- 3. Кто из клиентов самый прибыльный для банка
-- (проценты по кредитам минус проценты по вкладам)

WITH
cc AS (
    SELECT
        c.id AS client_id,
        c.first_name || ' ' || c.last_name AS client_name,
        SUM(cps.interest_amount) AS total_interest_paid
    FROM Clients c
    JOIN Accounts a ON a.client_id = c.id
    JOIN Credits cr ON cr.repayment_account_id = a.id
    JOIN Credit_Payment_Schedules cps ON cps.credit_id = cr.id
    WHERE cps.status_id = 2
    GROUP BY c.id
),
cd AS (
    SELECT
        c.id AS client_id,
        c.first_name || ' ' || c.last_name AS client_name,
        SUM(d.amount * dp.interest_rate / 100) AS total_interest_earned
    FROM Clients c
    JOIN Accounts a ON a.client_id = c.id
    JOIN Deposits d ON d.account_id = a.id
    JOIN Deposit_Plan dp ON dp.id = d.plan_id
    WHERE d.status_id = 1
    GROUP BY c.id
)
SELECT
    cc.client_name AS client_name,
    COALESCE(cc.total_interest_paid, 0) AS interest_paid_to_bank,
    COALESCE(cd.total_interest_earned, 0) AS interest_earned_by_client,
    COALESCE(cc.total_interest_paid, 0) - COALESCE(cd.total_interest_earned, 0) AS net_profit_for_bank
FROM cc
JOIN cd ON cd.client_id = cc.client_id
ORDER BY net_profit_for_bank DESC;

-- 4. Топ-3 клиентов с самой большой задолженностью
SELECT
    c.id,
    c.last_name || ' ' || c.first_name AS client_name,
    COUNT(cr.id) AS кредитов,
    SUM(cr.remaining_amount) AS общий_долг
FROM Clients c
JOIN Accounts a ON a.client_id = c.id
JOIN Credits cr ON cr.repayment_account_id = a.id
WHERE cr.status_id IN (1, 3)
GROUP BY c.id
ORDER BY общий_долг DESC
LIMIT 3;

-- 5. Клиенты, не прошедшие KYC
SELECT
    c.id,
    c.first_name || ' ' || c.last_name AS name,
    ks.name AS kyc_status,
    CASE
        WHEN cd.id IS NULL THEN 'Нет документов'
        WHEN ce.id IS NULL THEN 'Нет данных о доходах'
        WHEN ca.id IS NULL THEN 'Нет адреса'
        ELSE 'OK'
    END AS problem
FROM Clients c
JOIN Client_Verifications cv ON cv.client_id = c.id
JOIN Kyc_Status ks ON ks.id = cv.kyc_status_id
LEFT JOIN Client_Documents cd ON cd.client_id = c.id
LEFT JOIN Client_Employment ce ON ce.client_id = c.id
LEFT JOIN Client_Addresses ca ON ca.client_id = c.id
WHERE ks.name IN ('pending', 'rejected', 'edd')
GROUP BY c.id;
