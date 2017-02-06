
select * from NHANVIEN
select * from DUAN
select * from THANNHAN
select * from PHANCONG
select * from PHONGBAN
-------------------------------------------------------------------
-------#TH4--------------------------------------------------------
--1
select MANV, HOTEN, NGAYSINH, LUONG
from NHANVIEN
order by LUONG desc
--2
select *
from PHONGBAN
where MATP is not null
--3
select *
from PHONGBAN
where MATP is null
--4
select * from DUAN
where MAPB is not null
--5
select * from DUAN
where MAPB is null
--6
select * from NHANVIEN
where MANGS is not null
--7
select * from NHANVIEN
where MANGS is null
--8
select nv.MANV, HOTEN, NGAYSINH, LUONG, TENPB 
from NHANVIEN nv, PHONGBAN pb
where nv.MAPB=pb.MAPB
order by TENPB

--9. ds nv thuộc phòng 'HC'
select nv.MANV, HOTEN, NGAYSINH, LUONG, TENPB 
from NHANVIEN nv, PHONGBAN pb
where nv.MAPB=pb.MAPB and pb.TENPB=N'Hành chính'

--10. ds nv có thân nhân
select nv.MANV, nv.HOTEN, MAPB, tn.HOTEN, tn.QUANHE
from NHANVIEN nv, THANNHAN tn
where nv.MANV=tn.MANV
order by nv.MANV
--distinct: loại bỏ giá trị trùng của cột
select distinct nv.MANV, nv.HOTEN, MAPB
from NHANVIEN nv, THANNHAN tn
where nv.MANV=tn.MANV

--11.nv co Luong >=5tr
select nv.MANV, HOTEN, NGAYSINH, LUONG, TENPB
from NHANVIEN nv, PHONGBAN pb
where LUONG>=5000000 and nv.MAPB=pb.MAPB

--12. nv tham gia DA
select nv.MANV, HOTEN, NGAYSINH, LUONG, MADA
from NHANVIEN nv, PHANCONG pc
where nv.MANV=pc.MANV
--13
select nv.MANV, HOTEN, NGAYSINH, LUONG, pc.MADA,TENDA, SOGIO
from NHANVIEN nv, PHANCONG pc, DUAN da
where nv.MANV=pc.MANV and pc.MADA=da.MADA

--14. nv ko tham gia DA
select MANV, HOTEN, NGAYSINH, LUONG
from NHANVIEN
where manv not in (select MANV from PHANCONG)

--15. danh sach DA do phong 'HC' qly
select da.MADA, TENDA, pb.TENPB
from DUAN da, PHONGBAN pb
where da.MAPB=pb.MAPB and TENPB=N'hành chính'

--16. ds DA mà 1 nv tên là '...' thuộc phòng '...' tham gia
select nv.MANV, HOTEN, da.MADA, TENDA, TENPB
from NHANVIEN nv,PHANCONG pc, (select da.MADA, TENDA, pb.TENPB
								from DUAN da, PHONGBAN pb
								where da.MAPB=pb.MAPB and TENPB=N'hành chính'
							   ) da
where nv.MANV=pc.MANV and pc.MADA=da.MADA
	and HOTEN=N'Bùi tiến dũng'
--
select nv.MANV, HOTEN, pc.MADA
from NHANVIEN nv,PHANCONG pc, PHONGBAN pb
where nv.MANV=pc.MANV and HOTEN=N'Bùi tiến dũng'--tìm tất cả DA của nv có tên 'BTD' tham gia
	and nv.MAPB= pb.MAPB and TENPB=N'hành chính'--nv thuộc phòng 'HC'

--17. ds nv có thân nhân cùng tên, gt
select MANV, HOTEN
from NHANVIEN
where MANV in (select tn1.MANV from THANNHAN tn1, THANNHAN tn2 
					where tn1.MANV<>tn2.MANV
						and tn1.HOTEN=tn2.HOTEN and tn1.GT=tn2.GT
				)

--18. ds nv cùng tên, gt
select * from NHANVIEN nv1, NHANVIEN nv2
where nv1.MANV<>nv2.MANV
	and nv1.HOTEN=nv2.HOTEN and nv1.GT=nv2.GT

--19. ds nv là trưởng phòng
select nv.MANV, nv.HOTEN, TENPB
from NHANVIEN nv, PHONGBAN pb
where nv.MANV=pb.MATP

--20. ds nv là NGS
select *
from NHANVIEN
where MANV in ( select MANGS from NHANVIEN
				where MANGS is not null
				)
--
select distinct nv1.MANV, nv1.HOTEN
from NHANVIEN nv1, NHANVIEN nv2
where nv1.MANV=nv2.MANGS --and nv1.MANV<>nv2.MANV : 2nv khác nhau
