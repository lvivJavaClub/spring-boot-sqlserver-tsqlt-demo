USE master;
GO
CREATE TABLE dbo.Users
(
    id    BIGINT IDENTITY PRIMARY KEY,
    name  NVARCHAR(255),
    email NVARCHAR(255)
);
GO
--
CREATE PROCEDURE dbo.CreateUser @Name NVARCHAR(255),
                                @Email NVARCHAR(255)
AS
BEGIN
    --     3k lines
    INSERT INTO dbo.Users (name, email)
    VALUES (@Name, @Email);
END;
GO
