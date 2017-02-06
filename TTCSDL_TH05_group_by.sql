select * from NHANVIEN
select * from PHANCONG
select * from DUAN
select * from PHONGBAN
select * from THANNHAN

--------------------------------------------------------
-----#TH5-----------------------------------------------

--1. ds nv có lương lớn nhất thuộc phòng 'TH', sx giảm
select MANV, HOTEN, NGAYSINH, LUONG, TENPB
from NHANVIEN nv, PHONGBAN pb
where nv.MAPB=pb.MAPB and TENPB=N'Hành chính'
order by LUONG desc
--
select MANV, HOTEN, NGAYSINH, LUONG
from NHANVIEN
where MAPB in (select MAPB from PHONGBAN where TENPB=N'Hành chính')
order by LUONG desc

--2 & 5.ds nv có lương lớn nhất theo từng pb
select MANV, HOTEN, NGAYSINH, LUONG, TENPB
from NHANVIEN nv, PHONGBAN pb
where nv.MAPB=pb.MAPB 
	and LUONG in (SELECT MAX (LUONG) FROM NHANVIEN GROUP BY MAPB)

--3. tổng lương theo từng pb
select pb.MAPB, TENPB, TongLuong
from PHONGBAN pb, (select mapb,SUM(luong) TongLuong 
					from NHANVIEN 
					group by MAPB) TL
where pb.MAPB=TL.MAPB

--4. lương lớn nhất theo từng pb
select pb.MAPB, TENPB, MaxLuong
from PHONGBAN pb, (select mapb, MAX(LUONG) MaxLuong
					from NHANVIEN
					group by MAPB ) MaxL_P
where pb.MAPB=MaxL_P.MAPB
--
select pb.MAPB, TENPB, LUONG
from NHANVIEN nv, PHONGBAN pb
where nv.MAPB=pb.MAPB 
	and LUONG in (SELECT MAX (LUONG) FROM NHANVIEN GROUP BY MAPB)

--6. pb có nv nhận lương max
select pb.MAPB, TENPB, MANV, HOTEN, LUONG
from PHONGBAN pb, NHANVIEN nv
where pb.MAPB=nv.MAPB
	and LUONG in (select max(Luong) LUONG from NHANVIEN)

--7. đếm số nv từng pb, đưa ra các pb chưa có TP
select pb.MAPB, TENPB, SoNV
from PHONGBAN pb, ( select mapb, COUNT(nv.MANV) SoNV
					from NHANVIEN nv
					group by MAPB ) so_nv
where pb.MAPB=so_nv.MAPB and MATP is null
--where: đk cho từng bản ghi
select pb.MAPB, TENPB, COUNT(MANV) SoNV
from PHONGBAN pb, NHANVIEN nv
where nv.MAPB=pb.MAPB and MATP is null
group by pb.MAPB, TENPB
--having: đk cho nhóm
select pb.MAPB, TENPB, COUNT(MANV) SoNV
from PHONGBAN pb, NHANVIEN nv
group by pb.MAPB, nv.MAPB, TENPB, MATP
having nv.MAPB=pb.MAPB and MATP is null

--8. PB có đông nv nhất
--tạo bảng tạm tính số nv các pb
create view SNV
as
select mapb, COUNT(MANV) SoNV
from NHANVIEN
group by MAPB
go
select pb.MAPB, TENPB, SoNV
from PHONGBAN pb, SNV
where pb.MAPB=SNV.MAPB
	and SoNV in (select max(sonv) from SNV)
--xóa bảng tạm
drop view SNV

--9. đếm số nv là NGS theo từng pb
create view SLNGS--số NGS theo từng pb
as
select mapb, count(MANV) SL_NGS
from NHANVIEN
where MANV in (select MANGS from NHANVIEN)
group by MAPB
go
select pb.MAPB, TENPB, SL_NGS
from PHONGBAN pb, SLNGS
where pb.MAPB=SLNGS.MAPB
go
drop view SLNGS

--10. đưa ra pb có nhiều nv là ngs nhất
create view B10--số NGS theo từng pb
as
select mapb, count(MANV) SL_NGS
from NHANVIEN
where MANV in (select MANGS from NHANVIEN)
group by MAPB
go
select pb.MAPB, TENPB, SL_NGS
from PHONGBAN pb, B10
where pb.MAPB=B10.MAPB and SL_NGS in (select max(sl_ngs) from B10)
go
drop view B10

--11. ds nv là ngs và số nv họ giám sát
select nv1.MANV, nv1.HOTEN, COUNT(nv1.MANV) SL_NV_GS
from NHANVIEN nv1, NHANVIEN nv2
group by nv1.MANV, nv2.MANGS, nv1.HOTEN
having nv1.MANV=nv2.MANGS

--12. nv qly' nhiều nv nhất
create view B12
as
select nv1.MANV, nv1.HOTEN, COUNT(nv1.MANV) SL_NV_GS
from NHANVIEN nv1, NHANVIEN nv2
group by nv1.MANV, nv2.MANGS, nv1.HOTEN
having nv1.MANV=nv2.MANGS
go
select MANV, HOTEN, SL_NV_GS
from B12
where SL_NV_GS in (select MAX(sl_nv_gs) from B12)
go
drop view B12

--13. số ng' thân của từng nv
select nv.MANV, nv.HOTEN, COUNT(tn.MANV) SL_TN
from THANNHAN tn, NHANVIEN nv
group by nv.MANV, nv.HOTEN, tn.MANV
having nv.MANV=tn.MANV

--14. nv có nhiều TN nhất
create view B14
as
select nv.MANV, nv.HOTEN, COUNT(tn.MANV) SL_TN
from THANNHAN tn, NHANVIEN nv
group by nv.MANV, nv.HOTEN, tn.MANV
having nv.MANV=tn.MANV
go
select MANV, HOTEN, SL_TN
from B14
where SL_TN in (select MAX(sl_tn) from B14)
go
drop view B14

--15. nv có nhiều TN nhất, đưa ra họ tên thân nhân
create view B14
as
select nv.MANV, nv.HOTEN, COUNT(tn.MANV) SL_TN
from THANNHAN tn, NHANVIEN nv
group by nv.MANV, nv.HOTEN, tn.MANV
having nv.MANV=tn.MANV
go
select b14.MANV, b14.HOTEN, SL_TN, tn.HOTEN, tn.QUANHE
from B14, THANNHAN tn
where B14.MANV=tn.MANV
	and SL_TN in (select MAX(sl_tn) from B14)
go
drop view B14

--16. số đề án mỗi pb phụ trách
select pb.MAPB, TENPB, COUNT(mada) SL_DA
from PHONGBAN pb, DUAN da
group by pb.MAPB, da.MAPB, TENPB
having pb.MAPB=da.MAPB

--17. pb phụ trách nhiều DA nhất
create view B16
as
select pb.MAPB, TENPB, COUNT(mada) SL_DA
from PHONGBAN pb, DUAN da
group by pb.MAPB, da.MAPB, TENPB
having pb.MAPB=da.MAPB
go
select MAPB, TENPB, SL_DA
from B16
where SL_DA in (select MAX(sl_da) from B16)
go
drop view B16

--18. số nv tham gia từng DA
select da.MADA, TENDA, count(MANV) SL_NV_TG
from PHANCONG pc, DUAN da
group by da.MADA, pc.MADA, TENDA
having da.MADA=pc.MADA

--19. DA có số nv tham gia đông nhất
create view B18
as
select da.MADA, TENDA, count(MANV) SL_NV_TG
from PHANCONG pc, DUAN da
group by da.MADA, pc.MADA, TENDA
having da.MADA=pc.MADA
go
select MADA, TENDA, SL_NV_TG
from B18
where SL_NV_TG in (select MAX(SL_NV_TG) from B18)
go
drop view B18

--20. DA có ít nv tham gia nhất
create view B18
as
select da.MADA, TENDA, count(MANV) SL_NV_TG
from PHANCONG pc, DUAN da
group by da.MADA, pc.MADA, TENDA
having da.MADA=pc.MADA
go
select MADA, TENDA, SL_NV_TG
from B18
where SL_NV_TG in (select min(SL_NV_TG) from B18)
go
drop view B18

--21. nv tham gia nhiều DA nhất
create view B21--số DA tham gia của từng nv
as
select nv.MANV, HOTEN, COUNT(MADA) SL_DA_TG
from PHANCONG pc, NHANVIEN nv
group by nv.MANV, pc.MANV, HOTEN
having nv.MANV=pc.MANV
go
select MANV, HOTEN, SL_DA_TG
from B21
where SL_DA_TG in (select MAX(SL_DA_TG) from B21)
go
drop view B21

--22. nv tham gia tất cả DA
create view B21--số DA tham gia của từng nv
as
select nv.MANV, HOTEN, COUNT(MADA) SL_DA_TG
from PHANCONG pc, NHANVIEN nv
group by nv.MANV, pc.MANV, HOTEN
having nv.MANV=pc.MANV
go
select pc.MANV, HOTEN, SL_DA_TG
from PHANCONG pc, B21
where pc.MANV=B21.MANV
	and sl_da_tg = (select count(MADA) from DUAN)--so sánh SL DA TG của nv với tổng số DA
go
drop view B21

--23. nv tham gia nhiều DA nhất của từng pb-----------------@@@chưa xong@@@-----------
create view B21--số DA tham gia của từng nv
as
select mapb, nv.MANV, HOTEN, COUNT(MADA) SL_DA_TG
from PHANCONG pc, NHANVIEN nv
where nv.MANV=pc.MANV
group by nv.MANV, pc.MANV, HOTEN, MAPB
go

select nv.manv,b21.MAPB, MAX(SL_DA_TG) SL_DA_TG 
from nhanvien nv, B21
where nv.MANV=B21.MANV
group by nv.MAPB, nv.MANV, b21.MANV, b21.MAPB

select MANV, COUNT(MADA) SL_DA_TG
from PHANCONG pc
group by MANV


go
drop view B21

--24. ds nv tham gia 2 DA trở lên
select nv.MANV, HOTEN, COUNT(MADA) SL_DA_TG
from PHANCONG pc, NHANVIEN nv
where nv.MANV=pc.MANV
group by nv.MANV, pc.MANV, HOTEN
having COUNT(MADA)>=2

--25. tổng số h tham gia DA mỗi nv
select nv.MANV, HOTEN, sum(SOGIO) Tong_Gio_TG_DA
from PHANCONG pc, NHANVIEN nv
where nv.MANV=pc.MANV
group by nv.MANV, pc.MANV, HOTEN

--26. pb có nv tham gia DA vs tổng h max
create view B26--tổng số h tham gia DA mỗi nv (mã nv)
as
select MANV, sum(SOGIO) Tong_Gio_TG_DA
from PHANCONG pc
group by MANV
go
select pb.MAPB, TENPB, Tong_Gio_TG_DA Tong_Gio_NV
from PHONGBAN pb, NHANVIEN nv, B26
where pb.MAPB=nv.MAPB and B26.MANV=nv.MANV
	and Tong_Gio_TG_DA in (select MAX(Tong_Gio_TG_DA) from B26)
go
drop view B26

--27. <nt>
create view B26--tổng số h tham gia DA mỗi nv (mã nv)
as
select MANV, sum(SOGIO) Tong_Gio_TG_DA
from PHANCONG pc
group by MANV
go
select pb.MAPB, TENPB, nv.MANV, nv.HOTEN, Tong_Gio_TG_DA Tong_Gio_NV
from PHONGBAN pb, NHANVIEN nv, B26
where pb.MAPB=nv.MAPB and B26.MANV=nv.MANV
	and Tong_Gio_TG_DA in (select MAX(Tong_Gio_TG_DA) from B26)
go
drop view B26

--28. nv có tổng số h tham gia DA max
create view B26--tổng số h tham gia DA mỗi nv (mã nv)
as
select MANV, sum(SOGIO) Tong_Gio_TG_DA
from PHANCONG pc
group by MANV
go
select nv.MANV, HOTEN, Tong_Gio_TG_DA
from NHANVIEN nv, B26
where nv.MANV=B26.MANV 
	and Tong_Gio_TG_DA in (select max(Tong_Gio_TG_DA) from B26)
go
drop view B26

--29. nv tham gia DA co Tong_timn>=10
create view B26--tổng số h tham gia DA mỗi nv (mã nv)
as
select MANV, sum(SOGIO) Tong_Gio_TG_DA
from PHANCONG pc
group by MANV
go
select nv.MANV, HOTEN, Tong_Gio_TG_DA
from NHANVIEN nv, B26
where nv.MANV=B26.MANV 
	and Tong_Gio_TG_DA >=10
go
drop view B26
--
select nv.MANV, HOTEN, sum(SOGIO) Tong_Gio_TG_DA
from PHANCONG pc, NHANVIEN nv
where nv.MANV=pc.MANV
group by nv.MANV, pc.MANV, HOTEN
having sum(SOGIO)>=10

--30. nv tham gia DA ko co ThanNhan
select nv.MANV, HOTEN
from PHANCONG pc, NHANVIEN nv
where pc.MANV=nv.MANV
	and nv.MANV not in (select MANV from THANNHAN)

--31. nv tham gia DA co nhieu ThanNhan nhat
create view B31--so ThanNhan cua tung nv
as
select MANV, COUNT(manv) SoTN
from THANNHAN
group by MANV
go
select distinct nv.MANV, HOTEN, SoTN
from NHANVIEN nv, B31, PHANCONG pc
where pc.MANV=nv.MANV--nv tham gia DA
	and nv.MANV=b31.MANV--nv co TN
	and SoTN = (select MAX(SoTN) from B31)
go
drop view B31
