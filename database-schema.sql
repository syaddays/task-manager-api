-- Task Management API Database Schema

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

-- Create roles table
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create user_roles junction table
CREATE TABLE user_roles (
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Create categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    color VARCHAR(7) DEFAULT '#3498db',
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE (name, user_id)
);

-- Create tasks table
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    due_date TIMESTAMP,
    category_id INTEGER,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT valid_status CHECK (status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT valid_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH'))
);

-- Add indexes for performance
CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_category_id ON tasks(category_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_categories_user_id ON categories(user_id);

-- Insert default roles
INSERT INTO roles (name, description) VALUES 
('ROLE_USER', 'Standard user role'),
('ROLE_ADMIN', 'Administrator role with all privileges');

-- Insert test users (password: 'password123' - in a real app, these would be hashed)
INSERT INTO users (username, email, password, first_name, last_name) VALUES
('testuser', 'test@example.com', '$2a$10$1/dXWUQIENZgXlwNFZ0zPeEjl5DYUxjYIwwX9Uc7.5c4WFxNPQxCa', 'Test', 'User'),
('admin', 'admin@example.com', '$2a$10$1/dXWUQIENZgXlwNFZ0zPeEjl5DYUxjYIwwX9Uc7.5c4WFxNPQxCa', 'Admin', 'User');

-- Assign roles to users
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1), -- testuser has ROLE_USER
(2, 1), -- admin has ROLE_USER
(2, 2); -- admin has ROLE_ADMIN

-- Insert default categories
INSERT INTO categories (name, description, color, user_id) VALUES
('Work', 'Work-related tasks', '#e74c3c', 1),
('Personal', 'Personal tasks', '#2ecc71', 1),
('Shopping', 'Shopping list', '#f39c12', 1),
('Work', 'Work-related tasks', '#3498db', 2),
('Projects', 'Project management', '#9b59b6', 2);

-- Insert sample tasks
INSERT INTO tasks (title, description, status, priority, due_date, category_id, user_id) VALUES
('Complete project proposal', 'Finish the proposal document for client meeting', 'PENDING', 'HIGH', CURRENT_TIMESTAMP + INTERVAL '3 days', 1, 1),
('Buy groceries', 'Milk, eggs, bread, vegetables', 'PENDING', 'MEDIUM', CURRENT_TIMESTAMP + INTERVAL '1 day', 3, 1),
('Schedule dentist appointment', 'Call Dr. Smith for annual checkup', 'PENDING', 'LOW', CURRENT_TIMESTAMP + INTERVAL '7 days', 2, 1),
('Review team performance', 'Quarterly review of team metrics', 'IN_PROGRESS', 'HIGH', CURRENT_TIMESTAMP + INTERVAL '2 days', 4, 2),
('Update documentation', 'Update API documentation with new endpoints', 'PENDING', 'MEDIUM', CURRENT_TIMESTAMP + INTERVAL '5 days', 5, 2);

-- Create a view for task summary by user
CREATE VIEW task_summary_by_user AS
SELECT 
    u.id as user_id,
    u.username,
    COUNT(t.id) as total_tasks,
    SUM(CASE WHEN t.status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_tasks,
    SUM(CASE WHEN t.status = 'PENDING' THEN 1 ELSE 0 END) as pending_tasks,
    SUM(CASE WHEN t.status = 'IN_PROGRESS' THEN 1 ELSE 0 END) as in_progress_tasks,
    SUM(CASE WHEN t.due_date < CURRENT_TIMESTAMP AND t.status != 'COMPLETED' THEN 1 ELSE 0 END) as overdue_tasks
FROM 
    users u
LEFT JOIN 
    tasks t ON u.id = t.user_id
GROUP BY 
    u.id, u.username; 