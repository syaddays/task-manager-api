package com.taskmanager.api.controller;

import com.taskmanager.api.dto.request.TaskRequest;
import com.taskmanager.api.dto.request.TaskStatusRequest;
import com.taskmanager.api.dto.response.MessageResponse;
import com.taskmanager.api.dto.response.TaskResponse;
import com.taskmanager.api.entity.TaskStatus;
import com.taskmanager.api.service.TaskService;
import com.taskmanager.api.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;

@RestController
@RequestMapping("/api/tasks")
@RequiredArgsConstructor
@Tag(name = "Tasks", description = "Task Management API")
public class TaskController {

    private final TaskService taskService;
    private final UserService userService;

    @GetMapping
    @Operation(summary = "Get all tasks for current user with pagination and filtering")
    public ResponseEntity<Page<TaskResponse>> getAllTasks(
            @RequestParam(required = false) TaskStatus status,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String search,
            @PageableDefault(size = 10) Pageable pageable) {
        
        Long userId = userService.getCurrentUserId();
        Page<TaskResponse> tasks;
        
        if (status != null) {
            tasks = taskService.getTasksByStatus(userId, status, pageable);
        } else if (categoryId != null) {
            tasks = taskService.getTasksByCategory(userId, categoryId, pageable);
        } else if (search != null && !search.trim().isEmpty()) {
            tasks = taskService.searchTasks(userId, search, pageable);
        } else {
            tasks = taskService.getAllTasks(userId, pageable);
        }
        
        return ResponseEntity.ok(tasks);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get task by ID")
    public ResponseEntity<TaskResponse> getTaskById(
            @Parameter(description = "Task ID") @PathVariable Long id) {
        return ResponseEntity.ok(taskService.getTaskById(id, userService.getCurrentUserId()));
    }

    @PostMapping
    @Operation(summary = "Create a new task")
    public ResponseEntity<TaskResponse> createTask(@Valid @RequestBody TaskRequest taskRequest) {
        TaskResponse createdTask = taskService.createTask(taskRequest, userService.getCurrentUserId());
        
        URI location = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(createdTask.getId())
                .toUri();
        
        return ResponseEntity.created(location).body(createdTask);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update an existing task")
    public ResponseEntity<TaskResponse> updateTask(
            @Parameter(description = "Task ID") @PathVariable Long id,
            @Valid @RequestBody TaskRequest taskRequest) {
        return ResponseEntity.ok(taskService.updateTask(id, taskRequest, userService.getCurrentUserId()));
    }

    @PatchMapping("/{id}/status")
    @Operation(summary = "Update task status only")
    public ResponseEntity<TaskResponse> updateTaskStatus(
            @Parameter(description = "Task ID") @PathVariable Long id,
            @Valid @RequestBody TaskStatusRequest statusRequest) {
        return ResponseEntity.ok(taskService.updateTaskStatus(id, statusRequest, userService.getCurrentUserId()));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a task")
    public ResponseEntity<MessageResponse> deleteTask(
            @Parameter(description = "Task ID") @PathVariable Long id) {
        taskService.deleteTask(id, userService.getCurrentUserId());
        return ResponseEntity.ok(new MessageResponse("Task deleted successfully"));
    }
} 