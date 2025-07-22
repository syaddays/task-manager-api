package com.taskmanager.api.repository;

import com.taskmanager.api.entity.Task;
import com.taskmanager.api.entity.TaskPriority;
import com.taskmanager.api.entity.TaskStatus;
import com.taskmanager.api.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    
    List<Task> findByUser(User user);
    
    List<Task> findByUserId(Long userId);
    
    Optional<Task> findByIdAndUserId(Long id, Long userId);
    
    Page<Task> findByUserId(Long userId, Pageable pageable);
    
    Page<Task> findByUserIdAndStatus(Long userId, TaskStatus status, Pageable pageable);
    
    Page<Task> findByUserIdAndPriority(Long userId, TaskPriority priority, Pageable pageable);
    
    Page<Task> findByUserIdAndCategoryId(Long userId, Long categoryId, Pageable pageable);
    
    @Query("SELECT t FROM Task t WHERE t.user.id = ?1 AND t.dueDate < ?2 AND t.status != 'COMPLETED'")
    List<Task> findOverdueTasks(Long userId, LocalDateTime currentDate);
    
    @Query("SELECT COUNT(t) FROM Task t WHERE t.user.id = ?1 AND t.status = ?2")
    long countByUserIdAndStatus(Long userId, TaskStatus status);
} 