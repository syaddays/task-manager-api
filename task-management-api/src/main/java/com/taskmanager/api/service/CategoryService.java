package com.taskmanager.api.service;

import com.taskmanager.api.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface CategoryService {
    
    Category createCategory(Category category, Long userId);
    
    Category updateCategory(Category category, Long userId);
    
    void deleteCategory(Long categoryId, Long userId);
    
    Optional<Category> getCategoryById(Long categoryId, Long userId);
    
    List<Category> getCategoriesByUserId(Long userId);
    
    Page<Category> getCategoriesByUserId(Long userId, Pageable pageable);
    
    boolean existsByNameAndUserId(String name, Long userId);
} 