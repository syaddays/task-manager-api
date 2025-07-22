package com.taskmanager.api.service.impl;

import com.taskmanager.api.entity.Category;
import com.taskmanager.api.entity.User;
import com.taskmanager.api.repository.CategoryRepository;
import com.taskmanager.api.repository.UserRepository;
import com.taskmanager.api.service.CategoryService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryServiceImpl implements CategoryService {
    
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    
    @Override
    public Category createCategory(Category category, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        
        // Check if category with same name already exists for this user
        if (categoryRepository.existsByNameAndUserId(category.getName(), userId)) {
            throw new IllegalArgumentException("Category with name '" + category.getName() + "' already exists for this user");
        }
        
        category.setUser(user);
        return categoryRepository.save(category);
    }
    
    @Override
    public Category updateCategory(Category category, Long userId) {
        Category existingCategory = categoryRepository.findByIdAndUserId(category.getId(), userId)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + category.getId()));
        
        // Check if another category with the same name exists for this user
        if (!existingCategory.getName().equals(category.getName()) && 
                categoryRepository.existsByNameAndUserId(category.getName(), userId)) {
            throw new IllegalArgumentException("Category with name '" + category.getName() + "' already exists for this user");
        }
        
        existingCategory.setName(category.getName());
        existingCategory.setDescription(category.getDescription());
        existingCategory.setColor(category.getColor());
        
        return categoryRepository.save(existingCategory);
    }
    
    @Override
    public void deleteCategory(Long categoryId, Long userId) {
        Category category = categoryRepository.findByIdAndUserId(categoryId, userId)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + categoryId));
        
        categoryRepository.delete(category);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Optional<Category> getCategoryById(Long categoryId, Long userId) {
        return categoryRepository.findByIdAndUserId(categoryId, userId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<Category> getCategoriesByUserId(Long userId) {
        return categoryRepository.findByUserId(userId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Category> getCategoriesByUserId(Long userId, Pageable pageable) {
        return categoryRepository.findAll(pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public boolean existsByNameAndUserId(String name, Long userId) {
        return categoryRepository.existsByNameAndUserId(name, userId);
    }
} 