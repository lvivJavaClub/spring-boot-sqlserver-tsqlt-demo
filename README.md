# Spring Boot + SQL Server + tSQLt Demo

## 📌 Project Overview
This project is a Spring Boot application that connects to a SQL Server database, provides a REST API to manage users, and includes a stored procedure for user creation. The stored procedure is tested using **tSQLt**, a unit testing framework for SQL Server.

## 📁 Project Structure
```
spring-boot-sqlserver-tsqlt-demo/
│── src/
│   ├── main/
│   │   ├── java/ua/lviv/javaclub/tsqlt/
│   │   │   ├── TaskEstimationApplication.java
│   │   │   ├── controller/
│   │   │   │   ├── UserController.java
│   │   │   ├── entity/
│   │   │   │   ├── User.java
│   │   │   ├── repository/
│   │   │   │   ├── UserRepository.java
│   │   │   ├── service/
│   │   │   │   ├── UserService.java
│   │   ├── resources/
│   │   │   ├── application.yml
│   │   │   ├── schema.sql
│   │   │   ├── create-user.http
│   │   │   ├── get-users.http
│   ├── test/
│   │   ├── resources/
│   │   │   ├── FacadeDacpacs/
│   │   │   │   ├── tSQLtFacade.*.dacpac (various versions)
│   │   │   ├── PrepareServer.sql
│   │   │   ├── my_tests.sql
│   │   │   ├── run.sql
│   │   │   ├── tSQLt.class.sql
│   │   │   ├── tSQLt.print.sql
│── docker-compose.yml
│── build.gradle
│── README.md
```

## 🛠 Setup & Installation
### 1️⃣ Prerequisites
- **Java 17+**
- **Gradle**
- **Docker** (for SQL Server)

### 2️⃣ Start SQL Server with Docker
```sh
docker-compose up -d
```
This starts SQL Server on `localhost:1433`.

### 3️⃣ Configure Database in `application.yml`
```yaml
spring:
  datasource:
    url: jdbc:sqlserver://localhost:1433;databaseName=master;encrypt=false;trustServerCertificate=true
    username: sa
    password: YourStrong!Passw0rd
    driver-class-name: com.microsoft.sqlserver.jdbc.SQLServerDriver

  jpa:
    show-sql: true
    database-platform: org.hibernate.dialect.SQLServerDialect
    hibernate:
      ddl-auto: none

server:
  port: 8080
```

### 4️⃣ Run the Application
```sh
./gradlew bootRun
```

## 🛠 Stored Procedure (in `schema.sql`)
```sql
CREATE OR ALTER PROCEDURE dbo.CreateUser @Name NVARCHAR(255),
                                         @Email NVARCHAR(255)
AS
BEGIN
    DECLARE @isEmailExist BIT,
        @Score INT;

    SET @isEmailExist = dbo.isEmailExist(@Email);

    IF (@isEmailExist = 0)
        BEGIN
            EXEC dbo.getScore @Email, @res = @Score OUTPUT

            INSERT INTO dbo.Users (name, email, score)
            VALUES (@Name, @Email, @Score);
        END
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

CREATE OR ALTER PROCEDURE dbo.getScore @Email NVARCHAR(255), @res INT OUTPUT
AS
BEGIN
    set @res = 100
END;
GO
```

## 🚀 REST API Endpoints
| Method  | Endpoint   | Description                            |
|---------|------------|----------------------------------------|
| `GET`   | `/users`   | Fetch all users                        |
| `POST`  | `/users`   | Create a new user via stored procedure |

### Example Request (POST)
```json
{
  "name": "John Doe",
  "email": "john@example.com"
}
```


### Run tSQLt Tests
```sql
-- Run all tests across all test classes
EXEC tSQLt.RunAll;
GO

-- Run all tests in TestUser class
EXEC tSQLt.Run 'TestUser';
GO

-- Run a specific test
EXEC tSQLt.Run 'TestUser.[test CreateUser inserts row with FakeTable]';
GO
```

## 📜 License
MIT License. Free to use and modify!

---

✅ **You're all set!** Now, start coding 🚀.
