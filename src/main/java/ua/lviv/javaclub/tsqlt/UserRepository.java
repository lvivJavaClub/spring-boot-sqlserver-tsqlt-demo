package ua.lviv.javaclub.tsqlt;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

public interface UserRepository extends JpaRepository<User, Long> {

    @Procedure(name = "dbo.CreateUser")
    void createUser(String name, String email);
}
