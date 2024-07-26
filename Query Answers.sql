-----------------------------------------------------------------------------------
-- How many users were active on a given day (they made a deposit or withdrawal)
SELECT COUNT(DISTINCT user_key) AS active_users
FROM Transaction_Fact
WHERE fact_date_key = 20221122;
-- Output: 3
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- Users without a deposit on all history data
SELECT COUNT(*) AS total_users
FROM User_Dim u
WHERE u.user_key NOT IN
(
	SELECT t.user_key
	FROM Transaction_Fact t
	WHERE t.transaction_type_key = 1 -- Deposit
    AND t.transaction_status_key = 1 -- Success
	-- AND t.fact_date_key = 20221122 -- Never in history have made a deposit
)
AND u.user_key > 0;
-- Output: 12234
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
SELECT t.fact_date_key, t.user_key, u.user_code, COUNT(*) AS total_tx
FROM Transaction_Fact t
LEFT JOIN User_Dim u
	ON u.user_key = t.user_key
WHERE t.fact_date_key = 20221122
AND t.transaction_type_key = 1 -- Deposit
AND t.transaction_status_key = 1 -- Success
GROUP BY t.fact_date_key, t.user_key, u.user_code
HAVING COUNT(*) >= 5;
-- Output:
-- fact_date_key	user_key	user_id	alter						total_tx
-- 20221122			8851		0197fcd95060131d9bc5e564f842ed53	5
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
--  When was the last time a user made a login
SELECT u.user_key, u.user_code, MAX(e.fact_date) AS Last_login_day
FROM User_Dim u
LEFT JOIN Event_Fact e
	ON u.user_key = e.user_key
LEFT JOIN Event_Dim ed
	ON ed.event_key = e.event_key
WHERE ed.event_code = 'login' -- Ignore API and 2FA login?
GROUP BY u.user_key, u.user_code
ORDER BY Last_login_day DESC;
-- Output:
-- user_key	user_id								Last_login_day
-- 23912	bd47dc58209bc820d555f935bf055e40	2023-08-23
-- 8864		ab4ac2d850c6a8542ce122e0d82ceace	2023-08-21
-- 22144	59c48eb9274c58cf5704d3e95c22c4c5	2023-08-18
-- 9825		00865d413600d26adb36d2f55973559f	2023-08-15
-- 3304		95f8d9901ca8878e291552f001f67692	2023-08-10
-- ...
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
--  How many times a user has made a login between two dates
SELECT u.user_key, u.user_code, COUNT(*) AS total_logins
FROM Event_Fact e
LEFT JOIN Event_Dim ed
	ON ed.event_key = e.event_key
LEFT JOIN User_Dim u
	ON u.user_key = e.user_key
WHERE ed.event_code = 'login' -- Ignore API and 2FA login?
AND e.fact_date_key
	BETWEEN 20221122 AND 20221123 -- Between 22 and 23 of november 2022
GROUP BY u.user_key, u.user_code
ORDER BY total_logins DESC;
-- Output:
-- user_key	user_id								total_logins
-- 11245	310b60949d2b6096903d7e8a539b20f5	6
-- 5611		ee79d5e1b7c2b698105bc5811e6a3eb5	2
-- 11440	721d2344f7d2bfbe7a90c257f8d961df	2
-- 125		55a706dbc200a848d7147319ef0476f9	1
-- 756		8f8f63800cdf54a776ba9c14b2059ec0	1
-- 24630	11eed2e8a05bbbb4508ffa229a7b84c0	1
-- 6945		bf56d3ff4ea20391eeb73af2dc7e0d07	1
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- Number of unique currencies deposited on a given day
SELECT COUNT(DISTINCT currency_key) AS unique_currencies
FROM Transaction_Fact t
WHERE t.fact_date_key = 20221123
AND t.transaction_type_key = 1 -- Deposit
AND t.transaction_status_key = 1; -- Success
-- Output: 56
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- Number of unique currencies withdrew on a given day
SELECT COUNT(DISTINCT currency_key) AS unique_currencies
FROM Transaction_Fact t
WHERE t.fact_date_key = 20201204
AND t.transaction_type_key = 2 -- Withdraw
AND t.transaction_status_key = 1; -- Success
-- Output: 12
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- Total amount deposited of a given currency on a given day
SELECT t.currency_key, c.currency_code, SUM(amount) AS total
FROM Transaction_Fact t
LEFT JOIN Currency_Dim c
	ON c.currency_key = t.currency_key
WHERE t.fact_date_key = 20220622
AND t.transaction_type_key = 1 -- Deposit
AND t.transaction_status_key = 1
GROUP BY t.currency_key, c.currency_code; -- Success
-- Output:
-- currency_key	currency_code	total
-- 36			eth				0.0030002699999999998
-- 39			mxn				3512
-- 53			cop				20000
-----------------------------------------------------------------------------------
