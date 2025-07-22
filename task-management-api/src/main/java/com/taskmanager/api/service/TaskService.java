package com.taskmanager.api.service;

import com.taskmanager.api.entity.Task;
import com.taskmanager.api.entity.TaskPriority;
import com.taskmanager.api.entity.TaskStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface TaskService {
    
    Task createTask(Task task, Long userId);
    
    Task updateTask(Task task, Long userId);
    
    void deleteTask(Long taskId, Long userId);
    
    Optional<Task> getTaskById(Long taskId, Long userId);
    
    Page<Task> getTasksByUserId(Long userId, Pageable pageable);
    
    Page<Task> getTasksByUserIdAndStatus(Long userId, TaskStatus status, Pageable pageable);
    
    Page<Task> getTasksByUserIdAndPriority(Long userId, TaskPriority priority, Pageable pageable);
    
    Page<Task> getTasksByUserIdAndCategoryId(Long userId, Long categoryId, Pageable pageable);
    
    List<Task> getOverdueTasks(Long userId, LocalDateTime currentDate);
    
    long countTasksByUserIdAndStatus(Long userId, TaskStatus status);
    
    Task updateTaskStatus(Long taskId, TaskStatus status, Long userId);
} 