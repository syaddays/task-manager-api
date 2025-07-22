-- Insert default roles
INSERT INTO roles (name, description) VALUES 
('ROLE_USER', 'Standard user role'),
('ROLE_ADMIN', 'Administrator role with all privileges');

-- Insert test users (password: 'password123' - bcrypt encoded)
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