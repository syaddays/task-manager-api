@echo off
echo Starting Task Management API servers and running tests...

REM First stop any existing servers
echo Stopping any existing servers...
powershell -ExecutionPolicy Bypass -File "%~dp0\stop-servers.ps1"

REM Start the API server in a new window
echo Starting API server on port 9000...
start "API Server" powershell.exe -ExecutionPolicy Bypass -NoExit -Command "& '%~dp0\simple-api-server.ps1'"

REM Wait a moment to ensure the API server starts
timeout /t 3 /nobreak > nul

REM Run the API test
echo Running API test...
powershell -ExecutionPolicy Bypass -File "%~dp0\api-test.ps1"

REM Start the frontend server in a new window
echo Starting frontend server on port 3000...
start "Frontend Server" powershell.exe -ExecutionPolicy Bypass -NoExit -Command "& '%~dp0\task-management-frontend\start-server.ps1'"

REM Open the browser to the frontend
echo Opening browser to http://localhost:3000/
start "" "http://localhost:3000/"

echo Servers started successfully. Check the new PowerShell windows for server logs.
echo Press any key to exit...
pause > nul 