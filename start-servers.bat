@echo off
echo Starting Task Management API servers...
powershell -ExecutionPolicy Bypass -File "%~dp0\start-all.ps1"
pause 