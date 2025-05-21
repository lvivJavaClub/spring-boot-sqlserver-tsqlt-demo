tSQlt.NewTestClass 'TestUser'
GO

CREATE PROCEDURE TestUser.[TestClassSetup]
AS
BEGIN
    PRINT 'TestUser TestClassSetup.....'
END;
GO;

CREATE PROCEDURE [TestUser].[SetUp]
AS
BEGIN
    PRINT 'TestUser Setup.....'
END;
GO;

-- ====================================================================================================================
-- Create first test (FakeTable demo)
CREATE PROCEDURE [TestUser].[test CreateUser inserts row with FakeTable]
AS
BEGIN
    -- Arrange: Fake Users table
    EXEC tSQLt.FakeTable @TableName = 'dbo.Users';

    -- Create expected results in a temp table
    CREATE TABLE #Expected
    (
        name  NVARCHAR(255),
        email NVARCHAR(255),
        score INT
    );

    INSERT INTO #Expected (name, email, score)
    VALUES ('Test User', 'test@example.com', 100);

    -- Act: Call the stored procedure
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEqualsTable @Expected = '#Expected', @Actual = 'dbo.Users';
END;
GO;

-- ====================================================================================================================
CREATE PROCEDURE [TestUser].[test CreateUser inserts row with AssertEquals]
AS
BEGIN
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    DECLARE @Size INT = 0;

    SELECT @Size = COUNT(id)
    FROM dbo.Users
    WHERE name = 'Test User'
      AND email = 'test@example.com';

    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @Size;
END;
GO

-- ====================================================================================================================
CREATE PROCEDURE [TestUser].[test Check is Email exist]
AS
BEGIN
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    DECLARE @isEmailExist INT;
    SET @isEmailExist = dbo.isEmailExist('test@example.com');

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @isEmailExist;
END;
GO

CREATE PROCEDURE [TestUser].[test Check is Email does not exist]
AS
BEGIN
    DECLARE @isEmailExist INT;
    SET @isEmailExist = dbo.isEmailExist('test@example.com');

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEquals @Expected = 0, @Actual = @isEmailExist;
END;
GO

CREATE PROCEDURE [TestUser].[test Error in test]
AS
BEGIN
    EXEC dbo.CreateUser @Name = NULL;
END;
GO

-- ====================================================================================================================
-- Create old test (Skip demo)
tSQlt.NewTestClass 'OldTestUser'
GO

CREATE PROCEDURE OldTestUser.[TestClassSetup]
AS
BEGIN
    PRINT 'OldTestUser TestClassSetup.....'
END;
GO;

CREATE PROCEDURE [OldTestUser].[SetUp]
AS
BEGIN
    PRINT 'OldTestUser Setup.....'
END;
GO;

--[@tSQLt:SkipTest]('Some old test')
CREATE PROCEDURE [OldTestUser].[test CreateUser inserts row old]
AS
BEGIN
    -- Arrange: Fake Users table
    EXEC tSQLt.FakeTable @TableName = 'dbo.Users';

    -- Create expected results in a temp table
    CREATE TABLE #Expected
    (
        name  NVARCHAR(255),
        email NVARCHAR(255),
        score INT
    );

    INSERT INTO #Expected (name, email, score)
    VALUES ('Test User', 'test@example.com', 100);

    -- Act: Call the stored procedure
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEqualsTable @Expected = '#Expected', @Actual = 'dbo.Users';
END;
GO

--[@tSQLt:MaxSqlMajorVersion](15)
CREATE PROCEDURE [OldTestUser].[test CreateUser inserts row with MaxSqlMajorVersion]
AS
BEGIN
    -- Arrange: Fake Users table
    EXEC tSQLt.FakeTable @TableName = 'dbo.Users';

    -- Create expected results in a temp table
    CREATE TABLE #Expected
    (
        name  NVARCHAR(255),
        email NVARCHAR(255),
        score INT
    );

    INSERT INTO #Expected (name, email, score)
    VALUES ('Test User', 'test@example.com', 100);

    -- Act: Call the stored procedure
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEqualsTable @Expected = '#Expected', @Actual = 'dbo.Users';
END;
GO

--[@tSQLt:MinSqlMajorVersion](17)
CREATE PROCEDURE [OldTestUser].[test CreateUser inserts row with MinSqlMajorVersion]
AS
BEGIN
    -- Arrange: Fake Users table
    EXEC tSQLt.FakeTable @TableName = 'dbo.Users';

    -- Create expected results in a temp table
    CREATE TABLE #Expected
    (
        name  NVARCHAR(255),
        email NVARCHAR(255),
        score INT
    );

    INSERT INTO #Expected (name, email, score)
    VALUES ('Test User', 'test@example.com', 100);

    -- Act: Call the stored procedure
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEqualsTable @Expected = '#Expected', @Actual = 'dbo.Users';
END;
GO

-- ====================================================================================================================
CREATE OR ALTER FUNCTION TestUser.EmailExist(
    @Email NVARCHAR(255)
) RETURNS BIT
AS
BEGIN
    RETURN 1;
END;
GO

CREATE PROCEDURE [TestUser].[[test CreateUser inserts row with FakeFunction]
AS
BEGIN

    EXEC tSQLt.FakeFunction 'dbo.isEmailExist', 'TestUser.EmailExist';

    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    DECLARE @Size INT = 0;
    SELECT @Size = COUNT(id)
    FROM dbo.Users
    WHERE email = 'test@example.com';

    EXEC tSQLt.AssertEquals @Expected = 0, @Actual = @Size;
END;
GO;

-- ====================================================================================================================
CREATE OR ALTER PROCEDURE TestUser.CreateUser @Name NVARCHAR(255),
                                              @Email NVARCHAR(255)
AS
BEGIN
    INSERT INTO dbo.Users (name, email)
    VALUES (@Email, @Name);
END;
GO

CREATE PROCEDURE [TestUser].[test CreateUser inserts row with SpyProcedure]
AS
BEGIN
    -- Arrange: Fake Users table
    EXEC tSQLt.FakeTable @TableName = 'dbo.Users';

    -- Create expected results in a temp table
    CREATE TABLE #Expected
    (
        name  NVARCHAR(255),
        email NVARCHAR(255),
        score INT
    );

    INSERT INTO #Expected (name, email, score)
    VALUES ('Test User', 'test@example.com', 500);

    -- Act: Call the stored procedure
    EXEC tSQLt.SpyProcedure 'dbo.getScore', 'SET @res = 500';
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEqualsTable @Expected = '#Expected', @Actual = 'dbo.Users';
END;
GO;

-- ====================================================================================================================
--[@tSQLt:print](100500)
CREATE PROCEDURE [TestUser].[test Annotation]
AS
BEGIN
    print 'Annotation ...'
END;
GO;


