-- Restores DuyLD sample data that may have been deleted while testing SignalR.
-- Safe to run multiple times:
--   - Existing rows are kept unchanged.
--   - Only missing rows are inserted back by their original identity IDs.

USE [VeganDB];
GO

IF OBJECT_ID(N'dbo.VeganPlaceDuyLD', N'U') IS NULL
    THROW 50001, 'Missing table dbo.VeganPlaceDuyLD. Please create VeganDB schema first.', 1;

IF OBJECT_ID(N'dbo.PlaceFoodDuyLD', N'U') IS NULL
    THROW 50002, 'Missing table dbo.PlaceFoodDuyLD. Please create VeganDB schema first.', 1;
GO

BEGIN TRANSACTION;

BEGIN TRY
    DECLARE @RestoredPlaces INT = 0;
    DECLARE @RestoredFoods INT = 0;

    DECLARE @ExpectedPlaces TABLE
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

    INSERT INTO @ExpectedPlaces
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
    (1, N'Nhà hàng chay', N'Món chay phục vụ tại quán', 1.00, N'Nhà hàng Chay Mộc Xanh', N'12 Đường Minh Họa, Quận Mẫu, TP. Hồ Chí Minh', N'0900000001', N'https://mocxanh.example.com', N'Nhà hàng chay với thực đơn cơm và bún.', NULL, NULL, 4.50, '2026-09-25T16:11:17', 1),
    (2, N'Quán ăn chay', N'Món chay bình dân', 2.00, N'Quán Chay Lá Non', N'25 Đường Ví Dụ, Quận Mẫu, TP. Hồ Chí Minh', N'0900000002', N'https://lanon.example.com', N'Quán chay phục vụ bữa trưa và bữa tối.', NULL, NULL, 4.20, '2026-09-25T16:11:17', 1),
    (3, N'Tiệm bánh chay', N'Bánh và đồ ăn nhẹ thuần chay', 3.00, N'Tiệm Bánh Chay An Nhiên', N'8 Đường Thử Nghiệm, Quận Mẫu, TP. Hồ Chí Minh', N'0900000003', N'https://annhien-bakery.example.com', N'Tiệm bánh thuần chay dùng cho dữ liệu kiểm thử.', NULL, NULL, 4.70, '2026-09-25T16:11:17', 1),
    (4, N'Nhà hàng chay', N'Món chay phục vụ tại quán', 1.00, N'Nhà hàng Chay Sen Việt', N'14 Nguyễn Văn Trỗi, Quận Phú Nhuận, TP. Hồ Chí Minh', N'0901000001', N'https://senviet.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7981000, 106.6779000, 4.30, '2026-09-29T08:00:00', 1),
    (5, N'Quán ăn chay', N'Món chay bình dân', 2.00, N'Quán Chay Bình An', N'33 Lê Văn Sỹ, Quận 3, TP. Hồ Chí Minh', N'0901000002', N'https://binhan.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7867000, 106.6802000, 4.10, '2026-09-29T08:05:00', 1),
    (6, N'Tiệm bánh chay', N'Bánh và đồ ăn nhẹ thuần chay', 3.00, N'Tiệm Bánh Chay Hạt Lành', N'5 Trần Quang Diệu, Quận 3, TP. Hồ Chí Minh', N'0901000003', N'https://hatlanh.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7842000, 106.6840000, 4.60, '2026-09-29T08:10:00', 1),
    (7, N'Cà phê chay', N'Đồ uống và món nhẹ thuần chay', 4.00, N'Cà Phê Chay Lá Xanh', N'21 Điện Biên Phủ, Quận Bình Thạnh, TP. Hồ Chí Minh', N'0901000004', N'https://laxanh-cafe.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.8018000, 106.7114000, 4.00, '2026-09-29T08:15:00', 1),
    (8, N'Nhà hàng chay', N'Món chay phục vụ tại quán', 1.00, N'Nhà hàng Chay Tâm An', N'72 Võ Văn Tần, Quận 3, TP. Hồ Chí Minh', N'0901000005', N'https://taman.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7779000, 106.6901000, 4.80, '2026-09-29T08:20:00', 1),
    (9, N'Quán ăn chay', N'Món chay bình dân', 2.00, N'Quán Chay Mầm Xanh', N'19 Phan Xích Long, Quận Phú Nhuận, TP. Hồ Chí Minh', N'0901000006', N'https://mamxanh.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.8012000, 106.6885000, 3.90, '2026-09-29T08:25:00', 1),
    (10, N'Buffet chay', N'Buffet và món chay theo phần', 5.00, N'Buffet Chay An Lạc', N'40 Nguyễn Thị Minh Khai, Quận 1, TP. Hồ Chí Minh', N'0901000007', N'https://anlac-buffet.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7829000, 106.6993000, 4.40, '2026-09-29T08:30:00', 1),
    (11, N'Cơm chay văn phòng', N'Suất ăn chay giao nhanh', 6.00, N'Cơm Chay Văn Phòng An Nhiên', N'88 Cách Mạng Tháng 8, Quận 10, TP. Hồ Chí Minh', N'0901000008', N'https://annhien-office.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.7735000, 106.6674000, 4.20, '2026-09-29T08:35:00', 1),
    (12, N'Quán ăn chay', N'Món chay bình dân', 2.00, N'Quán Chay Tịnh Tâm', N'11 Nguyễn Gia Trí, Quận Bình Thạnh, TP. Hồ Chí Minh', N'0901000009', N'https://tinhtam.example.com', N'Dữ liệu mẫu dùng để kiểm thử phân trang.', 10.8060000, 106.7151000, 3.80, '2026-09-29T08:40:00', 0);

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
        expected.VeganPlaceDuyLDId,
        expected.CategoryName,
        expected.CategoryDescription,
        expected.CategoryDisplayOrder,
        expected.PlaceName,
        expected.Address,
        expected.Phone,
        expected.Website,
        expected.Description,
        expected.Latitude,
        expected.Longitude,
        expected.Rating,
        expected.CreatedAt,
        expected.IsActive
    FROM @ExpectedPlaces AS expected
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.VeganPlaceDuyLD AS existing
        WHERE existing.VeganPlaceDuyLDId = expected.VeganPlaceDuyLDId
    );

    SET @RestoredPlaces = @@ROWCOUNT;

    SET IDENTITY_INSERT dbo.VeganPlaceDuyLD OFF;

    DECLARE @ExpectedFoods TABLE
    (
        PlaceFoodDuyLDId BIGINT NOT NULL PRIMARY KEY,
        VeganPlaceDuyLDId BIGINT NOT NULL,
        IngredientDuyPNId BIGINT NULL,
        FoodName NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Price DECIMAL(12, 2) NULL,
        CreatedAt DATETIME NOT NULL,
        IsAvailable BIT NOT NULL
    );

    INSERT INTO @ExpectedFoods
    (
        PlaceFoodDuyLDId,
        VeganPlaceDuyLDId,
        IngredientDuyPNId,
        FoodName,
        Description,
        Price,
        CreatedAt,
        IsAvailable
    )
    VALUES
    (1, 1, NULL, N'Cơm nấm sốt tiêu', N'Cơm ăn kèm nấm và rau củ.', 65000.00, '2026-09-25T16:11:17', 1),
    (2, 1, NULL, N'Bún riêu chay', N'Bún với đậu hũ và rau sống.', 55000.00, '2026-09-25T16:11:17', 1),
    (3, 2, NULL, N'Cơm tấm chay', N'Cơm tấm với sườn chay và bì chay.', 45000.00, '2026-09-25T16:11:17', 1),
    (4, 2, NULL, N'Phở nấm chay', N'Phở nước dùng rau củ và nấm.', 50000.00, '2026-09-25T16:11:17', 1),
    (5, 3, NULL, N'Bánh mì nấm', N'Bánh mì kẹp nấm và rau củ.', 35000.00, '2026-09-25T16:11:17', 1),
    (6, 3, NULL, N'Bánh chuối yến mạch', N'Bánh ngọt thuần chay dùng chuối và yến mạch.', 30000.00, '2026-09-25T16:11:17', 1);

    SET IDENTITY_INSERT dbo.PlaceFoodDuyLD ON;

    INSERT INTO dbo.PlaceFoodDuyLD
    (
        PlaceFoodDuyLDId,
        VeganPlaceDuyLDId,
        IngredientDuyPNId,
        FoodName,
        Description,
        Price,
        CreatedAt,
        IsAvailable
    )
    SELECT
        expected.PlaceFoodDuyLDId,
        expected.VeganPlaceDuyLDId,
        expected.IngredientDuyPNId,
        expected.FoodName,
        expected.Description,
        expected.Price,
        expected.CreatedAt,
        expected.IsAvailable
    FROM @ExpectedFoods AS expected
    WHERE EXISTS
    (
        SELECT 1
        FROM dbo.VeganPlaceDuyLD AS place
        WHERE place.VeganPlaceDuyLDId = expected.VeganPlaceDuyLDId
    )
      AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.PlaceFoodDuyLD AS existing
        WHERE existing.PlaceFoodDuyLDId = expected.PlaceFoodDuyLDId
    );

    SET @RestoredFoods = @@ROWCOUNT;

    SET IDENTITY_INSERT dbo.PlaceFoodDuyLD OFF;

    DECLARE @MaxPlaceId BIGINT;
    SELECT @MaxPlaceId = ISNULL(MAX(VeganPlaceDuyLDId), 0)
    FROM dbo.VeganPlaceDuyLD;

    DBCC CHECKIDENT ('dbo.VeganPlaceDuyLD', RESEED, @MaxPlaceId) WITH NO_INFOMSGS;

    DECLARE @MaxFoodId BIGINT;
    SELECT @MaxFoodId = ISNULL(MAX(PlaceFoodDuyLDId), 0)
    FROM dbo.PlaceFoodDuyLD;

    DBCC CHECKIDENT ('dbo.PlaceFoodDuyLD', RESEED, @MaxFoodId) WITH NO_INFOMSGS;

    COMMIT TRANSACTION;

    SELECT
        @RestoredPlaces AS RestoredVeganPlaceRows,
        @RestoredFoods AS RestoredPlaceFoodRows;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF OBJECTPROPERTY(OBJECT_ID(N'dbo.VeganPlaceDuyLD'), 'TableHasIdentity') = 1
    BEGIN TRY
        SET IDENTITY_INSERT dbo.VeganPlaceDuyLD OFF;
    END TRY
    BEGIN CATCH
        PRINT 'IDENTITY_INSERT for dbo.VeganPlaceDuyLD was already OFF.';
    END CATCH;

    IF OBJECTPROPERTY(OBJECT_ID(N'dbo.PlaceFoodDuyLD'), 'TableHasIdentity') = 1
    BEGIN TRY
        SET IDENTITY_INSERT dbo.PlaceFoodDuyLD OFF;
    END TRY
    BEGIN CATCH
        PRINT 'IDENTITY_INSERT for dbo.PlaceFoodDuyLD was already OFF.';
    END CATCH;

    THROW;
END CATCH;
GO

SELECT
    VeganPlaceDuyLDId,
    PlaceName,
    CategoryName,
    Phone,
    Website,
    Rating,
    IsActive
FROM dbo.VeganPlaceDuyLD
WHERE VeganPlaceDuyLDId BETWEEN 1 AND 12
ORDER BY VeganPlaceDuyLDId;
GO

SELECT
    PlaceFoodDuyLDId,
    VeganPlaceDuyLDId,
    FoodName,
    Price,
    IsAvailable
FROM dbo.PlaceFoodDuyLD
WHERE PlaceFoodDuyLDId BETWEEN 1 AND 6
ORDER BY PlaceFoodDuyLDId;
GO
