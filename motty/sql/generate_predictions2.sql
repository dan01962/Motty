SELECT 
    p.`DIVISION` 'Div',
    p.`HOME_TEAM` 'Home',
    p.`AWAY_TEAM` 'Away',
    p.`FTR`  'FT',
    ROUND(p.`CONFIDENCE`*100) 'Conf %',
    ROUND((1/p.`CONFIDENCE`),3) 'My Odds',
	case when p.`FTR` = 'H' then
		ROUND(up.ODDS_HOME +1,2) 
	when p.`FTR` = 'D' then
		ROUND(up.ODDS_DRAW +1,2) 
	when p.`FTR` = 'A' then
		ROUND(up.ODDS_AWAY +1,2) 
	else null end                 'Best Odds',
    '=INDIRECT(ADDRESS(ROW(),7)) - INDIRECT(ADDRESS(ROW(),6))' AS 'Gap' , 
    
    
	case when p.`FTR` = 'H' then
		p.HOME_TEAM
	when p.`FTR` = 'D' then
		'Draw'
	when p.`FTR` = 'A' then
		p.AWAY_TEAM 
	else null end                 'Bet',
        
	null 'Stake',
    null 'OddsAchieved',
    'bfare' as 'Bookie'



 
FROM 
	`FOOTBALL_PREDICT`.`PREDICTIONS` p,
	`FOOTBALL_PREDICT`.`UNPLAYED_FIXTURES` up
WHERE
	   p.`DIVISION`   = up.`DIVISION`
AND    p.`SEASON`     = up.`SEASON`
AND    p.`HOME_TEAM`  = up.`HOME_TEAM`
AND    p.`AWAY_TEAM`  = up.`AWAY_TEAM`
AND    p.FIXTURE_DATE = up.FIXTURE_DATE
AND    p.FIXTURE_DATE = current_date() 


AND    p.CONFIDENCE > 0.66


order by 2, 1
