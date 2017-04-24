INSERT INTO MOTSON.PLAYED_FIXTURES
SELECT lf.`DIVISION`,
    str_to_date(lf.`FIXTURE_DATE`, '%d/%m/%y'),
    lf.`HOME_TEAM`,
    lf.`AWAY_TEAM`,
    cast(trim(lf.`FTHG`) AS UNSIGNED) 'fthg',
    cast(trim(lf.`FTAG`) AS UNSIGNED) 'ftag',
    lf.`FTR`,
    cast(trim(lf.`HTHG`) AS UNSIGNED) 'hthg',
    cast(trim(lf.`HTAG`) AS UNSIGNED) 'htag',
    lf.`HTR`,
    lf.`REFEREE`,
    cast(trim(lf.`HS`) AS UNSIGNED) 'hs',
    cast(trim(lf.`AS`) AS UNSIGNED) 'as',
    cast(trim(lf.`HST`) AS UNSIGNED) 'hst',
    cast(trim(lf.`AST`) AS UNSIGNED) 'ast',
    cast(trim(lf.`HF`) AS UNSIGNED) 'hf',
    cast(trim(lf.`AF`) AS UNSIGNED) 'af',
    cast(trim(lf.`HC`) AS UNSIGNED) 'hc',
    cast(trim(lf.`AC`) AS UNSIGNED) 'ac',
    cast(trim(lf.`HY`) AS UNSIGNED) 'hy',
    cast(trim(lf.`AY`) AS UNSIGNED) 'ay',
    cast(trim(lf.`HR`) AS UNSIGNED) 'hr',
    cast(trim(lf.`AR`) AS UNSIGNED) 'ar',
    cast(trim(lf.`B365H`) AS DECIMAL (5,2)) 'b365h',
    cast(trim(lf.`B365D`) AS DECIMAL (5,2)) 'b365d',
    cast(trim(lf.`B365A`) AS DECIMAL (5,2)) 'b365a',
    IFNULL(lf.`SEASON`, "16") 'sea'
FROM `MOTSON`.`LOAD_FIXTURES` lf
WHERE NOT EXISTS
  (SELECT 'x'
   FROM MOTSON.PLAYED_FIXTURES pf
   WHERE pf.SEASON = lf.SEASON
   and   pf.DIVISION = lf.DIVISION
   and   pf.HOME_TEAM = lf.HOME_TEAM
   and   pf.AWAY_TEAM = lf.AWAY_TEAM
   and   pf.FIXTURE_DATE = str_to_date(lf.`FIXTURE_DATE`, '%d/%m/%y'))
 ;
