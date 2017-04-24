select
	pfm.DIVISION  'DIVISION',
    pfm.SEASON    'SEASON',
    pfm.FIXTURE_DATE 'FIXTURE_DATE',
	pfm.HOME_TEAM 'HOME',
    pfm.AWAY_TEAM 'AWAY',
    (select  
		count(*)
		from MOTSON.PLAYED_FIXTURES lf_sub2
		where (lf_sub2.FIXTURE_DATE
				< pfm.FIXTURE_DATE)
		and    (pfm.HOME_TEAM = lf_sub2.HOME_TEAM 
        or      pfm.HOME_TEAM = lf_sub2.AWAY_TEAM) 
        and  pfm.SEASON = lf_sub2.SEASON)           'HMMATCHESSOFAR',

        
    ((hhts.`SmHmGoalsScored` + hats.`SmAwGoalsScored`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HMGOALRATE',
    ((ahts.`SmHmGoalsScored` + aats.`SmAwGoalsScored`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AWGOALRATE',

    ((hhts.`SmHmGoalsConceded` + hats.`SmAwGoalsConceded`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HMCONCEDERATE',
    ((ahts.`SmHmGoalsConceded` + aats.`SmAwGoalsConceded`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AWCONCEDERATE',

    ((hhts.`SmHmWin` + hats.`SmAwWins`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HMWINRATE',
    ((ahts.`SmHmWin` + aats.`SmAwWins`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AWWINRATE',

    ((hhts.`SmHmDraw` + hats.`SmAwDraws`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`))  'HMDRAWRATE',
    ((ahts.`SmHmDraw` + aats.`SmAwDraws`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`))  'AWDRAWRATE',

    ((hhts.`SmHmLooses` + hats.`SmAwLooses`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HMLOSSRATE',
    ((ahts.`SmHmLooses` + aats.`SmAwLooses`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AWLOSSRATE',

    ((hhts.`SmHmWDLRate` - hats.`SmWDLRate`)  / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HMHOMEBIAS',
    ((ahts.`SmHmWDLRate` - aats.`SmWDLRate`)  / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AWHOMEBIAS'
from 
	MOTSON.UNPLAYED_FIXTURES    pfm,
	`MOTSON`.`AWAY_TEAM_STATS_100` hats,
	`MOTSON`.`HOME_TEAM_STATS_100` hhts,
	`MOTSON`.`AWAY_TEAM_STATS_100` aats,
	`MOTSON`.`HOME_TEAM_STATS_100` ahts
where
    pfm.SEASON = hhts.`Season` and
    pfm.SEASON = hats.`Season` and
    pfm.DIVISION = hhts.`Division` and
	pfm.DIVISION = hats.`Division` and
    pfm.SEASON = ahts.`Season` and
    pfm.SEASON = aats.`Season` and
    pfm.DIVISION = ahts.`Division` and
	pfm.DIVISION = aats.`Division` and
	pfm.HOME_TEAM = hhts.`HmTeam` and
	pfm.HOME_TEAM = hats.`AwTeam` and
	pfm.AWAY_TEAM = ahts.`HmTeam` and
	pfm.AWAY_TEAM = aats.`AwTeam` and 
    pfm.fixture_date >= current_date()
   









