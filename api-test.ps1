# API Test Script
Write-Host "Testing Task Management API Server..."

# Test if the server is running
try {
    $pingResponse = Invoke-WebRequest -Uri "http://localhost:9000/api/test/ping" -Method GET -ErrorAction Stop
    Write-Host "✅ API Server is running and responding to ping"
    Write-Host "   Response: $($pingResponse.Content)"
} catch {
    Write-Host "❌ API Server is not responding to ping"
    Write-Host "   Error: $_"
    Write-Host "   Make sure the server is running with: powershell -ExecutionPolicy Bypass -File .\simple-api-server.ps1"
    exit
}

# Test tasks endpoint
try {
    $tasksResponse = Invoke-WebRequest -Uri "http://localhost:9000/api/tasks" -Method GET -ErrorAction Stop
    $tasks = $tasksResponse.Content | ConvertFrom-Json
    
    Write-Host "`n✅ Tasks endpoint is working"
    
    # Check if tasks is an array
    if ($tasks -is [array]) {
        Write-Host "   Tasks is properly returned as an array with $($tasks.Count) items"
    } else {
        Write-Host "❌ Tasks is not returned as an array - this will cause the 'forEach is not a function' error"
        Write-Host "   Actual type: $($tasks.GetType().FullName)"
    }
    
    # Display tasks
    if ($tasks.Count -gt 0) {
        Write-Host "`nTasks:"
        $tasks | ForEach-Object {
            Write-Host "   - $($_.title) (Status: $($_.status), Priority: $($_.priority))"
        }
    } else {
        Write-Host "   No tasks found. Try creating one first."
    }
} catch {
    Write-Host "❌ Tasks endpoint is not working"
    Write-Host "   Error: $_"
}

# Test categories endpoint
try {
    $categoriesResponse = Invoke-WebRequest -Uri "http://localhost:9000/api/categories" -Method GET -ErrorAction Stop
    $categories = $categoriesResponse.Content | ConvertFrom-Json
    
    Write-Host "`n✅ Categories endpoint is working"
    
    # Check if categories is an array
    if ($categories -is [array]) {
        Write-Host "   Categories is properly returned as an array with $($categories.Count) items"
    } else {
        Write-Host "❌ Categories is not returned as an array - this will cause the 'forEach is not a function' error"
        Write-Host "   Actual type: $($categories.GetType().FullName)"
    }
    
    # Display categories
    if ($categories.Count -gt 0) {
        Write-Host "`nCategories:"
        $categories | ForEach-Object {
            Write-Host "   - $($_.name) ($($_.description))"
        }
    } else {
        Write-Host "   No categories found. Try creating one first."
    }
} catch {
    Write-Host "❌ Categories endpoint is not working"
    Write-Host "   Error: $_"
}

Write-Host "`nTest complete. Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 