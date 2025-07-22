@echo off
echo Task Management API - GitHub Push Script
echo ======================================
echo.

REM Create screenshots directory if it doesn't exist
if not exist "screenshots" mkdir screenshots
echo Created screenshots directory.
echo Please copy your dashboard screenshot to screenshots\dashboard.png
echo Please copy your task creation screenshot to screenshots\create-task.png
echo.
pause

REM Initialize Git repository
echo Initializing Git repository...
git init
if %ERRORLEVEL% NEQ 0 goto error

REM Configure Git user
echo Configuring Git user...
git config user.email "syadabduldg@gmail.com"
git config user.name "syaddays"
if %ERRORLEVEL% NEQ 0 goto error

REM Add all files to Git
echo Adding files to Git...
git add .
if %ERRORLEVEL% NEQ 0 goto error

REM Commit changes
echo Committing changes...
git commit -m "Initial commit: Task Management API project"
if %ERRORLEVEL% NEQ 0 goto error

REM Add remote repository
echo Adding remote repository...
git remote add origin https://github.com/syaddays/task-manager-api.git
if %ERRORLEVEL% NEQ 0 goto error

REM Push to GitHub
echo Pushing to GitHub...
git push -u origin main
if %ERRORLEVEL% NEQ 0 (
  echo Trying with master branch instead...
  git push -u origin master
  if %ERRORLEVEL% NEQ 0 goto error
)

echo.
echo Success! Your Task Management API project has been pushed to GitHub.
echo Visit https://github.com/syaddays/task-manager-api to see your repository.
goto end

:error
echo.
echo An error occurred during the GitHub push process.
echo Please check the error message above and try again.

:end
pause 