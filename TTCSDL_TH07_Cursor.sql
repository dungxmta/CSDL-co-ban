---buoi7_BaiTH7
USE CSDL_LENH_TTCSDL

select * from NHANVIEN
select * from PHANCONG
select * from DUAN
select * from PHONGBAN

alter table duan add TongTime NUMERIC(3,1)

---su dung con tro
---@bien do ng' dung, @@bien he thong

declare @tongtg NUMERIC(3,1) , @ma nchar(10)
declare cur_tongtg cursor forward_only for select mada, sum(sogio) from PHANCONG group by MADA
open cur_tongtg
	while 0=0
	begin
		fetch next from cur_tongtg
		into @ma, @tongtg
		if @@FETCH_STATUS<>0
		break
		---print N'Đang cập nhật phiếu nhập:'---+Cast (@tongtg varchar(50))
		update DUAN
		set TongTime = @tongtg
		where MADA = @ma
		end
		close cur_tongtg 