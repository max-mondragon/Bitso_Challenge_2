INSERT INTO `User_Dim`
SELECT
	ROW_NUMBER() OVER (PARTITION BY NULL) AS user_key
	,user_id AS user_cd
	,NOW() AS population_date
FROM stage_users
UNION
SELECT
	-2 user_key
	,'Not Applicable' AS user_cd
	,NOW() AS population_date
UNION
SELECT
	-1 user_key
	,'To be Determined' AS user_cd
	,NOW() AS population_date