TRUNCATE TABLE Event_Dim;

INSERT INTO Event_Dim
SELECT
	ROW_NUMBER() OVER (PARTITION BY NULL) 	AS event_key
    ,event_code
    ,event_name
    ,population_date
FROM
(
	SELECT DISTINCT
		event_name								AS event_code
		,event_name								AS event_name
		,NOW() AS population_date
	FROM stage_event
) a