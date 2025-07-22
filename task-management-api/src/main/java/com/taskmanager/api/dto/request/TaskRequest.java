package com.taskmanager.api.dto.request;

import com.taskmanager.api.entity.TaskPriority;
import com.taskmanager.api.entity.TaskStatus;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskRequest {
    
    @NotBlank(message = "Title is required")
    @Size(max = 100, message = "Title must be less than 100 characters")
    private String title;
    
    private String description;
    
    private TaskStatus status = TaskStatus.PENDING;
    
    private TaskPriority priority = TaskPriority.MEDIUM;
    
    private LocalDateTime dueDate;
    
    private Long categoryId;
} 