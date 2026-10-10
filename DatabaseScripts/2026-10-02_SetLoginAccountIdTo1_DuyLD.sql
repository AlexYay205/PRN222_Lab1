-- Normalizes the sample login account to UserAccountID = 1.
-- Login code checks Email + Password + IsActive.

USE [VeganDB];
GO

IF OBJECT_ID(N'dbo.[System.UserAccount]', N'U') IS NULL
    THROW 50001, 'Missing table dbo.[System.UserAccount]. Please create VeganDB schema first.', 1;
GO

BEGIN TRANSACTION;

BEGIN TRY
    DECLARE @TargetUserAccountId INT = 1;
    DECLARE @UserName NVARCHAR(50) = N'duyld.admin';
    DECLARE @Password NVARCHAR(100) = N'123456';
    DECLARE @FullName NVARCHAR(100) = N'DuyLD Admin';
    DECLARE @Email NVARCHAR(150) = N'admin@vegan.local';
    DECLARE @Phone NVARCHAR(50) = N'0900000000';
    DECLARE @EmployeeCode NVARCHAR(50) = N'DUYLD001';
    DECLARE @RoleId INT = 1;
    DECLARE @ApplicationCode NVARCHAR(50) = N'VEGAN_DUYLD';

    DELETE FROM dbo.[System.UserAccount]
    WHERE Email = @Email
      AND UserAccountID <> @TargetUserAccountId;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.[System.UserAccount]
        WHERE UserAccountID = @TargetUserAccountId
    )
    BEGIN
        UPDATE dbo.[System.UserAccount]
        SET
            UserName = @UserName,
            [Password] = @Password,
            FullName = @FullName,
            Email = @Email,
            Phone = @Phone,
            EmployeeCode = @EmployeeCode,
            RoleId = @RoleId,
            RequestCode = N'LOGIN_SAMPLE',
            ApplicationCode = @ApplicationCode,
            ModifiedDate = GETDATE(),
            ModifiedBy = N'seed-script',
            IsActive = 1
        WHERE UserAccountID = @TargetUserAccountId;
    END
    ELSE
    BEGIN
        SET IDENTITY_INSERT dbo.[System.UserAccount] ON;

        INSERT INTO dbo.[System.UserAccount]
        (
            UserAccountID,
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
            @TargetUserAccountId,
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

        SET IDENTITY_INSERT dbo.[System.UserAccount] OFF;
    END

    DECLARE @MaxId INT;
    SELECT @MaxId = ISNULL(MAX(UserAccountID), 0)
    FROM dbo.[System.UserAccount];

    DBCC CHECKIDENT ('dbo.[System.UserAccount]', RESEED, @MaxId) WITH NO_INFOMSGS;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF OBJECTPROPERTY(OBJECT_ID(N'dbo.[System.UserAccount]'), 'TableHasIdentity') = 1
    BEGIN
        BEGIN TRY
            SET IDENTITY_INSERT dbo.[System.UserAccount] OFF;
        END TRY
        BEGIN CATCH
        END CATCH
    END

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
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
ORDER BY UserAccountID;
GO
