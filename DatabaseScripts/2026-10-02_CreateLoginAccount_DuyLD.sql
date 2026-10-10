-- Creates or updates one login account for Vegan.MVCWebApp.DuyLD.
-- Login code checks Email + Password + IsActive.

USE [VeganDB];
GO

IF OBJECT_ID(N'dbo.[System.UserAccount]', N'U') IS NULL
    THROW 50001, 'Missing table dbo.[System.UserAccount]. Please create VeganDB schema first.', 1;
GO

DECLARE @UserName NVARCHAR(50) = N'duyld.admin';
DECLARE @Password NVARCHAR(100) = N'123456';
DECLARE @FullName NVARCHAR(100) = N'DuyLD Admin';
DECLARE @Email NVARCHAR(150) = N'admin@vegan.local';
DECLARE @Phone NVARCHAR(50) = N'0900000000';
DECLARE @EmployeeCode NVARCHAR(50) = N'DUYLD001';
DECLARE @RoleId INT = 1;
DECLARE @ApplicationCode NVARCHAR(50) = N'VEGAN_DUYLD';

IF EXISTS
(
    SELECT 1
    FROM dbo.[System.UserAccount]
    WHERE Email = @Email
)
BEGIN
    UPDATE dbo.[System.UserAccount]
    SET
        UserName = @UserName,
        [Password] = @Password,
        FullName = @FullName,
        Phone = @Phone,
        EmployeeCode = @EmployeeCode,
        RoleId = @RoleId,
        RequestCode = N'LOGIN_SAMPLE',
        ApplicationCode = @ApplicationCode,
        ModifiedDate = GETDATE(),
        ModifiedBy = N'seed-script',
        IsActive = 1
    WHERE Email = @Email;
END
ELSE
BEGIN
    INSERT INTO dbo.[System.UserAccount]
    (
        UserName,
        [Password],
        FullName,
        Email,
        Phone,
        EmployeeCode,
        RoleId,
        RequestCode,
        CreatedDate,
        ApplicationCode,
        CreatedBy,
        ModifiedDate,
        ModifiedBy,
        IsActive
    )
    VALUES
    (
        @UserName,
        @Password,
        @FullName,
        @Email,
        @Phone,
        @EmployeeCode,
        @RoleId,
        N'LOGIN_SAMPLE',
        GETDATE(),
        @ApplicationCode,
        N'seed-script',
        NULL,
        NULL,
        1
    );
END
GO

SELECT
    UserAccountID,
    UserName,
    FullName,
    Email,
    [Password],
    RoleId,
    IsActive
FROM dbo.[System.UserAccount]
WHERE Email = N'admin@vegan.local';
GO
