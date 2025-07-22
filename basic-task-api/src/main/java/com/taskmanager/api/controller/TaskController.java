package com.taskmanager.api.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    @GetMapping
    public Map<String, Object> getAllTasks() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Task API is working!");
        response.put("status", "success");
        return response;
    }
} 