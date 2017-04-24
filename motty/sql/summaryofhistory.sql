select 

round(pf.B365H,2) 'Point',

avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  'Back Earnings',

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'A'
then 1
when pf.FTR = 'D'
then (-1 * pf.B365D) + 1  
end )  'Lay Earnings',

avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  +

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'A'
then 1
when pf.FTR = 'D'
then (-1 * pf.B365D) + 1
end )  'Total Earnings',

avg(1+ B365D -1) 'Liabilty',


(avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  +

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'A'
then 1
when pf.FTR = 'D'
then (-1 * pf.B365D) + 1
end ) ) /

avg(1+ B365D -1) '% Earnings',

count(*) 'Count'



from FOOTBALL_PREDICT.PLAYED_FIXTURES pf
where pf.B365H < pf.B365D
and pf.B365H < pf.B365A
and pf.B365H <= 1.14
and pf.SEASON = 16

group by 
round(pf.B365H,2);








select 

avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  'Back Earnings',

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'A'
then 1
when pf.FTR = 'D'
then (-1 * pf.B365D) + 1  
end )  'Lay Earnings',

avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  +

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'A'
then 1
when pf.FTR = 'D'
then (-1 * pf.B365D ) + 1 
end )  'Total Earnings',

avg(1+ B365D -1) 'Liabilty',


(avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  +

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'A'
then 1
when pf.FTR = 'D'
then (-1 * pf.B365D) + 1
end ) ) /

avg(1+ B365D -1) '% Earnings',

count(*) 'Count',

avg( case when pf.FTR = 'D' then 1 else 0 end) 'Draw %',
avg( case when pf.FTR = 'A' then 1 else 0 end) 'Opp %'



from FOOTBALL_PREDICT.PLAYED_FIXTURES pf
where pf.B365H < pf.B365D
and pf.B365H < pf.B365A
and pf.B365H <= 1.14
and pf.SEASON = 16;






select 

avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  'Back Earnings',

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'D'
then 1
when pf.FTR = 'A'
then (-1 * pf.B365A) + 1
end )  'Lay Earnings',

avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  +

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'D'
then 1
when pf.FTR = 'A'
then (-1 * pf.B365A  ) +1
end )  'Total Earnings',

avg(1+ B365A -1) 'Liabilty',


(avg(case when pf.FTR = 'H'
then (1 * pf.B365H) - 1
else - 1
end )  +

avg(case when pf.FTR = 'H'
then 1
when pf.FTR = 'D'
then 1
when pf.FTR = 'A'
then (-1 * pf.B365A) + 1 
end ) ) /

avg( B365A ) '% Earnings',

count(*) 'Count',

avg( case when pf.FTR = 'D' then 1 else 0 end) 'Draw %',
avg( case when pf.FTR = 'A' then 1 else 0 end) 'Opp %'



from FOOTBALL_PREDICT.PLAYED_FIXTURES pf
where pf.B365H < pf.B365D
and pf.B365H < pf.B365A
and pf.B365H < 2
and pf.SEASON = 16



