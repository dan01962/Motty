from lxml import html
import requests
import csv
from urllib.request import urlopen
import mysql.connector
from contextlib import suppress
from bs4 import BeautifulSoup
from datetime import datetime

DEFINITION_FILE = 'defs/definitions.csv'
DB_USER = 'user'
DATABASE = 'MOTSON'
PASSWORD = 'pswd'
HOST = 'localhost'

cnx = mysql.connector.connect(user=DB_USER, database=DATABASE,
                               host=HOST, password=PASSWORD)

matches = []

def loadLeague(league, bestodds_url, season):
    
    print("Processing League: ", league, "At URL: ", bestodds_url)
    print("-----------------------------------------------------------------")
    page = urlopen(bestodds_url)
    soup = BeautifulSoup(page, 'lxml')
    fixturesTable = soup.find(id = "fixtures")
    date = ''

    try:
        for row in fixturesTable.find_all('tr'):
            rowType, value = processRow(row)
            if rowType == 'date':
                date = value
            elif rowType == 'match':
                this_match = value
                this_match['FixtureDate'] = date
                this_match['League'] = league
                this_match['Season'] = season
                print("Capturing match...................")
                print(this_match)
                matches.append(this_match)
    except:
        return

def processRow(row):

    with suppress(TypeError):
        if row.td['class'] == ['day', 'slanted']:
            date = getDate(row.span.text)
            print("New date+++++++++++++++")
            return('date', date)

    with suppress(KeyError):
        if row['class'][0] == 'match-on':
            match = getMatch(row)
            return('match', match)

    return('None', 'None')

def getMatch(row):
        teams = row.find_all('span', {'class' : 'fixtures-bet-name'})
        home_team = teams[0].text
        away_team = teams[2].text
        odds = row.find_all('span', {'class' : 'odds'})

        match = {'HomeTeam' : home_team,
                 'AwayTeam' : away_team,
                 'OddsHome' : getDecimalOdds(odds[0].text),
                 'OddsDraw' : getDecimalOdds(odds[1].text),
                 'OddsAway' : getDecimalOdds(odds[2].text)}
        
        return match



def getDecimalOdds(odds):

    odds = odds.strip(' ()')
    odds = odds.split('/')
    decimal_odds = round(int(odds[0]) / int(odds[1]),2)
    return decimal_odds
    

def getDate(text_date):

    text_date = text_date.strip()
    date = text_date.split(' ')
    day = date[1][:-2]
    month = date[2]
    year = date[3]
    date = day + ' ' + month + ' ' + year
    date = datetime.strptime(date, '%d %B %Y')
    date = date.strftime("%Y-%m-%d")

    return date
    
       

def processLeagues():
    
    with open(DEFINITION_FILE) as csvfile:
         reader = csv.DictReader(csvfile)
         for row in reader:
           try:
               loadLeague(row['League'],row['BestOddsURL'], row['Season'])
                
           except KeyError:
               print('Data in Definition file not formatted properly')



def loadMatchestoDB():



    for match in matches:


        insertStatementForFixture = (
            "INSERT INTO `MOTSON`.`LOAD_UNPLAYED_FIXTURES` "
            "(`DIVISION`, `FIXTURE_DATE`, `HOME_TEAM`, `AWAY_TEAM`,`SEASON`, `ODDS_HOME`, `ODDS_DRAW`, `ODDS_AWAY`) "
            " VALUES( %(League)s,%(FixtureDate)s,%(HomeTeam)s,%(AwayTeam)s,%(Season)s,%(OddsHome)s,%(OddsDraw)s,%(OddsAway)s)")

        cursor = cnx.cursor()
        cursor.execute(insertStatementForFixture, match)


def findUnmapped():

    print("Updating Team Mapping with Not Found Home Teams")
    insertTeamMappings = (
        "insert into MOTSON.TEAM_MAPPING (division, oddscheck_name) "
        "select distinct division, home_team "
        "from "
        "MOTSON.LOAD_UNPLAYED_FIXTURES "
        "where (home_team not in (select home_team from MOTSON.PLAYED_FIXTURES) or "
        "       home_team not in (select away_team from MOTSON.PLAYED_FIXTURES)) "
        "and   home_team not in (select oddscheck_name from MOTSON.TEAM_MAPPING)" )

    cursor = cnx.cursor()
    cursor.execute(insertTeamMappings)

    print("Updating Team Mapping with Not Found Away Teams")

    insertTeamMappings = (
        "insert into MOTSON.TEAM_MAPPING (division, oddscheck_name) "
        "select distinct division, away_team "
        "from "
        "MOTSON.LOAD_UNPLAYED_FIXTURES "
        "where (away_team not in (select home_team from MOTSON.PLAYED_FIXTURES) or "
        "       away_team not in (select away_team from MOTSON.PLAYED_FIXTURES)) "
        "and   away_team not in (select oddscheck_name from MOTSON.TEAM_MAPPING)" )
    
    cursor = cnx.cursor()
    cursor.execute(insertTeamMappings)

def deleteLoadUnplayed():
    deleteStatement = ("delete from MOTSON.LOAD_UNPLAYED_FIXTURES")
    cursor = cnx.cursor()
    cursor.execute(deleteStatement)
    


def reportUnmapped():

    print("Extract the mapping file")
    selectStatement = (
        "select distinct tm.division 'Division' ,tm.oddscheck_name 'OddscheckName', pf.home_team 'HomeTeam', null 'Selected' "
        "from MOTSON.TEAM_MAPPING tm, "
        "MOTSON.PLAYED_FIXTURES pf "
        "where tm.results_name is null "
        "and   tm.DIVISION = pf.DIVISION "
        "order by 1,2,3 ")

    cursor = cnx.cursor()
    cursor.execute(selectStatement)

    with open("temp/unmapped.csv", "w", newline='') as csv_file:              
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow([i[0] for i in cursor.description]) 
        csv_writer.writerows(cursor)

    selectStatement = ("select count(*) 'count' from MOTSON.TEAM_MAPPING where results_name is null")
    cursor = cnx.cursor()
    cursor.execute(selectStatement)
    for result in cursor:
        print("Unmapped teams: ", result[0])
    


    

    
    

    

    

        


processLeagues()
deleteLoadUnplayed()
loadMatchestoDB()

findUnmapped()
reportUnmapped()

cnx.commit()
cnx.close()





