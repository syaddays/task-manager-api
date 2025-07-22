package com.taskmanager.api.controller;

import com.taskmanager.api.dto.response.MessageResponse;
import com.taskmanager.api.entity.Role;
import com.taskmanager.api.entity.User;
import com.taskmanager.api.repository.UserRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestController
@Tag(name = "Index", description = "Index API")
public class IndexController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/")
    @Operation(summary = "Get API welcome message")
    public ResponseEntity<MessageResponse> index() {
        return ResponseEntity.ok(new MessageResponse("Welcome to Task Management API"));
    }

    @GetMapping("/api/test/create-user")
    @Operation(summary = "Create a test user")
    public ResponseEntity<MessageResponse> createTestUser() {
        // Check if test user already exists
        if (userRepository.existsByUsername("testuser")) {
            return ResponseEntity.ok(new MessageResponse("Test user already exists"));
        }

        // Create a new test user with a known password
        User user = new User();
        user.setUsername("testuser");
        user.setEmail("testuser@example.com");
        user.setPassword(passwordEncoder.encode("password123"));
        user.setFirstName("Test");
        user.setLastName("User");
        user.setRoles(Collections.singleton(Role.ROLE_USER));

        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("Test user created successfully"));
    }

    @GetMapping("/api/test/ping")
    @Operation(summary = "Simple ping endpoint for testing connectivity")
    public ResponseEntity<Map<String, Object>> ping() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Server is running");
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(response);
    }
} 