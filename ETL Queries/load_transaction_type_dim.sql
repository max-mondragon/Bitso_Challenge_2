TRUNCATE TABLE Transaction_Type_Dim;

INSERT INTO Transaction_Type_Dim
SELECT
	1 AS transaction_type_key
    ,'D'	AS transaction_type_code
    ,'Deposit' AS transaction_type_name
	,NOW() AS population_date
UNION
SELECT
	2 AS transaction_type_key
    ,'W'	AS transaction_type_code
    ,'Withdrawal' AS transaction_type_name
	,NOW() AS population_date