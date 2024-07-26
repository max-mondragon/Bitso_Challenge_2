TRUNCATE TABLE Interface_Dim;

INSERT INTO Interface_Dim
SELECT
	ROW_NUMBER() OVER (PARTITION BY NULL) 	AS interface_key
    ,interface AS interface_code
    ,interface AS interface_name
	,NOW() AS population_date
FROM
(
	SELECT DISTINCT interface
	FROM
	(
		SELECT DISTINCT interface
		FROM stage_withdrawals
	) a
) b