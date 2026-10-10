    -- Creates VeganDB and reseeds the two DuyLD tables from scratch.
    -- Warning: existing dbo.PlaceFoodDuyLD and dbo.VeganPlaceDuyLD tables are dropped before being recreated.

    IF DB_ID(N'VeganDB') IS NULL
    BEGIN
        CREATE DATABASE [VeganDB];
    END
    GO

    USE [VeganDB];
    GO

    IF OBJECT_ID(N'dbo.PlaceFoodDuyLD', N'U') IS NOT NULL
    BEGIN
        DROP TABLE dbo.PlaceFoodDuyLD;
    END
    GO

    IF OBJECT_ID(N'dbo.VeganPlaceDuyLD', N'U') IS NOT NULL
    BEGIN
        DROP TABLE dbo.VeganPlaceDuyLD;
    END
    GO

    CREATE TABLE dbo.VeganPlaceDuyLD
    (
        VeganPlaceDuyLDId BIGINT IDENTITY(1,1) NOT NULL,
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
        CreatedAt DATETIME NOT NULL
            CONSTRAINT DF_VeganPlaceDuyLD_CreatedAt DEFAULT (GETDATE()),
        IsActive BIT NOT NULL
            CONSTRAINT DF_VeganPlaceDuyLD_IsActive DEFAULT ((1)),
        CONSTRAINT PK_VeganPlaceDuyLD PRIMARY KEY CLUSTERED (VeganPlaceDuyLDId)
    );
    GO

    CREATE INDEX IX_VeganPlaceDuyLD_CategoryName
    ON dbo.VeganPlaceDuyLD(CategoryName);
    GO

    CREATE INDEX IX_VeganPlaceDuyLD_Location
    ON dbo.VeganPlaceDuyLD(Latitude, Longitude);
    GO

    CREATE TABLE dbo.PlaceFoodDuyLD
    (
        PlaceFoodDuyLDId BIGINT IDENTITY(1,1) NOT NULL,
        VeganPlaceDuyLDId BIGINT NOT NULL,
        IngredientDuyPNId BIGINT NULL,
        FoodName NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Price DECIMAL(12, 2) NULL,
        CreatedAt DATETIME NOT NULL
            CONSTRAINT DF_PlaceFoodDuyLD_CreatedAt DEFAULT (GETDATE()),
        IsAvailable BIT NOT NULL
            CONSTRAINT DF_PlaceFoodDuyLD_IsAvailable DEFAULT ((1)),
        CONSTRAINT PK_PlaceFoodDuyLD PRIMARY KEY CLUSTERED (PlaceFoodDuyLDId),
        CONSTRAINT FK_PlaceFoodDuyLD_Place
            FOREIGN KEY (VeganPlaceDuyLDId)
            REFERENCES dbo.VeganPlaceDuyLD(VeganPlaceDuyLDId)
    );
    GO

    CREATE INDEX IX_PlaceFoodDuyLD_VeganPlaceDuyLDId
    ON dbo.PlaceFoodDuyLD(VeganPlaceDuyLDId);
    GO

    CREATE INDEX IX_PlaceFoodDuyLD_IngredientDuyPNId
    ON dbo.PlaceFoodDuyLD(IngredientDuyPNId);
    GO

    SET IDENTITY_INSERT dbo.VeganPlaceDuyLD ON;
    GO

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
    VALUES
    (
        1,
        N'Nhà hàng chay',
        N'Món chay phục vụ tại quán',
        1.00,
        N'Nhà hàng Chay Mộc Xanh',
        N'12 Đường Minh Họa, Quận Mẫu, TP. Hồ Chí Minh',
        NULL,
        NULL,
        N'Nhà hàng chay với thực đơn cơm và bún.',
        NULL,
        NULL,
        4.50,
        '2026-09-25T16:11:17',
        1
    ),
    (
        2,
        N'Quán ăn chay',
        N'Món chay bình dân',
        2.00,
        N'Quán Chay Lá Non',
        N'25 Đường Ví Dụ, Quận Mẫu, TP. Hồ Chí Minh',
        NULL,
        NULL,
        N'Quán chay phục vụ bữa trưa và bữa tối.',
        NULL,
        NULL,
        4.20,
        '2026-09-25T16:11:17',
        1
    ),
    (
        3,
        N'Tiệm bánh chay',
        N'Bánh và đồ ăn nhẹ thuần chay',
        3.00,
        N'Tiệm Bánh Chay An Nhiên',
        N'8 Đường Thử Nghiệm, Quận Mẫu, TP. Hồ Chí Minh',
        NULL,
        NULL,
        N'Tiệm bánh thuần chay dùng cho dữ liệu kiểm thử.',
        NULL,
        NULL,
        4.70,
        '2026-09-25T16:11:17',
        1
    );
    GO

    SET IDENTITY_INSERT dbo.VeganPlaceDuyLD OFF;
    GO

    SET IDENTITY_INSERT dbo.PlaceFoodDuyLD ON;
    GO

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
    VALUES
    (
        1,
        1,
        NULL,
        N'Cơm nấm sốt tiêu',
        N'Cơm ăn kèm nấm và rau củ.',
        65000.00,
        '2026-09-25T16:11:17',
        1
    ),
    (
        2,
        1,
        NULL,
        N'Bún riêu chay',
        N'Bún với đậu hũ và rau sống.',
        55000.00,
        '2026-09-25T16:11:17',
        1
    ),
    (
        3,
        2,
        NULL,
        N'Cơm tấm chay',
        N'Cơm tấm với sườn chay và bì chay.',
        45000.00,
        '2026-09-25T16:11:17',
        1
    ),
    (
        4,
        2,
        NULL,
        N'Phở nấm chay',
        N'Phở nước dùng rau củ và nấm.',
        50000.00,
        '2026-09-25T16:11:17',
        1
    ),
    (
        5,
        3,
        NULL,
        N'Bánh mì nấm',
        N'Bánh mì kẹp nấm và rau củ.',
        35000.00,
        '2026-09-25T16:11:17',
        1
    ),
    (
        6,
        3,
        NULL,
        N'Bánh chuối yến mạch',
        N'Bánh ngọt thuần chay dùng chuối và yến mạch.',
        30000.00,
        '2026-09-25T16:11:17',
        1
    );
    GO

    SET IDENTITY_INSERT dbo.PlaceFoodDuyLD OFF;
    GO

    SELECT
        place.VeganPlaceDuyLDId,
        place.PlaceName,
        place.CategoryName,
        COUNT(food.PlaceFoodDuyLDId) AS FoodCount
    FROM dbo.VeganPlaceDuyLD AS place
    LEFT JOIN dbo.PlaceFoodDuyLD AS food
        ON place.VeganPlaceDuyLDId = food.VeganPlaceDuyLDId
    GROUP BY
        place.VeganPlaceDuyLDId,
        place.PlaceName,
        place.CategoryName
    ORDER BY place.VeganPlaceDuyLDId;
    GO
