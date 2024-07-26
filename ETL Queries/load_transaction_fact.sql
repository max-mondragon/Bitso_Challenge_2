TRUNCATE TABLE Transaction_Fact;

INSERT INTO Transaction_Fact
SELECT
	STR_TO_DATE(SUBSTRING(event_timestamp,1,10), '%Y-%m-%d') AS fact_date
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%Y%m%d') AS UNSIGNED) AS fact_date_key
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%H%i%s') AS UNSIGNED) AS event_time
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%H%i%s') AS UNSIGNED) AS event_time_key
    ,id AS transaction_id
    ,2 AS transaction_type_key
	,u.user_key
	,amount
	,c.currency_key
	,s.status_key
	,i.interface_key
	,NOW() AS population_date
FROM stage_withdrawals a
LEFT JOIN User_Dim u
	ON u.user_code = a.user_id
LEFT JOIN Currency_Dim c
	ON c.currency_code = a.currency
LEFT JOIN Status_Dim s
	ON s.status_code = a.tx_status
LEFT JOIN Interface_Dim i
	ON i.interface_code = a.interface
;

INSERT INTO Transaction_Fact
SELECT
	STR_TO_DATE(SUBSTRING(event_timestamp,1,10), '%Y-%m-%d') AS fact_date
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%Y%m%d') AS UNSIGNED) AS fact_date_key
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%H%i%s') AS UNSIGNED) AS event_time
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%H%i%s') AS UNSIGNED) AS event_time_key
    ,id AS transaction_id
    ,1 AS transaction_type_key
	,u.user_key
	,amount
	,c.currency_key
	,s.status_key
	,-2 AS interface_key
	,NOW() AS population_date
FROM stage_deposit a
LEFT JOIN User_Dim u
	ON u.user_code = a.user_id
LEFT JOIN Currency_Dim c
	ON c.currency_code = a.currency
LEFT JOIN Status_Dim s
	ON s.status_code = a.tx_status
;
