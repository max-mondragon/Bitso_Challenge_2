TRUNCATE TABLE Currency_Dim;

INSERT INTO Currency_Dim
SELECT
	ROW_NUMBER() OVER (PARTITION BY NULL) 	AS currency_key
    ,currency AS currency_code
    ,currency AS currency_name
	,NOW() AS population_date
FROM
(
	SELECT DISTINCT currency
	FROM
	(    
		SELECT DISTINCT currency
		FROM stage_deposit
		UNION
		SELECT DISTINCT currency
		FROM stage_withdrawals
	) a
) b
