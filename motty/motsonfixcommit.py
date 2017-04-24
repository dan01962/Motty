from lxml import html
import requests
import csv
from urllib.request import urlopen
import mysql.connector
from contextlib import suppress
from bs4 import BeautifulSoup
from datetime import datetime

DEFINITION_FILE = 'definitionstest.csv'
DB_USER = 'user'
DATABASE = 'MOTSON'
PASSWORD = 'pswd'
HOST = 'localhost'

cnx = mysql.connector.connect(user=DB_USER, database=DATABASE,
                               host=HOST, password=PASSWORD)



def processUnmapped():
    
    with open("temp/unmapped.csv") as csvfile:
         reader = csv.DictReader(csvfile)
         for row in reader:
           try:
                if row['Selected'] == 'x' or row['Selected'] == 'X':
                    print("Updating: ", row['OddscheckName'])
                    print("To      : ", row['HomeTeam'])
                    updateTeamMapping(row['OddscheckName'], row['HomeTeam'])

           except KeyError:
               print('Data in Definition file not formatted properly')



def updateTeamMapping(oddscheck_name, results_name):


    updateStatement = (
        "UPDATE MOTSON.TEAM_MAPPING SET RESULTS_NAME = %s  "
        "WHERE ODDSCHECK_NAME = %s")

    cursor = cnx.cursor()
    cursor.execute(updateStatement, (results_name,oddscheck_name))


def deleteUnplayedFixtures():


    print("Deleting Unplayed Fixtures")
    deleteStatement = (
        "DELETE FROM MOTSON.UNPLAYED_FIXTURES")

    cursor = cnx.cursor()
    cursor.execute(deleteStatement)


def loadUnplayedFixtures():

    print("Inserting Unplayed Fixtures")
    insertStatement = (
        "INSERT INTO MOTSON.UNPLAYED_FIXTURES SELECT "
        "LUP.SEASON, "
        "LUP.DIVISION, "
        "case when (SELECT TM.RESULTS_NAME  "
        "		FROM MOTSON.TEAM_MAPPING TM "
        "           WHERE TM.ODDSCHECK_NAME = LUP.HOME_TEAM) "
        "        	!=    HOME_TEAM "
        "     then  (SELECT TM.RESULTS_NAME  "
        "            FROM MOTSON.TEAM_MAPPING TM "
        "            WHERE TM.ODDSCHECK_NAME = LUP.HOME_TEAM) "
        "     else  LUP.HOME_TEAM end 'HOME_TEAM', "
        "case when (SELECT TM.RESULTS_NAME  "
        "           FROM MOTSON.TEAM_MAPPING TM "
        "           WHERE TM.ODDSCHECK_NAME = LUP.AWAY_TEAM) "
        "        	!=    AWAY_TEAM "
        "     then  (SELECT TM.RESULTS_NAME  "
        "    	 FROM MOTSON.TEAM_MAPPING TM "
        "            WHERE TM.ODDSCHECK_NAME = LUP.AWAY_TEAM) "
        "     else  LUP.AWAY_TEAM end 'AWAY_TEAM', "
        "LUP.FIXTURE_DATE, "
        "LUP.ODDS_HOME, "
        "LUP.ODDS_DRAW, "
        "LUP.ODDS_AWAY "
        "FROM "
        "	MOTSON.LOAD_UNPLAYED_FIXTURES LUP ")

    cursor = cnx.cursor()
    cursor.execute(insertStatement)

    print("Committing load")
    cnx.commit()


def mappingComplete():

    selectStatement = ("select count(*) 'count' from MOTSON.TEAM_MAPPING where results_name is null")
    cursor = cnx.cursor()
    cursor.execute(selectStatement)
    for result in cursor:
        print("Unmapped teams: ", result[0])
        if int(result[0]) == 0:
            return 1
        else:
            return 0

 


processUnmapped()

if mappingComplete():
    print("Mapping complete... proceed")
    deleteUnplayedFixtures()
    loadUnplayedFixtures()
else:
    print("Mapping incomplete, rolling back changes")
    cursor.rollback()
    
cnx.close()




