-----------------------------------------------------------------
--------Ranking rows across an entire table - 
-----------------------------------------------------------------
--------Stupac sa Rangiranjem po odre?enim vrijednostima - 
-----------------------------------------------------------------
-----------------------------------------------------------------
--column with ranking values order by other value
--Stupac sa vrjednostima rangiranja poredani po drugim vrijednostima

create table emp (
ID    NUMBER(4)    ,
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
end;
/


select id, name, job, HIREDATE, sal
from emp
order by sal
;

--id    name    job            hiredate          sal 
------- -----   --------       --------         ----
--7369	SMITH	  CLERK	 17- DEC-80	   800
--7654	MARTIN  SALESMAN	 17-SEP-81	  1250
--7521	WARD	  SALESMAN	 20-FEB-81	  1250
--7499	ALLEN	  SALESMAN	 20-FEB-81	  1600
--7782	CLARK	  MANAGER	  09-JUN-81	  2450
--7698	BLAKE	  MANAGER	  01-MAY-81	  2850
--7566	JONES	  MANAGER	  02-APR-81	  2975
--7788	SCOTT	  ANALYST	  09-DEC-82	  3000

--------------------------------------------------------------
-------------------------------------------------------------
-- function rank ()
-------------------------------------------------------------
select id, name, job, hiredate, sal,
      rank() over (order by hiredate) as hire_rank
from emp
order by sal
;
--Rank by date of employment (last column)
--Rankiranje prema datumu zaposljavnja (zadnji stupac)

--id    name    job           hiredate     sal    hire_rank
------- -----   --------       --------   ----       ---
--7369	SMITH	  CLERK	  17-DEC-80	  800	      1
--7654	MARTIN  SALESMAN	  17-SEP-81	  1250	7
--7521	WARD	  SALESMAN	  20-FEB-81	  1250	2
--7499	ALLEN	  SALESMAN	  20-FEB-81	  1600	2
--7782	CLARK	  MANAGER	  09-JUN-81	  2450	6
--7698	BLAKE	  MANAGER	  01-MAY-81	  2850	5
--7566	JONES	  MANAGER	  02-APR-81	  2975	4
--7788	SCOTT	  ANALYST	  09-DEC-82	  3000	8
--------------------------------------------------------------
-------------------------------------------------------------
-- dense_rank ()
-- function rank () vs dense rank
-------------------------------------------------------------
select id, name, job, hiredate, sal,
      rank() over (order by sal) as sal_rank,
      dense_rank() over (order by sal) as sal_dense_rank
from emp
order by sal
;
--dense_rank () if there are same values it ??skips 3 while the rank () stays at 3
--dense_rank() u istim vrijednostima preskace 3 dok kod rank() ostaje na 3

--id           name        job       hiredate    sal     sal_rank  sal_dense_rank
-------    --------   --------       -------     ----    --------     --------
--7369	  SMITH	  CLERK	 17-DEC-80	  800	      1	        1
-------------------------------------------------------------------
--7521	  WARD	  SALESMAN	20-FEB-81	  1250	2	        2
--7654	  MARTIN	  SALESMAN	17-SEP-81	  1250	2	        2
--7499	  ALLEN	  SALESMAN	20-FEB-81	  1600	4	        3
--------------------------------------------------------------------
--7782	  CLARK	  MANAGER	  09-JUN-81	  2450	5	        4
--7698	  BLAKE	  MANAGER	  01-MAY-81	  2850	6	        5 
--7566	  JONES	  MANAGER	  02-APR-81	  2975	7	        6
--7788	  SCOTT	  ANALYST	  09-DEC-82	  3000	8	        7

--------------------------------------------------------------
-------------------------------------------------------------
-- row_number ()
-------------------------------------------------------------
select id, name, job, hiredate, sal,
      row_number() OVER (order by sal, id) as sal_row_number
from emp
order by sal
;
--row_number () To ensure ROW_NUMBER is consistent, we must provide sorting information sufficient that we would not encounter a sorting "tie"
--In this case, id is unique.
--row_number() u istim vrijednostima može biti bilo koji redak zato moramo staviti još jednu vrijednost npr. id

--id        name      job        hiredate   sal   sal_row_number 
-------     -----   --------   --------     ----  ---------     
--7369	SMITH	  CLERK	  17-DEC-80	  800	      1
-------------------------------------------------------
--7521	WARD	  SALESMAN	  20-FEB-81	  1250	2
--7654	MARTIN  SALESMAN	  17-SEP-81	  1250	3
-------------------------------------------------------
--7499	ALLEN	  SALESMAN	  20-FEB-81	  1600	4
--7782	CLARK	  MANAGER	  09-JUN-81	  2450	5
--7698	BLAKE	  MANAGER	  01-MAY-81	  2850	6
--7566	JONES	  MANAGER	  02-APR-81	  2975	7
--7788	SCOTT	  ANALYST	  09-DEC-82	  3000	8


--made by: Stjepan Mudronja
