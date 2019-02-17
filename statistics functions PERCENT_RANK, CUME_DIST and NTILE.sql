-----------------------------------------------------------------
--------PERCENT_RANK, CUME_DIST and NTILE functions - 
-----------------------------------------------------------------
--------Statisticke funkcije  - PERCENT_RANK, CUME_DIST i NTILE
-----------------------------------------------------------------
-----------------------------------------------------------------
--Statistic functions
--Statisticke funkcije


create table emp (
ID    NUMBER(4) primary key   ,
NAME             VARCHAR2(10) ,
JOB               VARCHAR2(9)  ,
HIREDATE          DATE         ,
SAL               NUMBER(7,2)  
);
/


begin
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7369,'SMITH','CLERK',to_date('17/DEC/1980','DD/MON/YYYY'),800);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7499,'ALLEN','SALESMAN',to_date('20/FEB/1981','DD/MON/YYYY'),1600);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7521,'WARD','SALESMAN',to_date('20/FEB/1981','DD/MON/YYYY'),1250);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7566,'JONES','MANAGER',to_date('02/APR/1981','DD/MON/YYYY'),2975);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7654,'MARTIN','SALESMAN',to_date('17/SEP/1981','DD/MON/YYYY'),1025);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7698,'BLAKE','MANAGER',to_date('01/MAY/1981','DD/MON/YYYY'),2850);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7782,'CLARK','MANAGER',to_date('09/JUN/1981','DD/MON/YYYY'),2450);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7788,'SCOTT','ANALYST',to_date('09/DEC/1982','DD/MON/YYYY'),3000);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7799,'SAM','ANALYST',to_date('11/DEC/1985','DD/MON/YYYY'),4000);
Insert into emp (id,NAME,JOB,HIREDATE,SAL) values (7100,'ALLAN','MANAGER',to_date('15/DEC/1991','DD/MON/YYYY'),5000);
end;
/

select count(*) from emp
;
--COUNT(*)    
----- 
--10

select * from emp
order by sal desc
;
------------------------------------------------------------------
--Poredati sve koji imaju placu vecu od 700 statisticki - tj. postotak nadmasivanja te place
--Sort all who have a salary greater than 700 statistical - the percentage of surpassing that salary
------------------------------------------------------------------
--PERCENT_RANK - vraca vrijednost izmedju 1 i 0 - radi cistoce pomnoziti cemo sa 100. 
-- - postotak redova koji su ispod neke vrijednosti
-- znaci najveca vrijednost ce biti 100
----------------------------------------------------------------------
--PERCENT_RANK - formula (rank of row - 1)/(total number of rowa - 1)
-----------------------------------------------------------------------
select name,  sal,
      100*percent_rank() over (order by sal) as pctrank
from emp
order by sal
;

-- ako uzmemo SCOTT ANALYST znamo ima placu vecu od 77% redaka, zato sto ne ukljucujemo sami redak
--if we take SCOTT ANALYST we know we have a salary of more than 77% of lines because we do not include the row we are now


--name    sal            pctrank
------   ------      ------------------------
--SMITH	   800	             0
--MARTIN	1025	  11.11111111111111111111111111111111111111
--WARD	  1250	  22.22222222222222222222222222222222222222
--ALLEN	  1600	  33.33333333333333333333333333333333333333
--CLARK	  2450	   44.44444444444444444444444444444444444444
--BLAKE	  2850	  55.55555555555555555555555555555555555556
--JONES	  2975	  66.66666666666666666666666666666666666667
--SCOTT	  3000	  77.77777777777777777777777777777777777778
--SAM	   4000	    88.88888888888888888888888888888888888889
--ALLAN	  5000	   100



----------------------------------------------------------------------------------
--CUME_DIST - vraca vrijednost izmedju 1 i 0 - radi cistoce pomnoziti cemo sa 100. 
-- - postotak redova koji su ispod neke vrijednosti - sa ukljucenim tim redom
-- znaci najveca vrijednost ce biti 100
----------------------------------------------------------------------
--CUME_DIST - formula (rank of row )/(total number of rowa )
-----------------------------------------------------------------------

select name,  sal,
      100*CUME_DIST() over (order by sal) as pctrank
from emp
order by sal
;
--name    job     pctrank
------   ------   --------
--SMITH	  800	      10
--MARTIN	1025	   20
--WARD	  1250	   30
--ALLEN	  1600	   40
--CLARK	  2450	    50
--BLAKE	  2850	   60
--JONES	  2975	   70
--SCOTT	  3000	    80
--SAM	    4000	   90
--ALLAN	  5000	   100
----------------------------------------------------------------------------------
--NTILE - sjecakanje podataka na polovine, cetvrtine, sestine... 
-- i grupiranje u grupe
----------------------------------------------------------------------

select name, sal,
      ntile(5) over (order by sal desc) as pctrank
from emp
order by sal
;
-- SMITH CLERK i MARTIN SALESMAN su sa najnizim placama i oni su dobili broj 4
--posto smo ih poredli po petinama sa najvecim placama su dobili najmanji broj
--

--name    job     pctrank
------   ------   --------
--SMITH	   800	   5
--MARTIN	1025	   5
--WARD	  1250	   4
--ALLEN	  1600	   4
--CLARK	  2450	   3
--BLAKE	  2850	   3
--JONES	  2975	   2
--SCOTT	  3000	   2
--SAM	   4000	     1
--ALLAN	  5000	   1


--made by: Stjepan Mudronja





