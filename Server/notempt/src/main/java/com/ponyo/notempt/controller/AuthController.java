package com.ponyo.notempt.controller;

import com.ponyo.notempt.model.LoginRequest;
import com.ponyo.notempt.model.User;
import com.ponyo.notempt.model.UserRepository;
import com.ponyo.notempt.service.JwtTokenService;
import com.ponyo.notempt.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;

@RestController
@RequestMapping("/api")
public class AuthController {
    private final UserRepository userRepository;
    private final JwtTokenService jwtTokenService;
    private final UserService userService;

    @Autowired
    public AuthController(UserRepository userRepository, JwtTokenService jwtTokenService, UserService userService) {
        this.userRepository = userRepository;
        this.jwtTokenService = jwtTokenService;
        this.userService = userService;
    }

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestParam String username,
                                      @RequestParam String password,
                                      @RequestParam String email) {
        try {
            User savedUser = userService.registerUser(username, password, email);
            return ResponseEntity.ok("회원가입 성공: " + savedUser.getUsername());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("회원가입 실패: " + e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestParam String email,
                                   @RequestParam String password) {
        boolean success = userService.login(email, password);
        if (!success) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인 실패: 잘못된 이메일 또는 비밀번호");
        }

        String token = jwtTokenService.generateToken(email);
        return ResponseEntity.ok(Collections.singletonMap("token", token));
    }
}