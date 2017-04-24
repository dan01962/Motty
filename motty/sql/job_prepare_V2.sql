INSERT INTO LEARNING_V2

select
	pfm.DIVISION  'Div',
    pfm.SEASON    'Seas',
    (select
		count(*)
		from MOTSON.PLAYED_FIXTURES lf_sub2
		where (lf_sub2.FIXTURE_DATE
				< pfm.FIXTURE_DATE)
		and    (pfm.HOME_TEAM = lf_sub2.HOME_TEAM
        or      pfm.HOME_TEAM = lf_sub2.AWAY_TEAM)
        and  pfm.SEASON = lf_sub2.SEASON)           'HmMatchesSoFar',

    ifnull((select
			datediff(pfm.FIXTURE_DATE, lf_sub2.FIXTURE_DATE)
		from MOTSON.PLAYED_FIXTURES lf_sub2
		where (lf_sub2.FIXTURE_DATE
				< pfm.FIXTURE_DATE)
		and    (pfm.HOME_TEAM = lf_sub2.HOME_TEAM
        or      pfm.HOME_TEAM = lf_sub2.AWAY_TEAM)
		order by lf_sub2.FIXTURE_DATE desc
		limit 1)     -
    (select
			case when datediff(pfm.FIXTURE_DATE, lf_sub2.FIXTURE_DATE) > 7 then 0
				 else datediff(pfm.FIXTURE_DATE, lf_sub2.FIXTURE_DATE) end
		from MOTSON.PLAYED_FIXTURES lf_sub2
		where (lf_sub2.FIXTURE_DATE
				< pfm.FIXTURE_DATE)
		and    (pfm.AWAY_TEAM = lf_sub2.HOME_TEAM
        or      pfm.AWAY_TEAM = lf_sub2.AWAY_TEAM)
		order by lf_sub2.FIXTURE_DATE desc
		limit 1),0)     'DiffDaysSince',

    ((select
		count(*)
		from MOTSON.PLAYED_FIXTURES lf_sub2
		where (lf_sub2.FIXTURE_DATE
				< pfm.FIXTURE_DATE)
		and    (pfm.HOME_TEAM = lf_sub2.HOME_TEAM
        or      pfm.HOME_TEAM = lf_sub2.AWAY_TEAM)
        and  pfm.SEASON = lf_sub2.SEASON)          -
    (select

		count(*)
		from MOTSON.PLAYED_FIXTURES lf_sub2
		where (lf_sub2.FIXTURE_DATE
				< pfm.FIXTURE_DATE)
		and    (pfm.AWAY_TEAM = lf_sub2.HOME_TEAM
        or      pfm.AWAY_TEAM = lf_sub2.AWAY_TEAM)
        and  pfm.SEASON = lf_sub2.SEASON))           'DiffMatches',

    ((hhts.`SmHmGoalsScored` + hats.`SmAwGoalsScored`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HmGoalRate',
    ((ahts.`SmHmGoalsScored` + aats.`SmAwGoalsScored`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AwGoalRate',

    ((hhts.`SmHmGoalsConceded` + hats.`SmAwGoalsConceded`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HmConcedeRate',
    ((ahts.`SmHmGoalsConceded` + aats.`SmAwGoalsConceded`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AwConcedeRate',

    ((hhts.`SmHmWin` + hats.`SmAwWins`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HmWinRate',
    ((ahts.`SmHmWin` + aats.`SmAwWins`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AwWinRate',

    ((hhts.`SmHmDraw` + hats.`SmAwDraws`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`))  'HmDrawRate',
    ((ahts.`SmHmDraw` + aats.`SmAwDraws`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`))  'AwDrawRate',

    ((hhts.`SmHmLooses` + hats.`SmAwLooses`) / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HmLossRate',
    ((ahts.`SmHmLooses` + aats.`SmAwLooses`) / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AwLossRate',

    ((hhts.`SmHmWDLRate` - hats.`SmWDLRate`)  / (hhts.`HmGamesPlayed` + hats.`AwGamesPlayed`)) 'HmHomeBias',
    ((ahts.`SmHmWDLRate` - aats.`SmWDLRate`)  / (ahts.`HmGamesPlayed` + aats.`AwGamesPlayed`)) 'AwHomeBias',
	case when (pfm.FTHG + pfm.FTAG) >= 2 then 2 else 1 end 'Weight',
    pfm.FTR       'TG_FTR',
    pfm.FTHG      'TG_FTHG',
    pfm.FTAG      'TG_FTAG',
    case when (pfm.FTHG + pfm.FTAG) = 0  then 'U' else 'O' end 'TG_UO0P5',
    case when (pfm.FTHG + pfm.FTAG) <= 1 then 'U' else 'O' end 'TG_UO1P5',
    case when (pfm.FTHG + pfm.FTAG) <= 2 then 'U' else 'O' end 'TG_UO2P5',
    case when (pfm.FTHG + pfm.FTAG) <= 3 then 'U' else 'O' end 'TG_UO3P5',
    concat('H',
			case when pfm.FTHG < 4 then pfm.FTHG else 'X' end,
            'A',
            case when pfm.FTAG < 4 then pfm.FTAG else 'X' end) 'TG_Score',
	case when pfm.ftr = 'D' then 'Y' else 'N' end 'TG_DRAW',
	case when pfm.ftr = 'H' then 'Y' else 'N' end 'TG_HOME',
	case when pfm.ftr = 'A' then 'Y' else 'N' end 'TG_AWAY'



from
	MOTSON.PLAYED_FIXTURES    pfm,
	`MOTSON`.`AWAY_TEAM_STATS` hats,
	`MOTSON`.`HOME_TEAM_STATS` hhts,
	`MOTSON`.`AWAY_TEAM_STATS` aats,
	`MOTSON`.`HOME_TEAM_STATS` ahts
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
	pfm.AWAY_TEAM = aats.`AwTeam`








