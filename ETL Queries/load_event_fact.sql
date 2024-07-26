TRUNCATE TABLE Event_Fact;

INSERT INTO Event_Fact
SELECT
	STR_TO_DATE(SUBSTRING(event_timestamp,1,10), '%Y-%m-%d') AS fact_date
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%Y%m%d') AS UNSIGNED) AS fact_date_key
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%H%i%s') AS UNSIGNED) AS event_time
	,CAST(DATE_FORMAT(STR_TO_DATE(SUBSTRING(event_timestamp,1,19), '%Y-%m-%d %H:%i:%s'),'%H%i%s') AS UNSIGNED) AS event_time_key
    ,id AS event_id
	,u.user_key
    ,ed.event_key
	,NOW() AS population_date
FROM stage_event e
LEFT JOIN User_Dim u
	ON u.user_code = e.user_id
LEFT JOIN Event_Dim ed
	ON ed.event_code = e.event_name