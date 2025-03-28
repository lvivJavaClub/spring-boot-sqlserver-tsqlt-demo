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
│   │   │   ├── data.sql
│── src/
│   ├── test/
│   │   ├── java/ua/lviv/javaclub/tsqlt/
│   │   │   ├── UserRepositoryTest.java
│   │   │   ├── UserControllerTest.java
│── sql/
│   ├── setup/
│   │   ├── install_tSQLt.sql
│   │   ├── create_procedure.sql
│   │   ├── create_tests.sql
│── docker/
│   ├── docker-compose.yml
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
    url: jdbc:sqlserver://localhost:1433;databaseName=TEST;encrypt=false;trustServerCertificate=true
    username: JAVACLUB
    password: YourStrong!Passw0rd
    driver-class-name: com.microsoft.sqlserver.jdbc.SQLServerDriver

  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    database-platform: org.hibernate.dialect.SQLServerDialect

server:
  port: 8080
```

### 4️⃣ Run the Application
```sh
./gradlew bootRun
```

## 🛠 Stored Procedure (`create_procedure.sql`)
```sql
USE mydb;
GO

CREATE PROCEDURE CreateUser
    @Name NVARCHAR(255),
    @Email NVARCHAR(255)
AS
BEGIN
    INSERT INTO Users (name, email) VALUES (@Name, @Email);
END;
GO
```

## 🚀 REST API Endpoints
| Method | Endpoint | Description |
|--------|---------|-------------|
| `GET` | `/users` | Fetch all users |
| `POST` | `/users` | Create a new user via stored procedure |

### Example Request (POST)
```json
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

## 🥪 tSQLt Test for Stored Procedure (`create_tests.sql`)
```sql
USE mydb;
GO

EXEC tSQLt.NewTestClass 'TestUser';
GO

CREATE PROCEDURE TestUser.[test CreateUser should insert a new user]
AS
BEGIN
EXEC tSQLt.FakeTable 'dbo.Users';
EXEC CreateUser @Name = 'Test User', @Email = 'test@example.com';
EXEC tSQLt.AssertEqualsTable 'dbo.Users', (SELECT name, email FROM dbo.Users);
END;
GO
```

### Run tSQLt Tests
```sql
EXEC tSQLt.Run 'TestUser.[test CreateUser should insert a new user]';
GO
```

## 📜 License
MIT License. Free to use and modify!

---

✅ **You're all set!** Now, start coding 🚀.
