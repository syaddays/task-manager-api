@echo off
echo Stopping servers...

REM Find and kill processes using port 3000
echo Stopping processes on port 3000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":3000"') do (
    echo Found process: %%a
    taskkill /F /PID %%a 2>nul
    if not errorlevel 1 (
        echo Successfully terminated process %%a
    ) else (
        echo Failed to terminate process %%a - might be a system process or already stopped
    )
)

REM Find and kill processes using port 9000
echo Stopping processes on port 9000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":9000"') do (
    echo Found process: %%a
    taskkill /F /PID %%a 2>nul
    if not errorlevel 1 (
        echo Successfully terminated process %%a
    ) else (
        echo Failed to terminate process %%a - might be a system process or already stopped
    )
)

echo All servers stopped. You can now start them again.
pause 