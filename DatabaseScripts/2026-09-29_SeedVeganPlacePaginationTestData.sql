-- Adds 9 sample VeganPlaceDuyLD rows for testing table pagination.
-- Safe to run multiple times: rows are matched by PlaceName.

USE [VeganDB];
GO

IF OBJECT_ID(N'dbo.VeganPlaceDuyLD', N'U') IS NULL
    THROW 50001, 'Missing table dbo.VeganPlaceDuyLD. Please create VeganDB schema first.', 1;
GO

DECLARE @SamplePlaces TABLE
(
    CategoryName NVARCHAR(100) NOT NULL,
    CategoryDescription NVARCHAR(255) NULL,
    CategoryDisplayOrder DECIMAL(6, 2) NULL,
    PlaceName NVARCHAR(255) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    Phone NVARCHAR(30) NULL,
    Website NVARCHAR(1000) NULL,
    Description NVARCHAR(MAX) NULL,
    Latitude DECIMAL(10, 7) NULL,
    Longitude DECIMAL(10, 7) NULL,
    Rating DECIMAL(3, 2) NULL,
    CreatedAt DATETIME NOT NULL,
    IsActive BIT NOT NULL
);

INSERT INTO @SamplePlaces
(
    CategoryName,
    CategoryDescription,
    CategoryDisplayOrder,
    PlaceName,
    Address,
    Phone,
    Website,
    Description,
    Latitude,
    Longitude,
    Rating,
    CreatedAt,
    IsActive
)
VALUES
(
    N'Nhà hàng chay',
    N'Món chay phục vụ tại quán',
    1.00,
    N'Nhà hàng Chay Sen Việt',
    N'14 Nguyễn Văn Trỗi, Quận Phú Nhuận, TP. Hồ Chí Minh',
    N'0901000001',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.7981000,
    106.6779000,
    4.30,
    '2026-09-29T08:00:00',
    1
),
(
    N'Quán ăn chay',
    N'Món chay bình dân',
    2.00,
    N'Quán Chay Bình An',
    N'33 Lê Văn Sỹ, Quận 3, TP. Hồ Chí Minh',
    N'0901000002',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.7867000,
    106.6802000,
    4.10,
    '2026-09-29T08:05:00',
    1
),
(
    N'Tiệm bánh chay',
    N'Bánh và đồ ăn nhẹ thuần chay',
    3.00,
    N'Tiệm Bánh Chay Hạt Lành',
    N'5 Trần Quang Diệu, Quận 3, TP. Hồ Chí Minh',
    N'0901000003',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.7842000,
    106.6840000,
    4.60,
    '2026-09-29T08:10:00',
    1
),
(
    N'Cà phê chay',
    N'Đồ uống và món nhẹ thuần chay',
    4.00,
    N'Cà Phê Chay Lá Xanh',
    N'21 Điện Biên Phủ, Quận Bình Thạnh, TP. Hồ Chí Minh',
    N'0901000004',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.8018000,
    106.7114000,
    4.00,
    '2026-09-29T08:15:00',
    1
),
(
    N'Nhà hàng chay',
    N'Món chay phục vụ tại quán',
    1.00,
    N'Nhà hàng Chay Tâm An',
    N'72 Võ Văn Tần, Quận 3, TP. Hồ Chí Minh',
    N'0901000005',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.7779000,
    106.6901000,
    4.80,
    '2026-09-29T08:20:00',
    1
),
(
    N'Quán ăn chay',
    N'Món chay bình dân',
    2.00,
    N'Quán Chay Mầm Xanh',
    N'19 Phan Xích Long, Quận Phú Nhuận, TP. Hồ Chí Minh',
    N'0901000006',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.8012000,
    106.6885000,
    3.90,
    '2026-09-29T08:25:00',
    1
),
(
    N'Buffet chay',
    N'Buffet và món chay theo phần',
    5.00,
    N'Buffet Chay An Lạc',
    N'40 Nguyễn Thị Minh Khai, Quận 1, TP. Hồ Chí Minh',
    N'0901000007',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.7829000,
    106.6993000,
    4.40,
    '2026-09-29T08:30:00',
    1
),
(
    N'Cơm chay văn phòng',
    N'Suất ăn chay giao nhanh',
    6.00,
    N'Cơm Chay Văn Phòng An Nhiên',
    N'88 Cách Mạng Tháng 8, Quận 10, TP. Hồ Chí Minh',
    N'0901000008',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.7735000,
    106.6674000,
    4.20,
    '2026-09-29T08:35:00',
    1
),
(
    N'Quán ăn chay',
    N'Món chay bình dân',
    2.00,
    N'Quán Chay Tịnh Tâm',
    N'11 Nguyễn Gia Trí, Quận Bình Thạnh, TP. Hồ Chí Minh',
    N'0901000009',
    NULL,
    N'Dữ liệu mẫu dùng để kiểm thử phân trang.',
    10.8060000,
    106.7151000,
    3.80,
    '2026-09-29T08:40:00',
    0
);

INSERT INTO dbo.VeganPlaceDuyLD
(
    CategoryName,
    CategoryDescription,
    CategoryDisplayOrder,
    PlaceName,
    Address,
    Phone,
    Website,
    Description,
    Latitude,
    Longitude,
    Rating,
    CreatedAt,
    IsActive
)
SELECT
    source.CategoryName,
    source.CategoryDescription,
    source.CategoryDisplayOrder,
    source.PlaceName,
    source.Address,
    source.Phone,
    source.Website,
    source.Description,
    source.Latitude,
    source.Longitude,
    source.Rating,
    source.CreatedAt,
    source.IsActive
FROM @SamplePlaces AS source
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.VeganPlaceDuyLD AS target
    WHERE target.PlaceName = source.PlaceName
);

SELECT
    COUNT(*) AS VeganPlaceCount
FROM dbo.VeganPlaceDuyLD;

SELECT
    VeganPlaceDuyLDId,
    PlaceName,
    CategoryName,
    Rating,
    IsActive
FROM dbo.VeganPlaceDuyLD
ORDER BY VeganPlaceDuyLDId;
GO
