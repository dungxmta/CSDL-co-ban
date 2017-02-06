use CSDL_LENH_TTCSDL

/*
	CREATE TRIGGER Ten_Trigger
	ON Ten_Bang
	FOR {[ INSERT] | [ UPDATE] | [ DELETE] }
	AS
	BEGIN
	‐‐Các câu lệnh của Trigger
	END
*/

/*  Các thay đổi dữ liệu 
	 đối với cập nhật (Update), Thêm mới (Insert) sẽ lưu ra một bảnh là Inserted, 
	 đối với thao tác Xóa (Delete) sẽ tạo ra 1 bảng là deleted,
	Các bảng này chỉ tồn tại trong thời gian trigger đó thực thi mà thôi */

--tạo 1 trigger gắn vào bảng NHANVIEN khi thực hiện các lệnh INSERT, UPDATE
create trigger tgr_check
on nhanvien
for insert, update
as
	print '--ket qua cap nhat--'
	select * from NHANVIEN

--demo TRIGGER tgr_check
insert into NHANVIEN values ('NV13',N'NGUYỄN HÀ','NU','1995-10-06','95500',NULL,'PB01')
UPDATE NHANVIEN
SET HOTEN=N'NGUYỄN KIÊN' WHERE MANV='NV12'

--xóa trigger
drop trigger tgr_check
---hoặc disable trigger
