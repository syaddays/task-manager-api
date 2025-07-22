# Task Management API

A comprehensive Task Management REST API built with Java and Spring Boot.

## Features

- User authentication with JWT
- Task management (create, read, update, delete)
- Category management
- Task filtering and pagination
- Role-based access control
- API documentation with Swagger/OpenAPI

## Tech Stack

- Java 17
- Spring Boot 3.2+
- Spring Security 6+ with JWT authentication
- Spring Data JPA
- H2 in-memory database
- Maven for dependency management
- Spring Boot Actuator
- Springdoc OpenAPI 3

## Getting Started

### Prerequisites

- Java 17 or later
- Maven

### Running the Application

1. Clone the repository
2. Navigate to the project directory
3. Build the project:
   ```
   mvn clean install
   ```
4. Run the application:
   ```
   mvn spring-boot:run
   ```
5. The API will be available at `http://localhost:8080`
6. Access the API documentation at `http://localhost:8080/swagger-ui.html`
7. Access the H2 console at `http://localhost:8080/h2-console` (JDBC URL: `jdbc:h2:mem:taskdb`, Username: `sa`, Password: `password`)

## API Endpoints

### Authentication Endpoints

- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User authentication (returns JWT)
- `POST /api/auth/refresh` - Refresh JWT token

### Task Management Endpoints

- `GET /api/tasks` - Get all tasks for authenticated user (with pagination and filtering)
- `GET /api/tasks/{id}` - Get specific task by ID
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/{id}` - Update existing task
- `DELETE /api/tasks/{id}` - Delete task
- `PATCH /api/tasks/{id}/status` - Update task status only

### Category Management Endpoints

- `GET /api/categories` - Get all categories for user
- `POST /api/categories` - Create new category
- `PUT /api/categories/{id}` - Update category
- `DELETE /api/categories/{id}` - Delete category

## Security

- JWT-based authentication with configurable expiration
- Password encryption using BCrypt
- Role-based access control (USER, ADMIN roles)
- CORS configuration for frontend integration
- Input validation and sanitization
- Rate limiting for authentication endpoints
- Secure headers configuration 