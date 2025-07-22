package com.taskmanager.api.service;

import com.taskmanager.api.dto.request.LoginRequest;
import com.taskmanager.api.dto.request.RefreshTokenRequest;
import com.taskmanager.api.dto.request.RegisterRequest;
import com.taskmanager.api.dto.response.JwtResponse;
import com.taskmanager.api.entity.User;

public interface AuthService {
    
    JwtResponse login(LoginRequest loginRequest);
    
    JwtResponse register(RegisterRequest registerRequest);
    
    JwtResponse refreshToken(RefreshTokenRequest refreshTokenRequest);
    
    User getCurrentUser();
    
    Long getCurrentUserId();
    
    void logout(String refreshToken);
} 