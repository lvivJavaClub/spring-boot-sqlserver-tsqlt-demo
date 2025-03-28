package ua.lviv.javaclub.tsqlt;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "Users")
@Data
public class User {

    @Id
    private Long id;
    private String name;
    private String email;
}