package com.taskmanager.api.controller;

import com.taskmanager.api.dto.request.LoginRequest;
import com.taskmanager.api.dto.request.RefreshTokenRequest;
import com.taskmanager.api.dto.request.RegisterRequest;
import com.taskmanager.api.dto.response.JwtResponse;
import com.taskmanager.api.dto.response.MessageResponse;
import com.taskmanager.api.entity.Role;
import com.taskmanager.api.entity.User;
import com.taskmanager.api.repository.UserRepository;
import com.taskmanager.api.security.JwtTokenProvider;
import com.taskmanager.api.service.AuthService;
import org.springframework.security.crypto.password.PasswordEncoder;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Authentication API")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);
    private final AuthService authService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private JwtTokenProvider tokenProvider;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/login")
    @Operation(summary = "Authenticate user and get JWT token")
    public ResponseEntity<JwtResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        logger.debug("Login attempt for user: {}", loginRequest.getUsername());
        try {
            JwtResponse response = authService.authenticateUser(loginRequest);
            logger.debug("Login successful for user: {}", loginRequest.getUsername());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Login failed for user: {}", loginRequest.getUsername(), e);
            throw e;
        }
    }

    @PostMapping("/register")
    @Operation(summary = "Register a new user")
    public ResponseEntity<MessageResponse> register(@Valid @RequestBody RegisterRequest registerRequest) {
        return ResponseEntity.ok(authService.registerUser(registerRequest));
    }

    @PostMapping("/refresh")
    @Operation(summary = "Refresh JWT token")
    public ResponseEntity<JwtResponse> refreshToken(@Valid @RequestBody RefreshTokenRequest refreshTokenRequest) {
        return ResponseEntity.ok(authService.refreshToken(refreshTokenRequest));
    }
    
    @GetMapping("/test")
    @Operation(summary = "Test authentication endpoint")
    public ResponseEntity<MessageResponse> testAuth() {
        return ResponseEntity.ok(new MessageResponse("Authentication endpoint is working"));
    }
    
    @GetMapping("/test-direct-login")
    @Operation(summary = "Test direct login endpoint availability")
    public ResponseEntity<MessageResponse> testDirectLogin() {
        return ResponseEntity.ok(new MessageResponse("Direct login endpoint is available"));
    }
    
    @PostMapping("/direct-login")
    @Operation(summary = "Direct login for testing purposes")
    public ResponseEntity<JwtResponse> directLogin(@Valid @RequestBody LoginRequest loginRequest) {
        logger.debug("Direct login attempt for user: {}", loginRequest.getUsername());
        try {
            // Create a test user with known credentials
            if (!userRepository.existsByUsername(loginRequest.getUsername())) {
                logger.info("Creating test user: {}", loginRequest.getUsername());
                User newUser = new User();
                newUser.setUsername(loginRequest.getUsername());
                newUser.setEmail(loginRequest.getUsername() + "@example.com");
                newUser.setPassword(passwordEncoder.encode(loginRequest.getPassword()));
                newUser.setFirstName("Test");
                newUser.setLastName("User");
                newUser.setRoles(Collections.singleton(Role.ROLE_USER));
                userRepository.save(newUser);
            }
            
            // Find user
            User user = userRepository.findByUsername(loginRequest.getUsername())
                    .orElseThrow(() -> new RuntimeException("User not found"));
            
            // Create authentication manually
            List<SimpleGrantedAuthority> authorities = user.getRoles().stream()
                    .map(role -> new SimpleGrantedAuthority(role.name()))
                    .collect(Collectors.toList());
            
            Authentication authentication = new UsernamePasswordAuthenticationToken(
                    user.getUsername(), null, authorities);
            
            // Generate tokens
            String jwt = tokenProvider.createToken(authentication);
            String refreshToken = tokenProvider.createRefreshToken(authentication.getName());
            
            List<String> roles = user.getRoles().stream()
                    .map(Role::name)
                    .collect(Collectors.toList());
            
            JwtResponse response = new JwtResponse(
                    jwt,
                    refreshToken,
                    user.getId(),
                    user.getUsername(),
                    user.getEmail(),
                    roles
            );
            
            logger.debug("Direct login successful for user: {}", loginRequest.getUsername());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Direct login failed for user: {}", loginRequest.getUsername(), e);
            throw e;
        }
    }
} 