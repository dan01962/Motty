SELECT 
	pr.SEASON,
    pr.DIVISION,
    pr.FIXTURE_DATE,
    pr.HOME_TEAM,
    pr.AWAY_TEAM,
    pr.METHOD,
    pr.FTR,
    round(pr.CONFIDENCE,2)   'FTR_CONF',
    round(1/pr.CONFIDENCE,2) 'FTR_ODDS',
    round(case when ph.HOME = 'Y' then ph.CONFIDENCE
		 else 1-ph.CONFIDENCE 
		end,2)  AS 'HOME_CONF',

   round(case when pd.DRAW = 'Y' then pd.CONFIDENCE
		 else 1-pd.CONFIDENCE 
		end,2)  AS 'DRAW_CONF',
	round(case when pa.AWAY = 'Y' then pa.CONFIDENCE
		 else 1-pa.CONFIDENCE 
		end,2)  AS 'AWAY_CONF',
        

    round(1/(case when ph.HOME = 'Y' then ph.CONFIDENCE
			else 1-ph.CONFIDENCE 
			end),2)  AS 'MY_HOME_ODDS',

    round(1/(case when pd.DRAW = 'Y' then pd.CONFIDENCE
		    else 1-pd.CONFIDENCE 
	    	end),2)  AS 'MY_DRAW_ODDS',
        
    round(1/(case when pa.AWAY = 'Y' then pa.CONFIDENCE
		 else 1-pa.CONFIDENCE 
		end),2)  AS 'MY_AWAY_ODDS',
	
	uf.ODDS_HOME 'BEST_ODDS_HOME',
    uf.ODDS_DRAW 'BEST_ODDS_DRAW',
    uf.ODDS_AWAY 'BEST_ODDS_AWAY',
    
    round(
		(case when ph.HOME = 'N' then ph.CONFIDENCE
		 else 1-ph.CONFIDENCE 
		end) - 
		(case when ph.HOME = 'Y' then ph.CONFIDENCE
		 else 1-ph.CONFIDENCE 
		end) * uf.ODDS_HOME
        
        ,2)  AS 'LAY_HOME_EV',
    
    round(
		(case when pd.DRAW = 'N' then pd.CONFIDENCE
		 else 1-pd.CONFIDENCE 
		end) - 
		(case when pd.DRAW = 'Y' then pd.CONFIDENCE
		 else 1-pd.CONFIDENCE 
		end) * uf.ODDS_DRAW
        
        ,2)  AS 'LAY_DRAW_EV',

    round(
		(case when pa.AWAY = 'N' then pa.CONFIDENCE
		 else 1-pa.CONFIDENCE 
		end) - 
		(case when pa.AWAY = 'Y' then pa.CONFIDENCE
		 else 1-pa.CONFIDENCE 
		end) * uf.ODDS_AWAY
        
        ,2)  AS 'LAY_AWAY_EV'

        
        
FROM 
	MOTSON.PREDICTIONS           pr,
    MOTSON.LOAD_PREDICTIONS_HOME ph,
    MOTSON.LOAD_PREDICTIONS_DRAW pd,    
    MOTSON.LOAD_PREDICTIONS_AWAY pa,
    MOTSON.UNPLAYED_FIXTURES     uf
    
WHERE
	   pr.SEASON       = ph.SEASON
AND    pr.DIVISION     = ph.DIVISION
AND    pr.FIXTURE_DATE = ph.FIXTURE_DATE
AND    pr.HOME_TEAM    = ph.HOME_TEAM
AND    pr.AWAY_TEAM    = ph.AWAY_TEAM
AND    pr.METHOD       = ph.METHOD
AND	   pr.SEASON       = pd.SEASON
AND    pr.DIVISION     = pd.DIVISION
AND    pr.FIXTURE_DATE = pd.FIXTURE_DATE
AND    pr.HOME_TEAM    = pd.HOME_TEAM
AND    pr.AWAY_TEAM    = pd.AWAY_TEAM
AND    pr.METHOD       = pd.METHOD
AND	   pr.SEASON       = pa.SEASON
AND    pr.DIVISION     = pa.DIVISION
AND    pr.FIXTURE_DATE = pa.FIXTURE_DATE
AND    pr.HOME_TEAM    = pa.HOME_TEAM
AND    pr.AWAY_TEAM    = pa.AWAY_TEAM
AND    pr.METHOD       = pa.METHOD
AND	   pr.SEASON       = uf.SEASON
AND    pr.DIVISION     = uf.DIVISION
AND    pr.FIXTURE_DATE = uf.FIXTURE_DATE
AND    pr.HOME_TEAM    = uf.HOME_TEAM
AND    pr.AWAY_TEAM    = uf.AWAY_TEAM
AND    pr.FIXTURE_DATE = current_date() -1

order by 2,4 asc
    
