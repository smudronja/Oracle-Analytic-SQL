-----------------------------------------------------------------
--------NULLS in Analytics - 
-----------------------------------------------------------------
--------Nulls in Analytics
-----------------------------------------------------------------
-----------------------------------------------------------------
--how nulls are treated
--Kako se nosi sa null vrijednostima


create table emp (
ID    NUMBER(4) primary key   ,
NAME             VARCHAR2(10) ,
JOB               VARCHAR2(9)  ,
HIREDATE          DATE         
);
/

begin
Insert into emp (id,NAME,JOB,HIREDATE) values (7369,'SMITH','CLERK',to_date('17/DEC/1980','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7499,'ALLEN','SALESMAN',to_date('20/FEB/1981','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7521,'WARD','SALESMAN',to_date('20/FEB/1981','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7566,'JONES','MANAGER',to_date('02/APR/1981','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7654,'MARTIN','SALESMAN',to_date('17/SEP/1981','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7698,'BLAKE','MANAGER',to_date('01/MAY/1981','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7782,'CLARK','MANAGER',to_date('09/JUN/1981','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7788,'SCOTT','ANALYST',to_date('09/DEC/1982','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7799,'SAM','ANALYST',to_date('11/DEC/1985','DD/MON/YYYY'));
Insert into emp (id,NAME,JOB,HIREDATE) values (7100,'ALLAN','MANAGER',to_date('15/DEC/1991','DD/MON/YYYY'));
end;
/

create table sal (
id number(4),
SAL               NUMBER(7,2),
emp_ID int ,
 CONSTRAINT emp FOREIGN KEY (emp_id)
    REFERENCES emp(id)
);
/

begin
Insert into sal (id,emp_ID,SAL) values (1,7369,800);
Insert into sal (id,emp_ID,SAL) values (2,7499,1600);
Insert into sal (id,emp_ID,SAL) values (3,7521,1250);
Insert into sal (id,emp_ID,SAL) values (4,7566,2975);
Insert into sal (id,emp_ID,SAL) values (5,7654,1025);
Insert into sal (id,emp_ID,SAL) values (6,7698,2850);
Insert into sal (id,emp_ID,SAL) values (7,7782, null);
Insert into sal (id,emp_ID,SAL) values (8,7788, null);
Insert into sal (id,emp_ID,SAL) values (9,7799,4000);
Insert into sal (id,emp_ID,SAL) values (10,7100,5000);
end;
/




------------------------------------------------------------------
--poredati zaposlenike po velicini place. OPREZ: postoje null vrijednosti
--Sort employees by the size of their wages. CAUTION: There are null values


select e.id,e.name, s.sal,
      row_number() over (order by s.sal desc) as sal_rank
from emp e, sal s
where 1= 1
and e.id = s.emp_id
order by sal_rank
;



--name    name    sal        pctrank
------   ------  ------   ------------------------
--7782	  CLARK		              1
--7788	  SCOTT		              2
--7100	  ALLAN	   5000	          3
--7799	  SAM	     4000	        4
--7566	  JONES	   2975	        5
--7698	  BLAKE	   2850	        6
--7499	  ALLEN	   1600       	7
--7521	  WARD	   1250       	8
--7654	  MARTIN	1025	        9
--7369	  SMITH	   800	        10

--vrijednosti sa null se prve prikazuju pod 1 i 2 pctrank
--values ??with null are first displayed under 1 and 2 pctrank

-------------------------------------------------------------
--NULLS LAST 
-------------------------------------------------------------
--kako bi to izbjegi stavljamo nulls last
--To avoid this, we put nulls last

select e.id,e.name, s.sal,
      row_number() over (order by s.sal desc NULLS LAST) as sal_rank
from emp e, sal s
where 1= 1
and e.id = s.emp_id
order by sal_rank
;

--name    name    sal        pctrank
------   ------  ------   ------------------------
--7100	ALLAN	    5000	        1
--7799	SAM	      4000	        2
--7566	JONES	    2975	        3
--7698	BLAKE   	2850	        4
--7499	ALLEN	    1600	        5
--7521	WARD	    1250	        6
--7654	MARTIN	  1025	        7
--7369	SMITH	    800	          8
--7788	SCOTT		                9
--7782	CLARK		                10


--------------------------------------------------
-- in ranking functions null = null 
--otherwise null != null
--example rank()
---------------------------------------------------

select e.id,e.name, s.sal,
      rank() over (order by s.sal desc) as sal_rank
from emp e, sal s
where 1= 1
and e.id = s.emp_id
order by sal_rank
;

--name    name    sal        pctrank
------   ------  ------   ------------------------
--7782	CLARK		                1
--7788	SCOTT		                1
--7100	ALLAN	    5000	        3
--7799	SAM	      4000	        4
--7566	JONES	     2975	        5
--7698	BLAKE	     2850	        6
--7499	ALLEN	     1600       	7
--7521	WARD	     1250	        8
--7654	MARTIN	   1025	        9
--7369	SMITH	      800	        10



--made by: Stjepan Mudronja
