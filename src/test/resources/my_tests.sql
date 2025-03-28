tSQlt.NewTestClass 'TestUser'
GO

-- Create the test
CREATE PROCEDURE [TestUser].[test CreateUser inserts row]
AS
BEGIN
    -- Arrange: Fake Users table
    EXEC tSQLt.FakeTable @TableName = 'dbo.Users';

    -- Create expected results in a temp table
    CREATE TABLE #Expected (
                               name NVARCHAR(255),
                               email NVARCHAR(255)
    );

    INSERT INTO #Expected (name, email)
    VALUES ('Test User', 'test@example.com');

    -- Act: Call the stored procedure
    EXEC dbo.CreateUser @Name = 'Test User', @Email = 'test@example.com';

    -- Assert: Compare Users table to expected
    EXEC tSQLt.AssertEqualsTable @Expected = '#Expected', @Actual = 'dbo.Users';
END;
