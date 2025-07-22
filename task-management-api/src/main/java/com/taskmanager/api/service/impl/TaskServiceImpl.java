package com.taskmanager.api.service.impl;

import com.taskmanager.api.entity.Category;
import com.taskmanager.api.entity.Task;
import com.taskmanager.api.entity.TaskPriority;
import com.taskmanager.api.entity.TaskStatus;
import com.taskmanager.api.entity.User;
import com.taskmanager.api.repository.CategoryRepository;
import com.taskmanager.api.repository.TaskRepository;
import com.taskmanager.api.repository.UserRepository;
import com.taskmanager.api.service.TaskService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class TaskServiceImpl implements TaskService {
    
    private final TaskRepository taskRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    
    @Override
    public Task createTask(Task task, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));
        
        task.setUser(user);
        
        // Set category if provided
        if (task.getCategory() != null && task.getCategory().getId() != null) {
            Category category = categoryRepository.findByIdAndUserId(task.getCategory().getId(), userId)
                    .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + task.getCategory().getId()));
            task.setCategory(category);
        }
        
        return taskRepository.save(task);
    }
    
    @Override
    public Task updateTask(Task task, Long userId) {
        Task existingTask = taskRepository.findByIdAndUserId(task.getId(), userId)
                .orElseThrow(() -> new EntityNotFoundException("Task not found with id: " + task.getId()));
        
        existingTask.setTitle(task.getTitle());
        existingTask.setDescription(task.getDescription());
        existingTask.setStatus(task.getStatus());
        existingTask.setPriority(task.getPriority());
        existingTask.setDueDate(task.getDueDate());
        
        // Update category if provided
        if (task.getCategory() != null && task.getCategory().getId() != null) {
            Category category = categoryRepository.findByIdAndUserId(task.getCategory().getId(), userId)
                    .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + task.getCategory().getId()));
            existingTask.setCategory(category);
        } else {
            existingTask.setCategory(null);
        }
        
        return taskRepository.save(existingTask);
    }
    
    @Override
    public void deleteTask(Long taskId, Long userId) {
        Task task = taskRepository.findByIdAndUserId(taskId, userId)
                .orElseThrow(() -> new EntityNotFoundException("Task not found with id: " + taskId));
        
        taskRepository.delete(task);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Optional<Task> getTaskById(Long taskId, Long userId) {
        return taskRepository.findByIdAndUserId(taskId, userId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Task> getTasksByUserId(Long userId, Pageable pageable) {
        return taskRepository.findByUserId(userId, pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Task> getTasksByUserIdAndStatus(Long userId, TaskStatus status, Pageable pageable) {
        return taskRepository.findByUserIdAndStatus(userId, status, pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Task> getTasksByUserIdAndPriority(Long userId, TaskPriority priority, Pageable pageable) {
        return taskRepository.findByUserIdAndPriority(userId, priority, pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Page<Task> getTasksByUserIdAndCategoryId(Long userId, Long categoryId, Pageable pageable) {
        return taskRepository.findByUserIdAndCategoryId(userId, categoryId, pageable);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<Task> getOverdueTasks(Long userId, LocalDateTime currentDate) {
        return taskRepository.findOverdueTasks(userId, currentDate);
    }
    
    @Override
    @Transactional(readOnly = true)
    public long countTasksByUserIdAndStatus(Long userId, TaskStatus status) {
        return taskRepository.countByUserIdAndStatus(userId, status);
    }
    
    @Override
    public Task updateTaskStatus(Long taskId, TaskStatus status, Long userId) {
        Task task = taskRepository.findByIdAndUserId(taskId, userId)
                .orElseThrow(() -> new EntityNotFoundException("Task not found with id: " + taskId));
        
        task.setStatus(status);
        return taskRepository.save(task);
    }
} 