import urllib.request
import csv
import mysql.connector
import time
import datetime
import sys
from bigml.api import BigML
from bigml.fields import Fields

import sys
import copy

sys.setrecursionlimit(10000)

DEFINITION_FILE = 'definitions.csv'
DB_USER = 'usr'
DATABASE = 'MOTSON'
PASSWORD = 'pswd'
HOST = 'localhost'
BIGML_USER = 'usr'
BIGML_KEY = 'key'
TODAY = datetime.date.today().strftime("%d%m%y")


api = BigML(BIGML_USER, BIGML_KEY, dev_mode=True, storage='./models')

cnx = mysql.connector.connect(user=DB_USER, database=DATABASE,
                              host=HOST, password=PASSWORD)


def processDataTransfer(definitionFile):
    print("Deleting old load")

    deleteStatement = (
        "DELETE FROM MOTSON.LOAD_FIXTURES;")

    cursor = cnx.cursor()
    cursor.execute(deleteStatement)

    print("Opening def file and processing seasons....")
    with open(definitionFile) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            try:
                loadSeason(row['League'], row['Location'], row['Season'])

            except KeyError:
                print('Data in Definition file not formatted properly')

    cnx.commit()
    updatePlayedFixturesTable()


def loadSeason(league, csvWebLocation, season):
    localCSVCopy = 'loadcsv/' + league + season + '.csv'
    try:
        urllib.request.urlretrieve(csvWebLocation, localCSVCopy)
    except:
        print('Cant find file for season=', season, ' and League=', league)

    print('Loading', localCSVCopy, '.........')

    with open(localCSVCopy, encoding='mac_roman') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            loadMatch(row, season)


def loadMatch(fixtureRow, season):
    if fixtureRow['Div'] == '':
        return

    if fixtureRow['FTR'] == '':
        return

    if fixtureRow['FTR'] == ' ':
        return

    if not fixtureRow['HTR']:
        fixtureRow['HTR'] = 'D'
    if not fixtureRow['HTHG']:
        fixtureRow['HTHG'] = '0'
    if not fixtureRow['HTAG']:
        fixtureRow['HTAG'] = '0'
    if not fixtureRow['B365H']:
        fixtureRow['B365H'] = '0'
    if not fixtureRow['B365D']:
        fixtureRow['B365D'] = '0'
    if not fixtureRow['B365A']:
        fixtureRow['B365A'] = '0'

    print('Get Home Team', fixtureRow.get('HomeTeam')
          , 'vs', fixtureRow.get('AwayTeam'))

    dataForFixtureInsert = {
        'DIVISION': fixtureRow['Div'],
        'SEASON': season,
        'FIXTURE_DATE': fixtureRow['Date'],
        'HOME_TEAM': fixtureRow['HomeTeam'],
        'AWAY_TEAM': fixtureRow['AwayTeam'],
        'FTHG': fixtureRow['FTHG'],
        'FTAG': fixtureRow['FTAG'],
        'FTR': fixtureRow['FTR'],
        'HTHG': fixtureRow.get('HTHG', '0'),
        'HTAG': fixtureRow.get('HTAG', '0'),
        'HTR': fixtureRow.get('HTR', 'D'),
        'REFEREE': fixtureRow.get('Referee', 'x'),
        'HS': fixtureRow.get('HS', '0'),
        'AS': fixtureRow.get('AS', '0'),
        'HST': fixtureRow.get('HST', '0'),
        'AST': fixtureRow.get('AST', '0'),
        'HF': fixtureRow.get('HF', '0'),
        'AF': fixtureRow.get('AF', '0'),
        'HC': fixtureRow.get('HC', '0'),
        'AC': fixtureRow.get('AC', '0'),
        'HY': fixtureRow.get('HY', '0'),
        'AY': fixtureRow.get('AY', '0'),
        'HR': fixtureRow.get('HR', '0'),
        'AR': fixtureRow.get('AR', '0'),
        'B365H': fixtureRow.get('B365H', '0'),
        'B365D': fixtureRow.get('B365D', '0'),
        'B365A': fixtureRow.get('B365A', '0'), }

    insertStatementForFixture = (

        "INSERT INTO `MOTSON`.`LOAD_FIXTURES` "
        "(`DIVISION`, `FIXTURE_DATE`, `HOME_TEAM`, `AWAY_TEAM`, `FTHG`, "
        "`FTAG`,`FTR`,`HTHG`,`HTAG`,`HTR`,`REFEREE`,`HS`,`AS`,`HST`,`AST`,`HF`,`AF`,`HC`,`AC`, "
        "`HY`,`AY`,`HR`,`AR`,`B365H`,`B365D`,`B365A`,`SEASON`) "
        " VALUES( %(DIVISION)s,%(FIXTURE_DATE)s,%(HOME_TEAM)s,%(AWAY_TEAM)s, "
        "%(FTHG)s,%(FTAG)s,%(FTR)s,%(HTHG)s,%(HTAG)s,%(HTR)s,%(REFEREE)s,%(HS)s, "
        "%(AS)s,%(HST)s,%(AST)s,%(HF)s,%(AF)s,%(HC)s,%(AC)s,%(HY)s,%(AY)s,%(HR)s, "
        "%(AR)s,%(B365H)s,%(B365D)s,%(B365A)s,%(SEASON)s)")

    cursor = cnx.cursor()
    cursor.execute(insertStatementForFixture, dataForFixtureInsert)


def updatePlayedFixturesTable():
    print("Updating Played Fixtures table with Loaded Results")
    sqlstr = open('sql/loadPlayedFixtures.sql', 'r').read()
    cursor = cnx.cursor()
    cursor.execute(sqlstr)
    cnx.commit()


def runSQLJobs():

    print("Processing pre-extract jobs to prepare data")
    for job in JOBS:
        runSQLJob(job)



def processSQLExtracts(all_extracts):
    print("Extracting learning datasets_____________________")
    sql_str = "select distinct PREDICTION_EXTRACT from MOTSON.MODELS where ACTIVE = 'Y'"
    if all_extracts == "All":
        sql_str = sql_str + " union select distinct LEARNING_EXTRACT from MOTSON.MODELS where ACTIVE = 'Y'"
    elif all_extracts == "Learning":
        sql_str = "select distinct LEARNING_EXTRACT from MOTSON.MODELS where ACTIVE = 'Y'"

    cursor_extracts = cnx.cursor(buffered=True)
    cursor_extracts.execute(sql_str)
    for sql_extract in cursor_extracts:
        extractSQL(sql_extract[0])
    cursor_extracts.close()


def extractSQL(sql_extract):
    sql_file = 'extract_sql/' + sql_extract + '.sql'
    csv_file = 'extract_csv/' + sql_extract + '.csv'

    print(sql_file)

    print("Extracting learining data set: ", sql_file, "..........")
    sql_str = open(sql_file, 'r').read()
    cursor_dataset = cnx.cursor()
    cursor_dataset.execute(sql_str)
    for row in cursor_dataset.description:
        print(row)

    with open(csv_file, "w", newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow([i[0] for i in cursor_dataset.description])
        csv_writer.writerows(cursor_dataset)

    cursor_dataset.close()


def processPredictionModels():

    # Prep load table by deleting entries

    deleteStatement = "DELETE FROM MOTSON.LOAD_PREDICTION_RESULTS"

    cursor_delete = cnx.cursor()
    cursor_delete.execute(deleteStatement)
    cursor_delete.close()

    # Get versions of modelling and iterate through them

    sql_str = "select VERSION from MOTSON.MODELS where ACTIVE = 'Y'"
    cursor_models = cnx.cursor(buffered=True)
    cursor_models.execute(sql_str)
    for model_version in cursor_models:
        print("MODEL PROCESSING", model_version[0])
        processModel(model_version[0])
    cursor_models.close()

    # Finalise by transferring all the load info into PREDICTION_RESULTS tabe
    print("Inserting new prediction info into PREDICTION_RESULTS")
    runSQLJob('prediction_result_insert')

    print("Updating existing predictions in PREDICTION_RESULTS")
    runSQLJob('prediction_result_update')


def runSQLJob(file_name):

    print("Running SQL Job: ", file_name)
    sql_loc = './sql/' + file_name + '.sql'
    sqlstr = open(sql_loc, 'r').read()
    cursor_job = cnx.cursor()
    cursor_job.execute(sqlstr)
    cursor_job.close()
    cnx.commit()
    print("Finished SQL Job: ", file_name)


def processModel(model_version):

    print("Beginning:", model_version)

    sql_str = "select * from MOTSON.MODELS where VERSION = %(MODEL_VERSION)s"
    sql_arg = {'MODEL_VERSION': model_version}
    cursor_methods = cnx.cursor(buffered=True)
    cursor_methods.execute(sql_str, sql_arg)
    for version_info in cursor_methods:
        learning_csv_file = 'extract_csv/' + version_info[1] + '.csv'
        prediction_csv_file = 'extract_csv/' + version_info[2] + '.csv'

        print("Creating source for: ", learning_csv_file)
        source_learning = createSource(learning_csv_file)
        print("Creating source for: ", prediction_csv_file)
        source_predictions = createSource(prediction_csv_file)
        predictTargets(model_version, source_learning, source_predictions, 1, 1)

    cursor_methods.close()




def predictTargets(version, source_learning, source_prediction, model_args, prediction_args):

    # First we build the Prediction Dataset

    prediction_dataset_name = 'predictionset_' + version + '_on_' + TODAY
    args = {'name': prediction_dataset_name}
    prediction_dataset = api.create_dataset(source_prediction, args)
    api.ok(prediction_dataset)

    # We then walk all through the different target, build the dataset, build the model, then run a batch prediction

    for target in PREDICTION_TARGETS:
        print("Build Target Datset for:", target,
              "with source", source_learning,
              "for Model Method", version)
        learning_dataset = buildLearningDataset(version, source_learning, target)
        print("Creating Ensemble for Target:", target,
              "in model Version:", version)

        args = {'number_of_models': 1000, 'tlp': 2}

        ensemble = api.create_ensemble(learning_dataset, args)
        api.ok(ensemble)
        createPredictions(version, target, ensemble, prediction_dataset)

        #   predictionDataset = buildDataset(source_prediction, target)


def buildLearningDataset(version, source, target):

    fields_to_exclude = []

    fields = source['object']['fields']

    for field_id, value in fields.items():
        target_field = 'TG_' + target
        print(field_id, value['name'])
        if (value['name'][:3] == 'TG_' and value['name'] != target_field) or 'WEIGHT' == value['name']:
            fields_to_exclude.append(field_id)

    print(fields_to_exclude)
    learning_dataset_name = 'learningset'  + version + '_' + target + '_on_' + TODAY
    args = {'name': learning_dataset_name,
            'excluded_fields': fields_to_exclude}

    dataset = api.create_dataset(source, args)
    api.ok(dataset)

    return dataset


def loadPredictionResults(version, target, local_filename):

    this_local_filename = './' + local_filename
    print("Opening predictions file....", local_filename)
    with open(this_local_filename) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            insertPredictionResult(row, target, version)

    cnx.commit()


def insertPredictionResult(prediction, target, version):

    print('Processing Home Team', prediction.get('Home')
          , 'vs', prediction.get('Away')
          , 'for Target:', target)

    result_field = 'TG_' + target

    predictionData = {
        'DIVISION': prediction['DIVISION'],
        'SEASON': prediction['SEASON'],
        'FIXTURE_DATE': prediction['FIXTURE_DATE'],
        'HOME_TEAM': prediction['HOME'],
        'AWAY_TEAM': prediction['AWAY'],
        'METHOD':  version,
        'TARGET': target,
        'RESULT': prediction[result_field],
        'CONFIDENCE': prediction['confidence']}

    insertPrediction = (

        "INSERT INTO MOTSON.LOAD_PREDICTION_RESULTS "
        "(SEASON, DIVISION, FIXTURE_DATE, HOME_TEAM, AWAY_TEAM, METHOD, "
        " TARGET, RESULT, CONFIDENCE) "
        " VALUES( %(SEASON)s, %(DIVISION)s,%(FIXTURE_DATE)s,%(HOME_TEAM)s,%(AWAY_TEAM)s, "
        "%(METHOD)s, %(TARGET)s, %(RESULT)s, %(CONFIDENCE)s)")

    cursor_insert = cnx.cursor()
    cursor_insert.execute(insertPrediction, predictionData)



def createPredictions(version, target, ensemble, prediction_datset):

    bp_name = 'bp_' + version + '_' + target
    print("Performing batch predictionfor", bp_name)
    batch_prediction = api.create_batch_prediction(ensemble, prediction_datset, {
        "name": bp_name, "all_fields": True,
        "header": True,
        "confidence": True})
    print(api.get_batch_prediction(batch_prediction))

    local_filename = 'temp/' + bp_name + '.csv'
    while not api.download_batch_prediction(batch_prediction, local_filename):
        time.sleep(5)

    loadPredictionResults(version, target, local_filename)



def createSource(csv_file):
    source = api.create_source(csv_file)
    api.ok(source)
    return source


def extractPredictionDataset():
    print('Extracting prediction dataset............')
    sqlstr = open('sql/predictionDataset.sql', 'r').read()
    cur = cnx.cursor()
    cur.execute(sqlstr)
    for row in cur.description:
        print(row)

    with open("temp/FPpredictionset.csv", "w", newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow([i[0] for i in cur.description])
        csv_writer.writerows(cur)

    cur.close()



def createPredictionDataset():
    print("Creating prediction set")
    source = api.create_source('./temp/FPpredictionset.csv')
    api.ok(source)
    #   api.pprint(api.get_fields(source))
    dataset = api.create_dataset(source)
    api.ok(dataset)
    #   api.pprint(api.get_fields(dataset))
    return dataset


def predictResultsFor(model, dataset, filename):
    bp_filename = filename
    print("Performing batch predictionfor", filename)
    batch_prediction = api.create_batch_prediction(model, dataset, {
        "name": bp_filename, "all_fields": True,
        "header": True,
        "confidence": True})
    #   api.ok(batch_prediction)
    print(api.get_batch_prediction(batch_prediction))

    local_filename = 'temp/' + filename + '.csv'
    while not api.download_batch_prediction(batch_prediction, local_filename):
        time.sleep(5)


def loadUnplayedFixture(unplayedFixtureRow):
    if not unplayedFixtureRow['FIXTURE_DATE']:
        return
    elif not unplayedFixtureRow['FTR']:
        return

    print('Load', unplayedFixtureRow['HOME_TEAM']
          , 'vs', unplayedFixtureRow['AWAY_TEAM'])

    dataForFixtureInsert = {
        'DIVISION': unplayedFixtureRow['DIVISION'],
        'SEASON': 16,
        'FIXTURE_DATE': datetime.datetime.strptime(unplayedFixtureRow['FIXTURE_DATE'], '%d/%m/%y'),
        'HOME_TEAM': unplayedFixtureRow['HOME_TEAM'],
        'AWAY_TEAM': unplayedFixtureRow['AWAY_TEAM'], }

    insertStatementForFixture = (

        "INSERT INTO `MOTSON`.`UNPLAYED_FIXTURES` "
        "(`DIVISION`, `FIXTURE_DATE`, `HOME_TEAM`, `AWAY_TEAM`,`SEASON`) "
        " VALUES( %(DIVISION)s,%(FIXTURE_DATE)s,%(HOME_TEAM)s,%(AWAY_TEAM)s,%(SEASON)s)")

    cursor = cnx.cursor()
    cursor.execute(insertStatementForFixture, dataForFixtureInsert)

    return 0



#-------------

def processSeasons():

    for i in range(5,16):
        processSeason(i)


def updatePosition(season, division, team, fixture_date, position):

    print("Update league position for", season, division, team, fixture_date, position)
    sql_str = ("update MOTSON.TEAM_HISTORY set league_position = %s where season =  %s and division = %s and team = %s and fixture_date = %s ")
    sql_arg = (position, season, division, team, fixture_date)
    cursor_update_team_position = cnx.cursor()
    cursor_update_team_position.execute(sql_str, sql_arg)
    cursor_update_team_position.close()



def processLeaguePositions(season, division):

    print("Process League Position", season, division)
    sql_str = ("select * from MOTSON.TEAM_HISTORY where season =  %s and division = %s order by fixture_date asc ")
    sql_arg = (season, division)
    cursor_th = cnx.cursor(buffered=True, dictionary=True)
    cursor_th.execute(sql_str, sql_arg)
    for match in cursor_th:
        this_team_gd = match['TOTAL_GOALS'] - match['TOTAL_LET_IN']

        position = calculatePosition(season, division, match['TEAM'], match['FIXTURE_DATE'], match['LEAGUE_POINTS'], this_team_gd)
        updatePosition(season,division, match['TEAM'], match['FIXTURE_DATE'], position)
    cursor_th.close()

def calculatePosition(season, division, team, fixture_date, league_points, this_team_gd ):

    print("Calculate Position", team, "on", fixture_date)
    sql_str = ("select * from MOTSON.TEAM_HISTORY where season =  %s and division = %s and fixture_date < %s and team != %s order by fixture_date desc ")
    sql_arg = (season, division, fixture_date,team)
    cursor_previous_matches = cnx.cursor(buffered=True, dictionary=True)
    cursor_previous_matches.execute(sql_str, sql_arg)
    team_points = {team : league_points}
    team_gd = {team : this_team_gd}
    team_position = {}
    for match in cursor_previous_matches:
        if match['TEAM'] not in team_points.keys():
            team_points[match['TEAM']] = match['LEAGUE_POINTS']
            team_gd[match['TEAM']] = match['TOTAL_GOALS'] - match['TOTAL_LET_IN']
    position = 0
    for team_with_points, these_points in reversed(sorted(team_points.items(), key=lambda item: (item[1], item [0]))):
        print("%s: %s" % (team_with_points, these_points))
        teams_with_same_points_gd= {team_with_points : team_gd[team_with_points]}
        for match_team, match_point in team_points.items():



            if match_point == these_points:
                teams_with_same_points_gd[match_team] = team_gd[match_team]



        print(teams_with_same_points_gd)
        print(team_gd[team_with_points])

        last_gd = None
        for team_for_position, this_gd in reversed(sorted(teams_with_same_points_gd.items(), key=lambda item: (item[1], item[0]))):
            if team_for_position not in team_position:
                if this_gd != last_gd:
                    position += 1

                team_position[team_for_position] = position
                last_gd = this_gd


    print(team_points)
    print(team_position)

    cursor_previous_matches.close()
    return team_position[team]


def processSeason(season):

    sql_str = "delete from MOTSON.TEAM_HISTORY where season = " + str(season)
    cursor_del_season = cnx.cursor()
    cursor_del_season.execute(sql_str)
    cursor_del_season.close()

    print("Process Season", season)
    sql_str = "select division as 'DIVISION', count(distinct HOME_TEAM) as 'TEAMS' from MOTSON.PLAYED_FIXTURES where season = " + str(season) + " group by DIVISION"
    cursor_divisions = cnx.cursor(buffered=True, dictionary=True)
    cursor_divisions.execute(sql_str)
    for seasons in cursor_divisions:
        processMatches(season, seasons['DIVISION'], seasons['TEAMS'])
        processLeaguePositions(season, seasons['DIVISION'])
    cursor_divisions.close()


def processDivision(season_number,division, team_tot):

    print("Process Division", season_number, division)
    sql_str = ("select distinct home_team as 'HOME_TEAM' from MOTSON.PLAYED_FIXTURES where season =  %s and division = %s ")
    sql_arg = (season_number, division)
    cursor_teams = cnx.cursor(buffered=True, dictionary=True)
    cursor_teams.execute(sql_str, sql_arg)
    for teams in cursor_teams:
        print("Process Team", teams['HOME_TEAM'])
        processMatches()

    cursor_teams.close()

def processMatches(season,division, teams):

    print("Process Matches", season, division)
    sql_str = ("select * from MOTSON.PLAYED_FIXTURES where season =  %s and division = %s ")
    sql_arg = (season, division)
    cursor_matches = cnx.cursor(buffered=True, dictionary=True)
    cursor_matches.execute(sql_str, sql_arg)
    for match in cursor_matches:
        processMatch(season, division, match['HOME_TEAM'], match['AWAY_TEAM'], match['FIXTURE_DATE'], teams)
    cursor_matches.close()

def processMatch(season, division, home_team, away_team, fixture_date, teams):

    print("Process Match: ", season, division, home_team, away_team, fixture_date)
    processTeamHistory(season,division, home_team, fixture_date, teams)

    processTeamHistory(season,division, away_team, fixture_date, teams)


def processTeamHistory(season,division, team, fixture_date, teams):

    print("Processing ", season, division, team, fixture_date)

    sql_str = ("select * from MOTSON.PLAYED_FIXTURES where season = %s and division = %s and fixture_date <  %s and home_team = %s order by fixture_date desc")
    sql_arg = (season, division, fixture_date, team)
    cursor_home_match_hist = cnx.cursor(buffered=True, dictionary=True)
    cursor_home_match_hist.execute(sql_str, sql_arg)
    hist_data = {}
    l_number_home = 1
    points = 0
    league_points = 0
    home_win= 0
    home_draw = 0
    home_concede= 0
    home_games = 0
    home_goals = 0
    home_let_in = 0

    for i in range(1,25):
        key = 'H' + '{:02d}'.format(i)
        hist_data[key] = None
        key = 'A' + '{:02d}'.format(i)
        hist_data[key] = None



    for match in cursor_home_match_hist:
        home_games += 1
        home_goals += match['FTHG']
        home_let_in += match['FTAG']
        key = 'H' + '{:02d}'.format(l_number_home)
        if match['FTR'] == 'H':
            hist_data[key] = 1
            points += 1
            home_win += 1
            league_points += 3
        elif match['FTR'] == 'A':
            hist_data[key] = -1
            home_concede += 1
        else:
            hist_data[key] = 0
            league_points += 1
            home_draw += 1
        l_number_home += 1
    cursor_home_match_hist.close()

    sql_str = ("select * from MOTSON.PLAYED_FIXTURES where season = %s and division = %s and fixture_date <  %s and away_team = %s order by fixture_date desc")
    cursor_away_match_hist = cnx.cursor(buffered=True, dictionary=True)
    cursor_away_match_hist.execute(sql_str, sql_arg)
    l_number_away = 1
    away_win= 0
    away_draw = 0
    away_concede= 0
    away_games = 0
    away_goals = 0
    away_let_in = 0

    for match in cursor_away_match_hist:
        away_games += 1
        away_goals += match['FTAG']
        away_let_in += match['FTHG']
        key = 'A' + '{:02d}'.format(l_number_away)

        if match['FTR'] == 'A':
            hist_data[key] = 1
            points += 1
            away_win += 1
            league_points += 3
        elif match['FTR'] == 'H':
            hist_data[key] = -1
            away_concede += 1
        else:
            hist_data[key] = 0
            league_points += 1
            away_draw += 1

        l_number_away += 1
    cursor_away_match_hist.close()



    print("Seq = ", min(l_number_home, l_number_away))

    hist_data['SEASON'] = season
    hist_data['DIVISION'] = division
    hist_data['TEAM'] = team
    hist_data['FIXTURE_DATE'] = fixture_date
    hist_data['SEQ'] = min(l_number_home, l_number_away)

    hist_data['POINTS'] = points
    hist_data['LEAGUE_POINTS'] = league_points

    hist_data['TOTAL_GAMES'] = home_games + away_games

    hist_data['HOME_WIN'] = home_win
    hist_data['HOME_DRAW'] = home_draw
    hist_data['HOME_CONCEDE'] = home_concede

    hist_data['AWAY_WIN'] = away_win
    hist_data['AWAY_DRAW'] = away_draw
    hist_data['AWAY_CONCEDE'] = away_concede


    hist_data['TOTAL_WIN'] = home_win + away_win
    hist_data['TOTAL_DRAW'] = home_draw + away_draw
    hist_data['TOTAL_CONCEDE'] = home_concede + away_concede

    hist_data['HOME_GAME_TOTAL'] = home_games
    hist_data['HOME_GOALS'] = home_goals
    hist_data['HOME_LET_IN'] = home_let_in

    hist_data['AWAY_GAME_TOTAL'] = away_games
    hist_data['AWAY_GOALS'] = away_goals
    hist_data['AWAY_LET_IN'] = away_let_in

    hist_data['TOTAL_GOALS'] = away_goals + home_goals
    hist_data['TOTAL_LET_IN'] = away_let_in + home_let_in

    hist_data['TEAMS_IN_LEAGUE'] = teams

    print(hist_data)

    print("Loading record: ")
    sql_loc = './sql/insert_team_history.sql'
    sqlstr = open(sql_loc, 'r').read()
    cursor_insert_team_history = cnx.cursor()
    cursor_insert_team_history.execute(sqlstr, hist_data)
    cursor_insert_team_history.close()
    cnx.commit()

#-------


def makeWinTree(season, division, home_team, away_team, fixture_date):

    print("Calculate Win Tree", home_team, "on", fixture_date)
    sql_str = ("select HOME_TEAM, AWAY_TEAM, FTHG - FTAG as 'GD' from PLAYED_FIXTURES "
               "where season =  %s and division = %s and fixture_date < %s ")
    sql_arg = (season, division, fixture_date)
    cursor_previous_matches = cnx.cursor(buffered=True, dictionary=True)
    cursor_previous_matches.execute(sql_str, sql_arg)

    print("Making Dicts")

    ht_hm_wins = {}
    ot_hm_wins = {}
    at_aw_loss = {}

    for match in cursor_previous_matches:

        if match["HOME_TEAM"] == home_team and match["GD"] >= 0 and match["AWAY_TEAM"] != away_team:
            ht_hm_wins[match["AWAY_TEAM"]] = match["GD"]

        if match["AWAY_TEAM"] == away_team and match["GD"] >= 0 and match["HOME_TEAM"] != home_team:
            at_aw_loss[match["HOME_TEAM"]] = match["GD"]


        if match["HOME_TEAM"] != home_team and \
           match["AWAY_TEAM"] != away_team and \
           match["HOME_TEAM"] != away_team and \
           match["AWAY_TEAM"] != home_team and \
           match["AWAY_TEAM"] not in ht_hm_wins and \
           match["GD"] >= 0:


            if match["HOME_TEAM"] not in ot_hm_wins:
                ot_hm_wins[match["HOME_TEAM"]] = {match["AWAY_TEAM"]:match["GD"]}
            else:
                ot_hm_wins[match["HOME_TEAM"]][match["AWAY_TEAM"]] = match["GD"]



    for key, val in ot_hm_wins.items():
        for inner_key, value in ht_hm_wins.items():

            if inner_key in ot_hm_wins[key]:
                del ot_hm_wins[key][inner_key]



    print("HOME WINS")
    print("--------------------------------------")
    print(ht_hm_wins)
    print("OTHER_WINS")
    print("--------------------------------------")
    for k,v in ot_hm_wins.items():
     print("Winner=", k, "Value-", v)
    print("AWAY_LOSSES")
    print("--------------------------------------")
    print(at_aw_loss)

    cursor_previous_matches.close()
    home_win_tree_value = calculateWinTree(home_team, away_team, ht_hm_wins, ot_hm_wins, at_aw_loss)

    print("HOME_TEAM_PATH_VALUE-----------", home_win_tree_value )



def calculateWinTree(winner, loser, winner_matches, other_matches, loser_matches):


    total_path_value = 0

    for this_loser, gd in winner_matches.items():
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Analysing branch for loser:", this_loser)
        path_value = branch(this_loser, other_matches, loser_matches, 2)
        print("Path Value = ", path_value)
        total_path_value += path_value


    return total_path_value



def branch(winner, other_matches, loser_matches, level):

    new_other_matches = copy.deepcopy(other_matches)

    this_level = level + 1
    total_path_value = 0
    if winner in other_matches:


        for this_loser, gd in other_matches[winner].items():
            dash_string = '---'
            equal_string = '==='
            for n in range(1, level*5):
                dash_string += '-'
                equal_string += '='

            total_path_value += gd




            if this_loser in loser_matches:

                total_path_value += loser_matches[this_loser]
                this_text = winner + "->" + this_loser
                print(level +1, '==', equal_string, "Processing" , winner, "->", this_loser, '==============================================')


            else:


#            if this_loser in other_matches:
#                new_other_matches = other_matches
#                del new_other_matches[this_loser]
#            else:
#                new_other_matches = other_matches


                print(level, dash_string, "Processing" , winner, "->", this_loser)


                if winner in new_other_matches:
                    del new_other_matches[winner]

                path_return = branch(this_loser, new_other_matches, loser_matches, this_level)
                if path_return > 0:
#                    print("Path Return Level =", this_level , "This PR=", path_return)
                    total_path_value += path_return


    if winner in loser_matches:
        total_path_value += loser_matches[winner]
        print(winner.rjust(this_level * 10, '-'), "Total Path=", total_path_value, "Level=",this_level)

    if winner not in loser_matches and winner not in other_matches:
        print("DEAD PATH+++++++++++++++++++++++++++++++++++++")


    return total_path_value




#--------------


def processMatchWinTrees(season, division, home_team, away_team, fixture_date):

    print("Calculate Win Trees for Match", home_team, "v", away_team, "on", fixture_date)
    sql_str = ("select HOME_TEAM, AWAY_TEAM, FTHG - FTAG as 'GD' from PLAYED_FIXTURES "
               "where season =  %s and division = %s and fixture_date < %s")
    sql_arg = (season, division, fixture_date)
    cursor_previous_matches = cnx.cursor(buffered=True, dictionary=True)
    cursor_previous_matches.execute(sql_str, sql_arg)

    print("Making Dicts")

    hm_wins = {}
    aw_wins = {}

    for match in cursor_previous_matches:

        if  match["GD"] >= 0 and \
            match["HOME_TEAM"] != away_team and \
            match["AWAY_TEAM"] != home_team:
 #           not (match["HOME_TEAM"] == home_team and match["AWAY_TEAM"] == 'Tottenham'):

            if match["HOME_TEAM"] not in hm_wins:
                hm_wins[match["HOME_TEAM"]] = {match["AWAY_TEAM"]:match["GD"]}
            else:
                hm_wins[match["HOME_TEAM"]][match["AWAY_TEAM"]] = match["GD"]




    print("HOME WINS")
    print("--------------------------------------")
    print(hm_wins)

    cursor_previous_matches.close()

    home_win_tree_value = winTreeTrunk(home_team, away_team, hm_wins)

    print("HOME_TEAM_PATH_VALUE-----------", home_win_tree_value )



def winTreeTrunk(source, target, hm_wins):


    path_value = treeBranch(source, target, hm_wins, 0, 0)


    return path_value



def treeBranch(winner, target, all_matches, level, node_points):

    new_all_matches = copy.deepcopy(all_matches)



#    if level == 1:
#        print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
#        print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
#        print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
#        print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
#        print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
#        print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
 #       print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
    this_level = level + 1
    total_path_value = 0
    if winner in all_matches:



        for this_loser, gd in all_matches[winner].items():


            dash_string = '---'
            equal_string = '==='
            for n in range(1, level*5):
                dash_string += '-'
                equal_string += '='


            if this_loser == target:


                print(level + 1 , equal_string, "Processing" , winner, "->", this_loser, '==============================================')
                if winner in new_all_matches:
                    del new_all_matches[winner]
                total_path_value += gd


            elif this_loser in all_matches:
                this_path_value = gd
                total_path_value += this_path_value

                print(level, dash_string, "Processing", winner, "->", this_loser, "Np=", node_points)


                if winner in new_all_matches:
                    del new_all_matches[winner]

                path_return = treeBranch(this_loser, target, new_all_matches, this_level, this_path_value)



                total_path_value += path_return


            #                    print("Path Return Level =", this_level , "This PR=", path_return)
            else:

                # print(level, dash_string, "Processing" , winner, "->", this_loser, "XXXXXXXXXXX  DEAD PATH  XXXXXXXXXX")
                total_path_value -= node_points





    return total_path_value



#---------------------- WIN WEB MOD

def processWinWebs(season, division, home_team, away_team, fixture_date):

    print("Calculate Win Trees for Match", home_team, "v", away_team, "on", fixture_date)
    sql_str = ("select HOME_TEAM, AWAY_TEAM, FTHG - FTAG as 'GD' from PLAYED_FIXTURES "
               "where season =  %s and division = %s and fixture_date < %s")
    sql_arg = (season, division, fixture_date)
    cursor_previous_matches = cnx.cursor(buffered=True, dictionary=True)
    cursor_previous_matches.execute(sql_str, sql_arg)

    print("Making Dicts")

    hm_wins = {}
    aw_wins = {}

    for match in cursor_previous_matches:

        if  match["GD"] >= 0 and \
            match["HOME_TEAM"] != away_team and \
            match["AWAY_TEAM"] != home_team:
       #         and \
       #     not (match["HOME_TEAM"] == home_team and match["AWAY_TEAM"] == 'Tottenham'):

            if match["HOME_TEAM"] not in hm_wins:
                hm_wins[match["HOME_TEAM"]] = {match["AWAY_TEAM"]:match["GD"]}
            else:
                hm_wins[match["HOME_TEAM"]][match["AWAY_TEAM"]] = match["GD"]




    print("HOME WINS")
    print("--------------------------------------")
    print(hm_wins)

    cursor_previous_matches.close()

    home_win_tree_value = buildPlayWeb(home_team, away_team)

    print("HOME_TEAM_PATH_VALUE-----------", home_win_tree_value )





mode = 'E2E'

if mode == '---':


    print("Start")
    processDataTransfer('defs/definitions.csv')

    runSQLJobs()

    processSQLExtracts("All")

    processPredictionModels()

elif mode == 'HISTDATA':
    processDataTransfer('defs/definitionsHist.csv')

#processSeason()

#calculatePosition(15, 'E0', 'Chelsea', '2015-12-28', 50, 8)

processMatchWinTrees(15, 'E0',  'Aston Villa','Leicester', '2015-09-29')

cnx.commit()
cnx.close()


