package com.taskmanager.api.repository;

import com.taskmanager.api.entity.Category;
import com.taskmanager.api.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    
    List<Category> findByUser(User user);
    
    List<Category> findByUserId(Long userId);
    
    Optional<Category> findByIdAndUserId(Long id, Long userId);
    
    boolean existsByNameAndUserId(String name, Long userId);
} 