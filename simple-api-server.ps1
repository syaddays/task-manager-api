# Simple API server for testing using PowerShell
$port = 9000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")

# In-memory storage for tasks and categories
$tasks = @()
$categories = @()
$users = @()
$taskIdCounter = 1
$categoryIdCounter = 1
$userIdCounter = 1

# Add some default users
$users += @{
    id = $userIdCounter++
    username = "testuser"
    password = "password123"
    email = "testuser@example.com"
    firstName = "Test"
    lastName = "User"
    roles = @("ROLE_USER")
}

$users += @{
    id = $userIdCounter++
    username = "syad"
    password = "Syad12345"
    email = "syad@example.com"
    firstName = "Syad"
    lastName = "User"
    roles = @("ROLE_USER")
}

# Function to get user ID from authorization header or username
function Get-UserId {
    param (
        [System.Net.HttpListenerRequest]$Request,
        [string]$Username = $null
    )
    
    # If username is provided, find the user
    if ($Username) {
        $user = $users | Where-Object { $_.username -eq $Username }
        if ($user) {
            return $user.id
        }
    }
    
    # Default to user ID 1 if no match
    return 1
}

# Check if the port is already in use
try {
    $listener.Start()
    Write-Host "Server is running on http://localhost:$port/"
    Write-Host "Press Ctrl+C to stop the server"
} catch {
    Write-Host "Error starting server: $_"
    Write-Host "The port $port may already be in use. Try stopping any existing servers or using a different port."
    exit 1
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # Set CORS headers
        $response.Headers.Add("Access-Control-Allow-Origin", "*")
        $response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        $response.Headers.Add("Access-Control-Allow-Headers", "Content-Type, Accept, Authorization")
        
        # Handle preflight requests
        if ($request.HttpMethod -eq "OPTIONS") {
            $response.StatusCode = 200
            $response.Close()
            continue
        }
        
        $url = $request.Url.LocalPath
        $method = $request.HttpMethod
        
        Write-Host "$method $url"
        
        # Set content type to JSON
        $response.ContentType = "application/json"
        
        # Root endpoint
        if ($url -eq "/" -and $method -eq "GET") {
            $responseBody = '{"message": "Welcome to Test API"}'
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }
        
        # Test ping endpoint
        if ($url -eq "/api/test/ping" -and $method -eq "GET") {
            $timestamp = Get-Date -UFormat %s
            $responseBody = @{
                status = "success"
                message = "Server is running"
                timestamp = $timestamp
            } | ConvertTo-Json
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }
        
        # Auth test endpoint
        if ($url -eq "/api/auth/test" -and $method -eq "GET") {
            $responseBody = '{"message": "Authentication endpoint is working"}'
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }
        
        # Direct login test endpoint
        if ($url -eq "/api/auth/test-direct-login" -and $method -eq "GET") {
            $responseBody = '{"message": "Direct login endpoint is available"}'
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }
        
        # Direct login endpoint
        if ($url -eq "/api/auth/direct-login" -and $method -eq "POST") {
            # Read request body
            $reader = New-Object System.IO.StreamReader($request.InputStream, $request.ContentEncoding)
            $body = $reader.ReadToEnd()
            $reader.Close()
            
            try {
                $data = $body | ConvertFrom-Json
                Write-Host "Login attempt: $body"
                
                # Simple validation
                if ($data.username -and $data.password) {
                    # Find user in our users array
                    $user = $users | Where-Object { $_.username -eq $data.username }
                    
                    # If user doesn't exist, create one
                    if (-not $user) {
                        $user = @{
                            id = $userIdCounter++
                            username = $data.username
                            password = $data.password
                            email = "$($data.username)@example.com"
                            firstName = "New"
                            lastName = "User"
                            roles = @("ROLE_USER")
                        }
                        $users += $user
                    }
                    
                    $timestamp = Get-Date -UFormat %s
                    $responseBody = @{
                        token = "test-jwt-token-$($user.id)-$timestamp"
                        refreshToken = "test-refresh-token-$($user.id)-$timestamp"
                        id = $user.id
                        username = $user.username
                        email = $user.email
                        roles = $user.roles
                    } | ConvertTo-Json
                    
                    $response.StatusCode = 200
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                } else {
                    $response.StatusCode = 400
                    $responseBody = '{"message": "Username and password are required"}'
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
            } catch {
                Write-Host "Error parsing request body: $_"
                $response.StatusCode = 400
                $responseBody = '{"message": "Invalid request body"}'
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            $response.Close()
            continue
        }
        
        # GET /api/categories endpoint
        if ($url -eq "/api/categories" -and $method -eq "GET") {
            # Extract user ID from Authorization header
            $userId = 0
            $authHeader = $request.Headers["Authorization"]
            
            if ($authHeader -and $authHeader -match "test-jwt-token-(\d+)-") {
                $userId = [int]$matches[1]
            }
            
            # If we have a valid user ID, filter categories by user
            $userCategories = @()
            if ($userId -gt 0) {
                $userCategories = $categories | Where-Object { $_.userId -eq $userId }
            } else {
                # Fallback to all categories if no user ID found
                $userCategories = $categories
            }
            
            if ($userCategories.Count -eq 0) {
                $responseBody = "[]"
            } else {
                # Ensure we're returning a proper JSON array
                $responseBody = "["
                $first = $true
                foreach ($category in $userCategories) {
                    if (-not $first) {
                        $responseBody += ","
                    }
                    $first = $false
                    $responseBody += ($category | ConvertTo-Json -Depth 10)
                }
                $responseBody += "]"
            }
            
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }
        
        # POST /api/categories endpoint
        if ($url -eq "/api/categories" -and $method -eq "POST") {
            # Read request body
            $reader = New-Object System.IO.StreamReader($request.InputStream, $request.ContentEncoding)
            $body = $reader.ReadToEnd()
            $reader.Close()
            
            try {
                $data = $body | ConvertFrom-Json
                
                # Extract user ID from Authorization header
                $userId = 0
                $authHeader = $request.Headers["Authorization"]
                
                if ($authHeader -and $authHeader -match "test-jwt-token-(\d+)-") {
                    $userId = [int]$matches[1]
                } else {
                    $userId = 1 # Default to first user if no auth header
                }
                
                # Create new category
                $category = @{
                    id = $categoryIdCounter
                    name = $data.name
                    description = $data.description
                    color = $data.color
                    userId = $userId
                    createdAt = Get-Date
                }
                
                $categories += $category
                $categoryIdCounter++
                
                $response.StatusCode = 201
                $responseBody = $category | ConvertTo-Json
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            } catch {
                $response.StatusCode = 400
                $responseBody = '{"message": "Invalid category data"}'
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            $response.Close()
            continue
        }
        
        # GET /api/tasks endpoint
        if ($url -eq "/api/tasks" -and $method -eq "GET") {
            # Extract user ID from Authorization header
            $userId = 0
            $authHeader = $request.Headers["Authorization"]
            
            if ($authHeader -and $authHeader -match "test-jwt-token-(\d+)-") {
                $userId = [int]$matches[1]
            }
            
            # If we have a valid user ID, filter tasks by user
            $userTasks = @()
            if ($userId -gt 0) {
                $userTasks = $tasks | Where-Object { $_.userId -eq $userId }
            } else {
                # Fallback to all tasks if no user ID found
                $userTasks = $tasks
            }
            
            if ($userTasks.Count -eq 0) {
                $responseBody = "[]"
            } else {
                # Ensure we're returning a proper JSON array
                $responseBody = "["
                $first = $true
                foreach ($task in $userTasks) {
                    if (-not $first) {
                        $responseBody += ","
                    }
                    $first = $false
                    $responseBody += ($task | ConvertTo-Json -Depth 10)
                }
                $responseBody += "]"
            }
            
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.Close()
            continue
        }
        
        # POST /api/tasks endpoint
        if ($url -eq "/api/tasks" -and $method -eq "POST") {
            # Read request body
            $reader = New-Object System.IO.StreamReader($request.InputStream, $request.ContentEncoding)
            $body = $reader.ReadToEnd()
            $reader.Close()
            
            try {
                $data = $body | ConvertFrom-Json
                Write-Host "Creating task: $body"
                
                # Extract user ID from Authorization header
                $userId = 0
                $authHeader = $request.Headers["Authorization"]
                
                if ($authHeader -and $authHeader -match "test-jwt-token-(\d+)-") {
                    $userId = [int]$matches[1]
                } else {
                    $userId = 1 # Default to first user if no auth header
                }
                
                # Create new task
                $task = @{
                    id = $taskIdCounter
                    title = $data.title
                    description = $data.description
                    status = if ($data.status) { $data.status } else { "PENDING" }
                    priority = if ($data.priority) { $data.priority } else { "MEDIUM" }
                    dueDate = $data.dueDate
                    categoryId = $data.categoryId
                    userId = $userId
                    createdAt = Get-Date
                    updatedAt = Get-Date
                }
                
                $tasks += $task
                $taskIdCounter++
                
                $response.StatusCode = 201
                $responseBody = $task | ConvertTo-Json
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            } catch {
                Write-Host "Error creating task: $_"
                $response.StatusCode = 400
                $responseBody = '{"message": "Invalid task data"}'
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            $response.Close()
            continue
        }
        
        # GET /api/tasks/{id} endpoint
        if ($url -match "^/api/tasks/(\d+)$" -and $method -eq "GET") {
            $taskId = [int]$matches[1]
            $task = $tasks | Where-Object { $_.id -eq $taskId }
            
            if ($task) {
                $responseBody = $task | ConvertTo-Json
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            } else {
                $response.StatusCode = 404
                $responseBody = '{"message": "Task not found"}'
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            $response.Close()
            continue
        }
        
        # PUT /api/tasks/{id} endpoint
        if ($url -match "^/api/tasks/(\d+)$" -and $method -eq "PUT") {
            $taskId = [int]$matches[1]
            $taskIndex = 0
            $taskFound = $false
            
            foreach ($t in $tasks) {
                if ($t.id -eq $taskId) {
                    $taskFound = $true
                    break
                }
                $taskIndex++
            }
            
            if ($taskFound) {
                # Read request body
                $reader = New-Object System.IO.StreamReader($request.InputStream, $request.ContentEncoding)
                $body = $reader.ReadToEnd()
                $reader.Close()
                
                try {
                    $data = $body | ConvertFrom-Json
                    
                    # Update task
                    if ($data.title) { $tasks[$taskIndex].title = $data.title }
                    if ($data.description) { $tasks[$taskIndex].description = $data.description }
                    if ($data.status) { $tasks[$taskIndex].status = $data.status }
                    if ($data.priority) { $tasks[$taskIndex].priority = $data.priority }
                    if ($data.dueDate) { $tasks[$taskIndex].dueDate = $data.dueDate }
                    if ($data.categoryId) { $tasks[$taskIndex].categoryId = $data.categoryId }
                    $tasks[$taskIndex].updatedAt = Get-Date
                    
                    $responseBody = $tasks[$taskIndex] | ConvertTo-Json
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                } catch {
                    $response.StatusCode = 400
                    $responseBody = '{"message": "Invalid task data"}'
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
            } else {
                $response.StatusCode = 404
                $responseBody = '{"message": "Task not found"}'
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            $response.Close()
            continue
        }
        
        # DELETE /api/tasks/{id} endpoint
        if ($url -match "^/api/tasks/(\d+)$" -and $method -eq "DELETE") {
            $taskId = [int]$matches[1]
            $taskIndex = 0
            $taskFound = $false
            
            foreach ($t in $tasks) {
                if ($t.id -eq $taskId) {
                    $taskFound = $true
                    break
                }
                $taskIndex++
            }
            
            if ($taskFound) {
                $tasks = $tasks[0..($taskIndex-1)] + $tasks[($taskIndex+1)..($tasks.Length-1)]
                
                $response.StatusCode = 200
                $responseBody = '{"message": "Task deleted successfully"}'
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            } else {
                $response.StatusCode = 404
                $responseBody = '{"message": "Task not found"}'
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            $response.Close()
            continue
        }

        # Not found
        $response.StatusCode = 404
        $responseBody = '{"message": "Endpoint not found"}'
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseBody)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.Close()
    }
} finally {
    try {
        if ($listener -ne $null -and $listener.IsListening) {
            $listener.Stop()
        }
    } catch {
        Write-Host "Error stopping server: $_"
    }
} 