@echo off
echo Stopping Task Management API servers...
powershell -ExecutionPolicy Bypass -File "%~dp0\stop-servers.ps1"
echo Servers stopped.
pause 