select * from Bang1
select * from Bang2
select * from Bang3
select * from Bang4

--Tính tổng lượng đơn và doanh thu theo mã tỉnh đi
SELECT 
	MaTinhDi, 
	COUNT (MaDon) as TongLuongDon, 
	SUM (CuocPhi) as TongDoanhThu
FROM 
	Bang1
GROUP BY 
	MaTinhDi

-- Tính tổng số lượng khách hàng, lượng đơn và doanh thu theo vùng
SELECT 
	TenVung as Vung, 
	COUNT ([MaKhachHang]) AS TongKhachHang,
	COUNT (MaDon) AS TongLuongDon,
	SUM (CuocPhi) AS TongDoanhThu
FROM 
	Bang2 AS a inner join Bang1 AS b ON a.MaTinh = b.MaTinhDi
GROUP BY 
	TenVung


-- Tính tổng số lượng khách hàng và doanh thu theo mức xếp hạng và vùng	
SELECT
	c.XepHang as MucXepHang,
	a.TenVung as Vung,
	COUNT (b.MaKhachHang) AS TongKhachHang,
	SUM (CuocPhi) AS TongDoanhThu
FROM 
	Bang2 AS a RIGHT JOIN Bang1 AS b ON a.MaTinh = b.MaTinhDi
	LEFT JOIN Bang3 as c ON b.MaKhachHang = c.MaKhachHang
GROUP BY
	c.XepHang,
	a.TenVung 
ORDER BY c.XepHang

-- Tính số lượng khách hàng và doanh thu theo phân loại khách hàng
WITH CTE AS
(
	SELECT 
			PhanLoai = 
		CASE 
			WHEN XepHang = 'A' THEN 'Khach hang lon'
			WHEN XepHang = 'B' OR 
			XepHang = 'C' THEN 'Khach hang vua va nho'
		ELSE 'Khach hang le'
		END,
		a.MaKhachHang,
		a.CuocPhi
	FROM 
		Bang1 AS a LEFT JOIN Bang3 AS b ON a.MaKhachHang = b.MaKhachHang
)
	SELECT 
		PhanLoai,
		COUNT (MaKhachHang) AS TongKhachHang,
		SUM (CuocPhi) AS TongDoanhThu
	FROM 
		CTE
	GROUP BY 
		PhanLoai

-- Bảng 4 là bảng định danh khách hàng công nợ theo tháng. Tính tổng lượng đơn và doanh thu của mỗi khách hàng công nợ thuộc nhóm khách hàng lớn
WITH CTE1 AS
(
	SELECT 
		a.MaKhachHang,
		a.CuocPhi,
		MaDon
	FROM 
		Bang1 AS a LEFT JOIN Bang3 AS b ON a.MaKhachHang = b.MaKhachHang
)
	SELECT 
		MaKhachHang,
		COUNT (MaDon) AS TongLuongDon,
		SUM (CuocPhi) AS TongDoanhThu
	FROM 
		CTE1
	WHERE MaKhachHang = '123A'
	GROUP BY 
		MaKhachHang

--Tìm các đơn hàng có mã tỉnh đi và đến khác nhau thuộc các vùng khác nhau
--Tìm các khách hàng có đơn hàng từ các tỉnh đi khác nhau thuộc cùng một vùng và đến chung một tỉnh
--Tính tổng doanh thu tích lũy cho mỗi tỉnh đến, phân theo vùng
