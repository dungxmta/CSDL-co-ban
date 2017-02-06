---buoi 6_ BaiTH6

-------------------Bai2
create database TTCSDL_TH6_SINHVIEN
go
use TTCSDL_TH6_SINHVIEN

create table STUDENT( name nchar(30), subject nchar(10), mark float)

insert into STUDENT
values ('Dungx','java',8),
	('Dungx','C',9),
	('Dungx','C',8),
	('Dungx','SQL',7),
	('Thinh','JAVA',6),
	('Thinh','C',5),
	('Thinh','SQL',4),
	('Thinh','SQL',8)

select * from STUDENT

---AVG: diem TB tung mon
select name as [Student name], subject as [Subject name],
AVG(mark) as [Average mark] from student group by name, subject

---WITH ROLLUP: diem TB sv
select name as [Student name], subject as [Subject name], 
avg(mark) as [Average mark] from STUDENT group by name, subject
with rollup
---GROUPING: thay gia tri NULL cho cac o khi dung ROLLUP
select
case when GROUPING(name)=1 then 'All students' else name end as [Student name],
case when GROUPING(subject)=1 then 'All subjects' else subject end as [Subject name],
CAST(AVG(mark) as decimal(9,2)) as [Average mark]
from STUDENT group by name, subject with rollup

---CUBE
select
case when GROUPING(name)=1 then 'All students' else name end as [Student name],
case when GROUPING(subject)=1 then 'All subjects' else subject end as [Subject name],
CAST(AVG(mark) as decimal(9,2)) as [Average mark]
from STUDENT group by name, subject with CUBE


