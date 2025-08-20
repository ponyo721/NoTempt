package com.ponyo.notempt.service;


import com.ponyo.notempt.model.User;
import com.ponyo.notempt.model.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
//@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User registerUser(String username, String password, String email) {
        String hashed = passwordEncoder.encode(password);

        if (userRepository.existsByUsername(username)) {
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
        }

        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(hashed);
        user.setEmail(email);

        return userRepository.save(user);
    }

    // 회원가입
    public User register(String username, String email, String rawPassword) {
        String hashed = passwordEncoder.encode(rawPassword);

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(hashed);

        return userRepository.save(user);
    }

    // 로그인
    public boolean login(String email, String rawPassword) {
        return userRepository.findByEmail(email).map(user -> {
            if (user.isLocked()) {
                return false; // 잠긴 계정
            }
            boolean matches = passwordEncoder.matches(rawPassword, user.getPasswordHash());

            if (matches) {
                user.setFailedAttempts(0);
                user.setLastLoginAt(LocalDateTime.now());
                return true;
            } else {
                user.setFailedAttempts(user.getFailedAttempts() + 1);
                if (user.getFailedAttempts() >= 5) { // 실패 5회 → 잠금
                    user.setLocked(true);
                }
                return false;
            }
        }).orElse(false);
    }
}