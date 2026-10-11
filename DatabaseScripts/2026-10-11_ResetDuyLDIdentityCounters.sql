-- Resets DuyLD identity counters to the current maximum IDs.
-- Use this after deleting test rows so the next inserted row continues from MAX(id) + 1.
-- This script does not delete or update existing data.

USE [VeganDB];
GO

IF OBJECT_ID(N'dbo.VeganPlaceDuyLD', N'U') IS NULL
    THROW 50001, 'Missing table dbo.VeganPlaceDuyLD.', 1;

IF OBJECT_ID(N'dbo.PlaceFoodDuyLD', N'U') IS NULL
    THROW 50002, 'Missing table dbo.PlaceFoodDuyLD.', 1;
GO

DECLARE @MaxVeganPlaceId BIGINT;
DECLARE @MaxPlaceFoodId BIGINT;

SELECT @MaxVeganPlaceId = ISNULL(MAX(VeganPlaceDuyLDId), 0)
FROM dbo.VeganPlaceDuyLD;

SELECT @MaxPlaceFoodId = ISNULL(MAX(PlaceFoodDuyLDId), 0)
FROM dbo.PlaceFoodDuyLD;

DBCC CHECKIDENT ('dbo.VeganPlaceDuyLD', RESEED, @MaxVeganPlaceId) WITH NO_INFOMSGS;
DBCC CHECKIDENT ('dbo.PlaceFoodDuyLD', RESEED, @MaxPlaceFoodId) WITH NO_INFOMSGS;

SELECT
    @MaxVeganPlaceId AS CurrentMaxVeganPlaceDuyLDId,
    @MaxVeganPlaceId + 1 AS NextVeganPlaceDuyLDId,
    @MaxPlaceFoodId AS CurrentMaxPlaceFoodDuyLDId,
    @MaxPlaceFoodId + 1 AS NextPlaceFoodDuyLDId;
GO
