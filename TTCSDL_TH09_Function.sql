---tạo hàm

CREATE FUNCTION thu(@ngay DATETIME) RETURNS NVARCHAR(10)
AS
 BEGIN
	DECLARE @st NVARCHAR(10)
		SELECT @st=CASE DATEPART(DW,@ngay)/*(đổi giá trị trong biến thành kiểu ngày giờ) ở đây là lấy giá trị ngày trong tuần*/
		WHEN 1 THEN 'Chu nhật'
		WHEN 2 THEN 'Thứ hai'
		WHEN 3 THEN 'Thứ ba'
		WHEN 4 THEN 'Thứ tư'
		WHEN 5 THEN 'Thứ năm'
		WHEN 6 THEN 'Thứ sáu'
		ELSE 'Thứ bảy' 
		END
	RETURN (@st) /* Trị trả về của hàm */
 END

 ---gọi hàm
 select * from NHANVIEN

 select MANV, HOTEN, dbo.thu(NGAYSINH), NGAYSINH
 from NHANVIEN
 where MAPB='pb01'