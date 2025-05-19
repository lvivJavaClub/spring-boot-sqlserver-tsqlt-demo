USE master;
GO

IF NOT EXISTS (SELECT *
               FROM INFORMATION_SCHEMA.TABLES
               WHERE TABLE_SCHEMA = 'dbo'
                 AND TABLE_NAME = 'Users')
    BEGIN
        CREATE TABLE dbo.Users
        (
            id    BIGINT IDENTITY PRIMARY KEY,
            name  NVARCHAR(255),
            email NVARCHAR(255),
            score INT
        );
    END
GO
--
CREATE OR ALTER PROCEDURE dbo.CreateUser @Name NVARCHAR(255),
                                         @Email NVARCHAR(255)
AS
BEGIN
    --     3k+ lines

    DECLARE @isEmailExist BIT,
        @Score INT ;

    SET @isEmailExist = dbo.isEmailExist(@Email);

    IF (@isEmailExist = 0)
        BEGIN

            EXEC dbo.getScore @Email, @res = @Score OUTPUT

            INSERT INTO dbo.Users (name, email, score)
            VALUES (@Name, @Email, @Score);
        END
END;
GO

CREATE OR ALTER PROCEDURE dbo.getScore @Email NVARCHAR(255), @res INT OUTPUT
AS
BEGIN
    set @res = 100
END;
GO

CREATE OR ALTER FUNCTION dbo.isEmailExist(
    @Email NVARCHAR(255)
) RETURNS BIT
AS
BEGIN
    RETURN IIF(@Email = 'email100500', 1, 0);
END;
GO
