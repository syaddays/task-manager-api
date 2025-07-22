# Task Management API - Test Plan

## Introduction
This test plan outlines the testing approach for the Task Management API project. It includes test scenarios, test cases, and expected results for each component of the application.

## Test Environment Setup
1. **Backend Server Setup**:
   - Start the PowerShell API server: `powershell -ExecutionPolicy Bypass -File .\simple-api-server.ps1`
   - Verify server is running on port 9000

2. **Frontend Server Setup**:
   - Start the frontend server: `cd task-management-frontend; powershell -ExecutionPolicy Bypass -File .\start-server.ps1`
   - Verify server is running on port 3000

3. **Browser Setup**:
   - Open a web browser
   - Navigate to http://localhost:3000/

## Test Scenarios

### 1. Authentication Tests

#### 1.1 User Login
- **Test Case**: Login with valid credentials
  - Navigate to http://localhost:3000/
  - Enter username: "testuser"
  - Enter password: "password123"
  - Click "Login" button
  - **Expected Result**: User is logged in successfully, JWT token is stored, dashboard is displayed

#### 1.2 Direct Login Test
- **Test Case**: Test direct login endpoint
  - Navigate to http://localhost:3000/test-direct-login.html
  - Observe the automatic login attempt
  - **Expected Result**: Login successful message displayed, token information shown

### 2. API Connectivity Tests

#### 2.1 Ping Test
- **Test Case**: Test API connectivity
  - Navigate to http://localhost:3000/ping-test.html
  - **Expected Result**: "Connection successful!" message displayed with server information

### 3. Task Management Tests

#### 3.1 Task Creation
- **Test Case**: Create a new task
  - Navigate to http://localhost:3000/task-test.html
  - Fill in task details:
    - Title: "Test Task"
    - Description: "This is a test task"
    - Status: "PENDING"
    - Priority: "MEDIUM"
    - Due Date: Select a future date
  - Click "Create Task" button
  - **Expected Result**: Task created successfully message displayed with task details

#### 3.2 Task Listing
- **Test Case**: View all tasks
  - Navigate to http://localhost:3000/task-list.html
  - **Expected Result**: List of tasks displayed, including the newly created task

#### 3.3 Task Filtering
- **Test Case**: Filter tasks by status
  - Navigate to main application page after login
  - Select a status filter (e.g., "PENDING")
  - **Expected Result**: Only tasks with the selected status are displayed

- **Test Case**: Filter tasks by priority
  - Navigate to main application page after login
  - Select a priority filter (e.g., "MEDIUM")
  - **Expected Result**: Only tasks with the selected priority are displayed

### 4. Category Management Tests

#### 4.1 Category Listing
- **Test Case**: View all categories
  - Navigate to main application page after login
  - Observe the categories list in the sidebar
  - **Expected Result**: List of categories displayed (may be empty initially)

#### 4.2 Category Creation
- **Test Case**: Create a new category
  - Navigate to main application page after login
  - Click "Add Category" button
  - Enter category details:
    - Name: "Test Category"
    - Description: "This is a test category"
    - Color: Select a color
  - Click "Create" button
  - **Expected Result**: New category appears in the categories list

### 5. Error Handling Tests

#### 5.1 Invalid Login
- **Test Case**: Login with invalid credentials
  - Navigate to http://localhost:3000/
  - Enter username: "invaliduser"
  - Enter password: "invalidpassword"
  - Click "Login" button
  - **Expected Result**: Error message displayed indicating invalid credentials

#### 5.2 Missing Required Fields
- **Test Case**: Create task with missing required fields
  - Navigate to http://localhost:3000/task-test.html
  - Leave the title field empty
  - Click "Create Task" button
  - **Expected Result**: Validation error message displayed

### 6. CORS Tests

#### 6.1 Cross-Origin Requests
- **Test Case**: Make cross-origin requests from frontend to backend
  - Navigate to any test page
  - Open browser developer tools
  - Check network tab for API requests
  - **Expected Result**: No CORS errors in the console, requests complete successfully

## Regression Testing
After any changes to the codebase, the following should be retested:
1. Authentication flow
2. Task creation and listing
3. Category creation and listing
4. API connectivity

## Performance Testing
- Load the task list with 50+ tasks and measure load time
- Measure response time for task creation
- Measure login response time

## Security Testing
- Test for proper JWT token validation
- Test for proper authorization checks
- Test for SQL injection vulnerabilities in search fields

## Compatibility Testing
- Test in Chrome, Firefox, and Edge browsers
- Test on different screen sizes (desktop, tablet, mobile)

## Documentation
Document any issues found during testing with:
- Steps to reproduce
- Expected vs actual results
- Screenshots or console logs
- Severity level

## Exit Criteria
Testing is considered complete when:
1. All high-priority test cases pass
2. No critical or high-severity defects remain
3. All functionality works as expected in the supported browsers 