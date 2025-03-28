package ua.lviv.javaclub.tsqlt;

import lombok.RequiredArgsConstructor;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;

    @NonNull
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public void createUser(@NonNull final User user) {
        userRepository.createUser(user.getName(), user.getEmail());
    }
}