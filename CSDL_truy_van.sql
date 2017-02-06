--số da theo từng nv
CREATE VIEW BB1 AS
select nv.MANV,hoten, count(mada) soDA
from NHANVIEN nv,PHANCONG pc
where nv.MANV=pc.MANV
group by nv.MANV,pc.MANV,HOTEN

--đếm số nv đc gs theo từng mã ngs
select n1.MANGS,n2.HOTEN, COUNT(n1.manv)
from NHANVIEN n1,NHANVIEN n2
where n1.MANGS=n2.MANV
group by n1.MANGS,n2.HOTEN

---nv là tp tham gia nhiều da nhất
select top 1 with ties nv.MANV,HOTEN, count(MADA)
from NHANVIEN nv,PHANCONG pc,PHONGBAN pb
where nv.MANV=pc.MANV and pc.MANV=pb.MATP
group by nv.MANV,HOTEN
order by count(MADA) desc
------------------------------
select * from NHANVIEN
select * from PHONGBAN
--đưa ra họ tên của người gs
select manv, hoten
from NHANVIEN
where MANV=MANGS

---đưa ra pb có số lượng nv = nhau
create view b11 as
select count(MANV) slnv,MAPB
from NHANVIEN 
group by MAPB

create view b12 as
select count(mapb) slpb,slnv
from b11
group by slnv

DROP VIEW b11

select b11.MAPB,tenpb,b11.slnv
from b11,PHONGBAN,b12
where b11.mapb=PHONGBAN.MAPB and b12.slpb>2 and b12.slnv=b11.slnv
---