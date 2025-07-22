package com.taskmanager.api.dto.request;

import com.taskmanager.api.entity.TaskStatus;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskStatusRequest {
    
    @NotNull(message = "Status is required")
    private TaskStatus status;
} 