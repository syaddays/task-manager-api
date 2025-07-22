-- Insert admin user (password: admin123)
INSERT INTO users (username, email, password, first_name, last_name, created_at, updated_at)
VALUES ('admin', 'admin@example.com', '$2a$10$yfIHMg3NELXjjMO.MUL1UOoRrIJXxqPVKWkS.1xJ5RgYD6FQ.5Bfu', 'Admin', 'User', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Insert regular user (password: user123)
INSERT INTO users (username, email, password, first_name, last_name, created_at, updated_at)
VALUES ('user', 'user@example.com', '$2a$10$MUEJIQGlYCOCUVWxjhvKs.GbJHQGjp0Z.dCFgQzOYxbxEJCVDZJZK', 'Regular', 'User', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Insert user roles
INSERT INTO user_roles (user_id, roles) VALUES (1, 'ROLE_ADMIN');
INSERT INTO user_roles (user_id, roles) VALUES (1, 'ROLE_USER');
INSERT INTO user_roles (user_id, roles) VALUES (2, 'ROLE_USER');

-- Insert categories for user 2
INSERT INTO categories (name, description, color, user_id, created_at)
VALUES ('Work', 'Work related tasks', '#FF5733', 2, CURRENT_TIMESTAMP());

INSERT INTO categories (name, description, color, user_id, created_at)
VALUES ('Personal', 'Personal tasks', '#33A1FF', 2, CURRENT_TIMESTAMP());

INSERT INTO categories (name, description, color, user_id, created_at)
VALUES ('Shopping', 'Shopping list', '#33FF57', 2, CURRENT_TIMESTAMP());

-- Insert tasks for user 2
INSERT INTO tasks (title, description, status, priority, due_date, user_id, category_id, created_at, updated_at)
VALUES ('Complete project report', 'Finish the quarterly project report', 'PENDING', 'HIGH', DATEADD('DAY', 7, CURRENT_DATE()), 2, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

INSERT INTO tasks (title, description, status, priority, due_date, user_id, category_id, created_at, updated_at)
VALUES ('Schedule team meeting', 'Arrange weekly team meeting', 'PENDING', 'MEDIUM', DATEADD('DAY', 2, CURRENT_DATE()), 2, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

INSERT INTO tasks (title, description, status, priority, due_date, user_id, category_id, created_at, updated_at)
VALUES ('Gym workout', 'Go to the gym for workout', 'PENDING', 'MEDIUM', DATEADD('DAY', 1, CURRENT_DATE()), 2, 2, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

INSERT INTO tasks (title, description, status, priority, due_date, user_id, category_id, created_at, updated_at)
VALUES ('Buy groceries', 'Buy groceries for the week', 'PENDING', 'LOW', DATEADD('DAY', 3, CURRENT_DATE()), 2, 3, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()); 