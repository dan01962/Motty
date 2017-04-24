UPDATE MOTSON.PREDICTIONS_AWAY p, 
	   MOTSON.LOAD_PREDICTIONS_AWAY lp
SET 
    p.`AWAY`        = lp.`AWAY`,
    p.`CONFIDENCE` = lp.`CONFIDENCE`
WHERE 
	 p.`SEASON`       = lp.`SEASON`
AND  p.`DIVISION`     = lp.`DIVISION`
AND  p.`FIXTURE_DATE` = lp.`FIXTURE_DATE`
AND  p.`HOME_TEAM`    = lp.`HOME_TEAM`
AND  p.`AWAY_TEAM`    = lp.`AWAY_TEAM`
AND  p.`METHOD`       = lp.`METHOD`
AND NOT EXISTS
   (SELECT 'x'
    FROM MOTSON.PLAYED_FIXTURES pf
    WHERE pf.SEASON = lp.SEASON
    AND pf.DIVISION = lp.DIVISION
    AND pf.HOME_TEAM = lp.HOME_TEAM
    AND pf.AWAY_TEAM = lp.AWAY_TEAM
    AND pf.FIXTURE_DATE = lp.FIXTURE_DATE)
    