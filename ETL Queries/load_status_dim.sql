TRUNCATE TABLE Status_Dim;

INSERT INTO Status_Dim
SELECT
	ROW_NUMBER() OVER (PARTITION BY NULL) 	AS status_key
    ,tx_status AS status_code
    ,tx_status AS status_name
	,NOW() AS population_date
FROM
(
	SELECT DISTINCT tx_status
	FROM
	(    
		SELECT DISTINCT tx_status
		FROM stage_deposit
		UNION
		SELECT DISTINCT tx_status
		FROM stage_withdrawals
	) a
) b