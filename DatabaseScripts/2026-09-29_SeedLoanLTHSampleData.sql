-- Seeds sample data for LoanLTH tables in VeganDB.
-- This script does not create Role/User data because those tables belong to shared/member data.
-- Safe to run multiple times: rows are matched by stable sample titles/messages.

USE [VeganDB];
GO

IF OBJECT_ID(N'dbo.[User]', N'U') IS NULL
    THROW 50002, 'Missing table dbo.[User]. Please create VeganDB schema first.', 1;

IF OBJECT_ID(N'dbo.AIConversationLoanLTH', N'U') IS NULL
    THROW 50003, 'Missing table dbo.AIConversationLoanLTH. Please create VeganDB schema first.', 1;

IF OBJECT_ID(N'dbo.AIMessageLoanLTH', N'U') IS NULL
    THROW 50004, 'Missing table dbo.AIMessageLoanLTH. Please create VeganDB schema first.', 1;
GO

DECLARE @UserId BIGINT;
DECLARE @ConversationId1 BIGINT;
DECLARE @ConversationId2 BIGINT;
DECLARE @RecipeId BIGINT;

-- Set this value when you want to seed LoanLTH data for a specific existing user.
-- Leave NULL to use the first active user in dbo.[User].
DECLARE @SeedUserId BIGINT = NULL;

IF @SeedUserId IS NOT NULL
BEGIN
    SELECT TOP (1)
        @UserId = UserId
    FROM dbo.[User]
    WHERE UserId = @SeedUserId;
END
ELSE
BEGIN
    SELECT TOP (1)
        @UserId = UserId
    FROM dbo.[User]
    WHERE IsActive = 1
      AND Status = N'ACTIVE'
    ORDER BY UserId;
END

IF @UserId IS NULL
    THROW 50005, 'No existing active user found. Insert shared/member data first, or set @SeedUserId to an existing dbo.[User].UserId.', 1;

IF OBJECT_ID(N'dbo.RecipeDuyPN', N'U') IS NOT NULL
BEGIN
    SELECT TOP (1)
        @RecipeId = RecipeDuyPNId
    FROM dbo.RecipeDuyPN
    ORDER BY RecipeDuyPNId;
END

SELECT TOP (1)
    @ConversationId1 = AIConversationLoanLTHId
FROM dbo.AIConversationLoanLTH
WHERE UserId = @UserId
  AND Title = N'Tư vấn thực đơn chay giàu đạm';

IF @ConversationId1 IS NULL
BEGIN
    INSERT INTO dbo.AIConversationLoanLTH
    (
        UserId,
        Title,
        ConversationStatus,
        TokenCost,
        StartedAt,
        EndedAt,
        IsActive
    )
    VALUES
    (
        @UserId,
        N'Tư vấn thực đơn chay giàu đạm',
        N'ACTIVE',
        0.0525,
        DATEADD(DAY, -2, GETDATE()),
        NULL,
        1
    );

    SET @ConversationId1 = CONVERT(BIGINT, SCOPE_IDENTITY());
END

SELECT TOP (1)
    @ConversationId2 = AIConversationLoanLTHId
FROM dbo.AIConversationLoanLTH
WHERE UserId = @UserId
  AND Title = N'Gợi ý món ăn sau buổi tập';

IF @ConversationId2 IS NULL
BEGIN
    INSERT INTO dbo.AIConversationLoanLTH
    (
        UserId,
        Title,
        ConversationStatus,
        TokenCost,
        StartedAt,
        EndedAt,
        IsActive
    )
    VALUES
    (
        @UserId,
        N'Gợi ý món ăn sau buổi tập',
        N'ENDED',
        0.0340,
        DATEADD(DAY, -1, GETDATE()),
        DATEADD(HOUR, -20, GETDATE()),
        1
    );

    SET @ConversationId2 = CONVERT(BIGINT, SCOPE_IDENTITY());
END

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.AIMessageLoanLTH
    WHERE AIConversationLoanLTHId = @ConversationId1
      AND SenderType = N'USER'
      AND Message = N'Tôi cần thực đơn chay giàu đạm cho bữa trưa.'
)
BEGIN
    INSERT INTO dbo.AIMessageLoanLTH
    (
        AIConversationLoanLTHId,
        SenderType,
        Message,
        ModelName,
        ConfidenceScore,
        RecipeDuyPNId,
        RecommendationType,
        RecommendationReason,
        RecommendationScore,
        CreatedAt,
        IsActive
    )
    VALUES
    (
        @ConversationId1,
        N'USER',
        N'Tôi cần thực đơn chay giàu đạm cho bữa trưa.',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        DATEADD(DAY, -2, GETDATE()),
        1
    );
END

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.AIMessageLoanLTH
    WHERE AIConversationLoanLTHId = @ConversationId1
      AND SenderType = N'AI'
      AND Message = N'Bạn có thể chọn đậu hũ áp chảo, nấm, rau xanh và một phần cơm gạo lứt.'
)
BEGIN
    INSERT INTO dbo.AIMessageLoanLTH
    (
        AIConversationLoanLTHId,
        SenderType,
        Message,
        ModelName,
        ConfidenceScore,
        RecipeDuyPNId,
        RecommendationType,
        RecommendationReason,
        RecommendationScore,
        CreatedAt,
        IsActive
    )
    VALUES
    (
        @ConversationId1,
        N'AI',
        N'Bạn có thể chọn đậu hũ áp chảo, nấm, rau xanh và một phần cơm gạo lứt.',
        N'gpt-sample-vegan',
        0.9200,
        NULL,
        NULL,
        NULL,
        NULL,
        DATEADD(DAY, -2, DATEADD(MINUTE, 1, GETDATE())),
        1
    );
END

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.AIMessageLoanLTH
    WHERE AIConversationLoanLTHId = @ConversationId2
      AND SenderType = N'USER'
      AND Message = N'Sau khi tập gym tôi nên ăn món chay nào?'
)
BEGIN
    INSERT INTO dbo.AIMessageLoanLTH
    (
        AIConversationLoanLTHId,
        SenderType,
        Message,
        ModelName,
        ConfidenceScore,
        RecipeDuyPNId,
        RecommendationType,
        RecommendationReason,
        RecommendationScore,
        CreatedAt,
        IsActive
    )
    VALUES
    (
        @ConversationId2,
        N'USER',
        N'Sau khi tập gym tôi nên ăn món chay nào?',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        DATEADD(DAY, -1, GETDATE()),
        1
    );
END

IF @RecipeId IS NOT NULL
AND NOT EXISTS
(
    SELECT 1
    FROM dbo.AIMessageLoanLTH
    WHERE AIConversationLoanLTHId = @ConversationId2
      AND SenderType = N'AI'
      AND RecommendationType = N'POST_WORKOUT'
)
BEGIN
    INSERT INTO dbo.AIMessageLoanLTH
    (
        AIConversationLoanLTHId,
        SenderType,
        Message,
        ModelName,
        ConfidenceScore,
        RecipeDuyPNId,
        RecommendationType,
        RecommendationReason,
        RecommendationScore,
        CreatedAt,
        IsActive
    )
    VALUES
    (
        @ConversationId2,
        N'AI',
        N'Tôi gợi ý một món có nguồn đạm thực vật, tinh bột vừa đủ và rau xanh để phục hồi sau tập.',
        N'gpt-sample-vegan',
        0.8800,
        @RecipeId,
        N'POST_WORKOUT',
        N'Phù hợp cho bữa sau tập vì cân bằng giữa đạm thực vật và năng lượng.',
        0.9100,
        DATEADD(DAY, -1, DATEADD(MINUTE, 2, GETDATE())),
        1
    );
END
ELSE IF @RecipeId IS NULL
AND NOT EXISTS
(
    SELECT 1
    FROM dbo.AIMessageLoanLTH
    WHERE AIConversationLoanLTHId = @ConversationId2
      AND SenderType = N'AI'
      AND Message = N'Bạn nên chọn món có đậu hũ, các loại đậu, rau xanh và một phần tinh bột vừa phải.'
)
BEGIN
    INSERT INTO dbo.AIMessageLoanLTH
    (
        AIConversationLoanLTHId,
        SenderType,
        Message,
        ModelName,
        ConfidenceScore,
        RecipeDuyPNId,
        RecommendationType,
        RecommendationReason,
        RecommendationScore,
        CreatedAt,
        IsActive
    )
    VALUES
    (
        @ConversationId2,
        N'AI',
        N'Bạn nên chọn món có đậu hũ, các loại đậu, rau xanh và một phần tinh bột vừa phải.',
        N'gpt-sample-vegan',
        0.8600,
        NULL,
        NULL,
        NULL,
        NULL,
        DATEADD(DAY, -1, DATEADD(MINUTE, 2, GETDATE())),
        1
    );
END

SELECT
    c.AIConversationLoanLTHId,
    c.UserId,
    c.Title,
    c.ConversationStatus,
    c.TokenCost,
    c.StartedAt,
    c.EndedAt,
    c.IsActive
FROM dbo.AIConversationLoanLTH AS c
WHERE c.UserId = @UserId
ORDER BY c.AIConversationLoanLTHId;

SELECT
    m.AIMessageLoanLTHId,
    m.AIConversationLoanLTHId,
    m.SenderType,
    m.Message,
    m.ModelName,
    m.ConfidenceScore,
    m.RecipeDuyPNId,
    m.RecommendationType,
    m.RecommendationScore,
    m.CreatedAt,
    m.IsActive
FROM dbo.AIMessageLoanLTH AS m
WHERE m.AIConversationLoanLTHId IN (@ConversationId1, @ConversationId2)
ORDER BY m.AIConversationLoanLTHId, m.AIMessageLoanLTHId;
GO
