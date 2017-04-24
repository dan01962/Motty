delete from LEARNING_V1
where SEASON = (select max(SEASON) from PLAYED_FIXTURES)



