-- Fixes VeganPlaceDuyLD sample data for pagination testing.
-- Updates contact data for the original 3 rows and normalizes pagination test IDs to 4-12.

USE [VeganDB];
GO

IF OBJECT_ID(N'dbo.VeganPlaceDuyLD', N'U') IS NULL
    THROW 50001, 'Missing table dbo.VeganPlaceDuyLD. Please create VeganDB schema first.', 1;

IF OBJECT_ID(N'dbo.PlaceFoodDuyLD', N'U') IS NULL
    THROW 50002, 'Missing table dbo.PlaceFoodDuyLD. Please create VeganDB schema first.', 1;
GO

BEGIN TRANSACTION;

BEGIN TRY
    UPDATE dbo.VeganPlaceDuyLD
    SET
        Phone = N'0900000001',
        Website = N'https://mocxanh.example.com'
    WHERE VeganPlaceDuyLDId = 1
      AND PlaceName = N'Nhà hàng Chay Mộc Xanh';

    UPDATE dbo.VeganPlaceDuyLD
    SET
        Phone = N'0900000002',
        Website = N'https://lanon.example.com'
    WHERE VeganPlaceDuyLDId = 2
      AND PlaceName = N'Quán Chay Lá Non';

    UPDATE dbo.VeganPlaceDuyLD
    SET
        Phone = N'0900000003',
        Website = N'https://annhien-bakery.example.com'
    WHERE VeganPlaceDuyLDId = 3
      AND PlaceName = N'Tiệm Bánh Chay An Nhiên';

    DECLARE @SamplePlaces TABLE
    (
        VeganPlaceDuyLDId BIGINT NOT NULL PRIMARY KEY,
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
        VeganPlaceDuyLDId,
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
    (4, N'Nhà hàng chay', N'Món chay phục vụ tại quán', 1.00, N'Nhà hàng Chay Sen Việt', N'14 Nguyễn Văn Trỗi, Quận Phú Nhuận, TP. Hồ Chí Minh', N'0901000001', N'https://senviet.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7981000, 106.6779000, 4.30, '2026-09-29T08:00:00', 1),
    (5, N'Quán ăn chay', N'Món chay bình dân', 2.00, N'Quán Chay Bình An', N'33 Lê Văn Sỹ, Quận 3, TP. Hồ Chí Minh', N'0901000002', N'https://binhan.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7867000, 106.6802000, 4.10, '2026-09-29T08:05:00', 1),
    (6, N'Tiệm bánh chay', N'Bánh và đồ ăn nhẹ thuần chay', 3.00, N'Tiệm Bánh Chay Hạt Lành', N'5 Trần Quang Diệu, Quận 3, TP. Hồ Chí Minh', N'0901000003', N'https://hatlanh.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7842000, 106.6840000, 4.60, '2026-09-29T08:10:00', 1),
    (7, N'Cà phê chay', N'Đồ uống và món nhẹ thuần chay', 4.00, N'Cà Phê Chay Lá Xanh', N'21 Điện Biên Phủ, Quận Bình Thạnh, TP. Hồ Chí Minh', N'0901000004', N'https://laxanh-cafe.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.8018000, 106.7114000, 4.00, '2026-09-29T08:15:00', 1),
    (8, N'Nhà hàng chay', N'Món chay phục vụ tại quán', 1.00, N'Nhà hàng Chay Tâm An', N'72 Võ Văn Tần, Quận 3, TP. Hồ Chí Minh', N'0901000005', N'https://taman.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7779000, 106.6901000, 4.80, '2026-09-29T08:20:00', 1),
    (9, N'Quán ăn chay', N'Món chay bình dân', 2.00, N'Quán Chay Mầm Xanh', N'19 Phan Xích Long, Quận Phú Nhuận, TP. Hồ Chí Minh', N'0901000006', N'https://mamxanh.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.8012000, 106.6885000, 3.90, '2026-09-29T08:25:00', 1),
    (10, N'Buffet chay', N'Buffet và món chay theo phần', 5.00, N'Buffet Chay An Lạc', N'40 Nguyễn Thị Minh Khai, Quận 1, TP. Hồ Chí Minh', N'0901000007', N'https://anlac-buffet.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7829000, 106.6993000, 4.40, '2026-09-29T08:30:00', 1),
    (11, N'Cơm chay văn phòng', N'Suất ăn chay giao nhanh', 6.00, N'Cơm Chay Văn Phòng An Nhiên', N'88 Cách Mạng Tháng 8, Quận 10, TP. Hồ Chí Minh', N'0901000008', N'https://annhien-office.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7735000, 106.6674000, 4.20, '2026-09-29T08:35:00', 1),
    (12, N'Quán ăn chay', N'Món chay bình dân', 2.00, N'Quán Chay Tịnh Tâm', N'11 Nguyễn Gia Trí, Quận Bình Thạnh, TP. Hồ Chí Minh', N'0901000009', N'https://tinhtam.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.8060000, 106.7151000, 3.80, '2026-09-29T08:40:00', 0);

    IF EXISTS
    (
        SELECT 1
        FROM dbo.VeganPlaceDuyLD AS target
        LEFT JOIN @SamplePlaces AS sample
            ON target.VeganPlaceDuyLDId = sample.VeganPlaceDuyLDId
        WHERE target.VeganPlaceDuyLDId BETWEEN 4 AND 12
          AND sample.VeganPlaceDuyLDId IS NULL
    )
    BEGIN
        THROW 50003, 'IDs 4-12 contain non-sample rows. Please review data before normalizing pagination test IDs.', 1;
    END

    IF EXISTS
    (
        SELECT 1
        FROM dbo.PlaceFoodDuyLD AS food
        INNER JOIN dbo.VeganPlaceDuyLD AS place
            ON food.VeganPlaceDuyLDId = place.VeganPlaceDuyLDId
        INNER JOIN @SamplePlaces AS sample
            ON place.PlaceName = sample.PlaceName
        WHERE place.VeganPlaceDuyLDId <> sample.VeganPlaceDuyLDId
    )
    BEGIN
        THROW 50004, 'A pagination sample row has child PlaceFoodDuyLD data. Please review before changing IDs.', 1;
    END

    DELETE target
    FROM dbo.VeganPlaceDuyLD AS target
    INNER JOIN @SamplePlaces AS sample
        ON target.PlaceName = sample.PlaceName
    WHERE target.VeganPlaceDuyLDId <> sample.VeganPlaceDuyLDId;

    SET IDENTITY_INSERT dbo.VeganPlaceDuyLD ON;

    INSERT INTO dbo.VeganPlaceDuyLD
    (
        VeganPlaceDuyLDId,
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
        sample.VeganPlaceDuyLDId,
        sample.CategoryName,
        sample.CategoryDescription,
        sample.CategoryDisplayOrder,
        sample.PlaceName,
        sample.Address,
        sample.Phone,
        sample.Website,
        sample.Description,
        sample.Latitude,
        sample.Longitude,
        sample.Rating,
        sample.CreatedAt,
        sample.IsActive
    FROM @SamplePlaces AS sample
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.VeganPlaceDuyLD AS target
        WHERE target.VeganPlaceDuyLDId = sample.VeganPlaceDuyLDId
    );

    SET IDENTITY_INSERT dbo.VeganPlaceDuyLD OFF;

    UPDATE target
    SET
        target.CategoryName = sample.CategoryName,
        target.CategoryDescription = sample.CategoryDescription,
        target.CategoryDisplayOrder = sample.CategoryDisplayOrder,
        target.PlaceName = sample.PlaceName,
        target.Address = sample.Address,
        target.Phone = sample.Phone,
        target.Website = sample.Website,
        target.Description = sample.Description,
        target.Latitude = sample.Latitude,
        target.Longitude = sample.Longitude,
        target.Rating = sample.Rating,
        target.CreatedAt = sample.CreatedAt,
        target.IsActive = sample.IsActive
    FROM dbo.VeganPlaceDuyLD AS target
    INNER JOIN @SamplePlaces AS sample
        ON target.VeganPlaceDuyLDId = sample.VeganPlaceDuyLDId;

    DECLARE @MaxId BIGINT;
    SELECT @MaxId = ISNULL(MAX(VeganPlaceDuyLDId), 0)
    FROM dbo.VeganPlaceDuyLD;

    DBCC CHECKIDENT ('dbo.VeganPlaceDuyLD', RESEED, @MaxId) WITH NO_INFOMSGS;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

SELECT
    VeganPlaceDuyLDId,
    PlaceName,
    Phone,
    Website,
    CategoryName,
    Rating,
    IsActive
FROM dbo.VeganPlaceDuyLD
ORDER BY VeganPlaceDuyLDId;
GO
