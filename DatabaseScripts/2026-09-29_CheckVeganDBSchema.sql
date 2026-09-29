USE [VeganDB];
GO

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('VeganPlaceDuyLD', 'PlaceFoodDuyLD', 'System.UserAccount')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

SELECT
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'VeganPlaceDuyLDId') AS VeganPlaceDuyLDId,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'CategoryName') AS CategoryName,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'CategoryDescription') AS CategoryDescription,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'CategoryDisplayOrder') AS CategoryDisplayOrder,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'PlaceName') AS PlaceName,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'Address') AS Address,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'Phone') AS Phone,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'Website') AS Website,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'Description') AS Description,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'Latitude') AS Latitude,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'Longitude') AS Longitude,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'Rating') AS Rating,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'CreatedAt') AS CreatedAt,
    COL_LENGTH('dbo.VeganPlaceDuyLD', 'IsActive') AS IsActive;
GO

SELECT
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'PlaceFoodDuyLDId') AS PlaceFoodDuyLDId,
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'VeganPlaceDuyLDId') AS VeganPlaceDuyLDId,
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'IngredientDuyPNId') AS IngredientDuyPNId,
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'FoodName') AS FoodName,
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'Description') AS Description,
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'Price') AS Price,
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'CreatedAt') AS CreatedAt,
    COL_LENGTH('dbo.PlaceFoodDuyLD', 'IsAvailable') AS IsAvailable;
GO

SELECT COUNT(*) AS VeganPlaceCount
FROM dbo.VeganPlaceDuyLD;
GO

SELECT COUNT(*) AS PlaceFoodCount
FROM dbo.PlaceFoodDuyLD;
GO

SELECT TOP 50
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
FROM dbo.VeganPlaceDuyLD
ORDER BY VeganPlaceDuyLDId DESC;
GO

SELECT TOP 50
    food.PlaceFoodDuyLDId,
    food.VeganPlaceDuyLDId,
    place.PlaceName,
    place.CategoryName,
    food.IngredientDuyPNId,
    food.FoodName,
    food.Description,
    food.Price,
    food.CreatedAt,
    food.IsAvailable
FROM dbo.PlaceFoodDuyLD AS food
LEFT JOIN dbo.VeganPlaceDuyLD AS place
    ON food.VeganPlaceDuyLDId = place.VeganPlaceDuyLDId
ORDER BY food.PlaceFoodDuyLDId DESC;
GO

SELECT food.*
FROM dbo.PlaceFoodDuyLD AS food
LEFT JOIN dbo.VeganPlaceDuyLD AS place
    ON food.VeganPlaceDuyLDId = place.VeganPlaceDuyLDId
WHERE place.VeganPlaceDuyLDId IS NULL;
GO
