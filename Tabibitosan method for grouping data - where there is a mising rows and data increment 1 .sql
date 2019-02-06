-----------------------------------------------------------------
--------Grouping data wher number incline by 1 and where exist mising data
-----------------------------------------------------------------
--------Grupiranje podataka gdje se vrijednost povecava za 1 i gdje ne postoje odredeni redci (podaci) 
-----------------------------------------------------------------
-----------------------------------------------------------------
--columns where data increase by 1 group.
--Redovi koji se povecavaju za 1 grupirani

create table LAB_SAMPLES
 ( sample_id          int default LAB_SAMPLES_SEQ.NEXTVAL,
   date_taken  date
 );
 --NEXTVAL: Increments the sequence and returns the next value
 --
/


begin
-- values (date '2015-12-01') we are inserting only 1 value because sample_id is auto incrament. And the value is in date value
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-01');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-02');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-03');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-04');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-07');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-08');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-09');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-10');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-14');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-15');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-16');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-19');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-20');
end;
/


select * from lab_samples
order by date_taken
;
--we can se that some dates are missing
--vidimo da odre?enih datuma nema, mi želimo grupirati po datumima kojih ima

--sample_id  date_taken    
----         -------
--1	       01-DEC-15
--2	       02-DEC-15
--3	       03-DEC-15
--4	       04-DEC-15
------------------------
--5	       07-DEC-15
--6	       08-DEC-15
--7	       09-DEC-15
--8	       10-DEC-15
-------------------------
--9	       14-DEC-15
--10	     15-DEC-15
--11	     16-DEC-15
-----------------------
--12	     19-DEC-15
--13	     20-DEC-15

--------------------------------------------------------------
-------------------------------------------------------------
-- row_number()
-------------------------------------------------------------
select date_taken,
      row_number() over(order by date_taken) as rn
      from lab_samples
order by sample_id
;
--Rank by date_taken from 1 to 13
--Rangiranje prema datumu dobivanja uzorka

--date_taken  rn    
----         -------
--01-DEC-15	  1
--02-DEC-15	  2
--03-DEC-15	  3
--04-DEC-15	  4
--07-DEC-15	  5
--08-DEC-15	  6
--09-DEC-15	  7
--10-DEC-15	  8
--14-DEC-15	  9
--15-DEC-15	  10
--16-DEC-15	  11
--19-DEC-15	  12
--20-DEC-15	  13
--------------------------------------------------------------
-------------------------------------------------------------
-- date_taken-row_number()
-------------------------------------------------------------

select date_taken,
      date_taken-row_number() over (order by date_taken) as delta
      from lab_samples
order by date_taken
;
--ovdje oduzimamo vrijednost date_taken npr 01.12.15 - 1 = 30.11.15
--here we are deduct date_taken-row_number() ex. 01.12.15 - 1 = 30.11.15

--date_taken    delta 
---------     --------   
--01-DEC-15	  30-NOV-15
--02-DEC-15	  30-NOV-15
--03-DEC-15	  30-NOV-15
--04-DEC-15	  30-NOV-15
--07-DEC-15	  02-DEC-15
--08-DEC-15	  02-DEC-15
--09-DEC-15	  02-DEC-15
--10-DEC-15	  02-DEC-15
--14-DEC-15	  05-DEC-15
--15-DEC-15	  05-DEC-15
--16-DEC-15	  05-DEC-15
--19-DEC-15	  07-DEC-15
--20-DEC-15	  07-DEC-15


--------------------------------------------------------------
-------------------------------------------------------------
-- group by date
-------------------------------------------------------------
select min (date_taken) date_from,
      max(date_taken) date_to,
      count(*) num_samples
from (
    select date_taken,
          date_taken-row_number() over(order by date_taken) as delta
          from lab_samples
) group by delta
order by date_from
;
--Ovdje uzimamo interval maximalnog datuma u grupi i minimalnog datuma u grupi i racunam koliko ih je
--Here we take the interval of the maximum date in the group and the minimum date in the group and calculate how many them

--date_from   date_to   num_samples 
-------      --------   ------     
--01-DEC-15	  04-DEC-15	  4
--07-DEC-15	  10-DEC-15	  4
--14-DEC-15	  16-DEC-15	  3
--19-DEC-15	  20-DEC-15	  2

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--we are going to inser more same rows in table
--dodati cemo iste vrijednosti u tablicu
begin
-- we now have three same values in table
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-01');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-02');
insert into LAB_SAMPLES ( date_taken) values (date '2015-12-19');
end;
/
-----------------------------------------------------------
-- date_taken-row_number()
-------------------------------------------------------------
--sada imamo krive podatke
--now we have wrong data
--date_taken    delta 
---------     -------- 
--01-DEC-15	  30-NOV-15
--01-DEC-15	  29-NOV-15
--02-DEC-15	  29-NOV-15
--02-DEC-15	  28-NOV-15
--03-DEC-15	  28-NOV-15
--04-DEC-15	  28-NOV-15
--07-DEC-15	  30-NOV-15
--08-DEC-15	  30-NOV-15
--09-DEC-15	  30-NOV-15
--10-DEC-15	  30-NOV-15
--14-DEC-15	  03-DEC-15
--15-DEC-15	  03-DEC-15
--16-DEC-15	  03-DEC-15
--19-DEC-15	  05-DEC-15
--19-DEC-15	  04-DEC-15
--20-DEC-15	  04-DEC-15
--------------------------------------------------------------
-------------------------------------------------------------
-- dense_rank() 
-------------------------------------------------------------
--now we use dense_rank and again group the resultat
--sada koristimo dense_rank() i ponovno grupiramo
select date_taken,
      date_taken-dense_rank() over (order by date_taken) as delta
      from lab_samples
order by date_taken
;
--date_taken    delta 
---------     -------- 
--01-DEC-15	  30-NOV-15
--01-DEC-15	  30-NOV-15
--02-DEC-15	  30-NOV-15
--02-DEC-15	  30-NOV-15
--03-DEC-15	  30-NOV-15
--04-DEC-15	  30-NOV-15
--07-DEC-15	  02-DEC-15
--08-DEC-15	  02-DEC-15
--09-DEC-15	  02-DEC-15
--10-DEC-15	  02-DEC-15
--14-DEC-15	  05-DEC-15
--15-DEC-15	  05-DEC-15
--16-DEC-15	  05-DEC-15
--19-DEC-15	  07-DEC-15
--19-DEC-15	  07-DEC-15
--20-DEC-15	  07-DEC-15
--------------------------------------------------------------
-------------------------------------------------------------
-- group by date
-------------------------------------------------------------
select min (date_taken) date_from,
      max(date_taken) date_to,
      count(*) num_samples
from (
    select date_taken,
          date_taken-dense_rank() over(order by date_taken) as delta
          from lab_samples
) group by delta
order by date_from
;
--date_from   date_to   num_samples 
-------      --------   ------   
--01-DEC-15	  04-DEC-15	  6
--07-DEC-15	  10-DEC-15  	4
--14-DEC-15	  16-DEC-15  	3
--19-DEC-15	  20-DEC-15	  3

--made by: Stjepan Mudronja