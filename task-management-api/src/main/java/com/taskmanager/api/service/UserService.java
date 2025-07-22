package com.taskmanager.api.service;

import com.taskmanager.api.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface UserService {
    
    User saveUser(User user);
    
    User updateUser(User user);
    
    void deleteUser(Long userId);
    
    Optional<User> getUserById(Long userId);
    
    Optional<User> getUserByUsername(String username);
    
    Optional<User> getUserByEmail(String email);
    
    Page<User> getAllUsers(Pageable pageable);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
    
    void addRoleToUser(String username, String roleName);
} 