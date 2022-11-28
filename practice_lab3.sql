--BTVN
USE QLBH_2020;

-- 1. Tính tổng số sản phẩm của từng nước sản xuất;
SELECT
    sp.NUOCSX,
    COUNT(sp.MASP) AS TongSoSP
FROM
    SANPHAM sp
GROUP BY
    sp.NUOCSX;

-- 2. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT
    COUNT(hd.MAKH) AS SLHDKhongLaTV
FROM
    HOADON hd
    JOIN KHACHHANG kh ON hd.MAKH = kh.MAKH
WHERE
    kh.NGDK IS NULL;

-- 3. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT
    MAX(TRIGIA) AS TGHDCaoNhat,
    MIN(TRIGIA) AS TGHDThapNhat
FROM
    HOADON;

-- 4. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT
    AVG(TRIGIA) AS TriGiaTBHD
FROM
    HOADON
WHERE
    YEAR(NGHD) = 2006;

-- 5. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT
    NUOCSX,
    MAX(GIA) AS GiaCaoNhat,
    MIN(GIA) AS GiaThapNhat,
    AVG(GIA) AS GiaTB
FROM
    SANPHAM
GROUP BY
    NUOCSX;

-- 6. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT
    MONTH(NGHD) AS Thang,
    SUM(TRIGIA) AS DoanhThu
FROM
    HOADON
GROUP BY
    MONTH(NGHD);

-- 7. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT
    cthd.MASP,
    SUM(SL) AS TongSLBanRa
FROM
    CTHD cthd
    JOIN HOADON hd ON cthd.SOHD = hd.SOHD
WHERE
    YEAR(hd.NGHD) = 2006
    AND MONTH(hd.NGHD) = 10
GROUP BY
    cthd.MASP;

-- 8. Tìm hóa đơn có mua 3 mã sản phẩm do “Viet Nam” sản xuất.
SELECT
    cthd.SOHD
FROM
    SANPHAM sp
    JOIN CTHD cthd ON sp.MASP = cthd.MASP
WHERE
    sp.NUOCSX = 'Viet Nam'
GROUP BY
    cthd.SOHD
HAVING
    COUNT(sp.MASP) = 3;

-- 9. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT
    TOP 1 WITH TIES SOHD,
    TRIGIA
FROM
    HOADON
WHERE
    YEAR(NGHD) = 2006
ORDER BY
    TRIGIA DESC;

-- 10.Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT
    TOP 1 WITH TIES hd.SOHD,
    kh.MAKH,
    hd.TRIGIA
FROM
    HOADON hd
    JOIN KHACHHANG kh ON hd.MAKH = kh.MAKH
WHERE
    YEAR(NGHD) = 2006
ORDER BY
    TRIGIA DESC;

-- 11.In ra danh sách khách hàng và thứ hạng của khách hàng (xếp hạng theo doanh số).
SELECT
    hd.MAKH,
    SUM(hd.TRIGIA) AS DOANHTHU,
    DENSE_RANK() OVER (
        ORDER BY
            SUM(hd.TRIGIA) DESC
    ) AS XepHangDoanhThu
FROM
    HOADON hd
    JOIN KHACHHANG kh ON hd.MAKH = kh.MAKH
GROUP BY
    hd.MAKH;

-- 12.In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số
-- giảm dần.
SELECT
    TOP 3 hd.MAKH,
    kh.HOTEN
FROM
    HOADON hd
    JOIN KHACHHANG kh ON hd.MAKH = kh.MAKH
GROUP BY
    hd.MAKH,
    kh.HOTEN
ORDER BY
    SUM(hd.TRIGIA) DESC;

-- 13.In ra thông tin (MAKH, HOTEN, DOANHSO) và loại của khách hàng. Nếu doanh 
-- số lớn hơn 2000000 là khách hàng VIP. Nếu doanh số lớn hơn 500000 là khách hàng 
-- TV, còn lại là khách hàng TT.
SELECT
    hd.MAKH,
    kh.HOTEN,
    SUM(hd.TRIGIA) AS DOANHSO,
    LOAIKH = (
        CASE
            WHEN SUM(hd.TRIGIA) > 2000000 THEN 'VIP'
            WHEN SUM(hd.TRIGIA) > 500000 THEN 'TV'
            ELSE 'TT'
        END
    )
FROM
    HOADON hd
    JOIN KHACHHANG kh ON hd.MAKH = kh.MAKH
GROUP BY
    hd.MAKH,
    kh.HOTEN;