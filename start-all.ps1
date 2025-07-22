# Script to start both API server and frontend server in separate windows

# First, stop any existing servers
Write-Host "Stopping any existing servers..."
& "$PSScriptRoot\stop-servers.ps1"

# Start the API server in a new window
Write-Host "Starting API server on port 9000..."
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command `"& '$PSScriptRoot\simple-api-server.ps1'`""

# Wait a moment to ensure the API server starts first
Start-Sleep -Seconds 2

# Start the frontend server in a new window
Write-Host "Starting frontend server on port 3000..."
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command `"& '$PSScriptRoot\task-management-frontend\start-server.ps1'`""

# Open the browser to the frontend
Write-Host "Opening browser to http://localhost:3000/"
Start-Process "http://localhost:3000/"

Write-Host "Servers started successfully. Check the new PowerShell windows for server logs."
Write-Host "Press Ctrl+C in those windows to stop the servers when done." 