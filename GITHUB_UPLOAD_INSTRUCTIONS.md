# GitHub Upload Instructions

Follow these step-by-step instructions to upload your Task Management API project to your GitHub repository.

## Prerequisites

1. Install Git if you haven't already: https://git-scm.com/downloads
2. Create a GitHub account if you don't have one: https://github.com/join

## Steps to Upload Your Project

### 1. Create Screenshots Directory

1. Create a new folder named `screenshots` in your project directory
2. Save the dashboard screenshot you provided as `dashboard.png` in this directory
3. Take another screenshot of the task creation page and save it as `create-task.png` in the same directory

### 2. Initialize Git Repository

Open a command prompt or PowerShell window in your project directory and run:

```
git init
```

### 3. Add a .gitignore File

Create a file named `.gitignore` in your project root with the following content:

```
# Compiled class files
*.class

# Log files
*.log

# Package files
*.jar
*.war
*.ear

# Maven target directory
target/

# IDE files
.idea/
*.iml
.vscode/
.project
.classpath
.settings/

# OS files
.DS_Store
Thumbs.db
```

### 4. Stage Your Files

Run the following commands to stage your files:

```
git add .gitignore
git add README.md
git add simple-api-server.ps1
git add task-management-frontend/
git add start-servers.bat
git add stop-servers.bat
git add kill-servers.bat
git add screenshots/
```

### 5. Create Initial Commit

```
git commit -m "Initial commit: Task Management API project"
```

### 6. Connect to Your GitHub Repository

```
git remote add origin https://github.com/syaddays/task-manager-api.git
```

### 7. Push to GitHub

```
git push -u origin main
```

If you're using an older version of Git that uses `master` as the default branch name:

```
git push -u origin master
```

### 8. Authentication

When prompted, enter your GitHub username and password. If you have two-factor authentication enabled, you'll need to use a personal access token instead of your password.

To create a personal access token:
1. Go to GitHub Settings > Developer settings > Personal access tokens
2. Click "Generate new token"
3. Give it a name, select the "repo" scope
4. Click "Generate token"
5. Use this token as your password when pushing

## Alternative: GitHub Desktop

If you're having trouble with the command line, you can use GitHub Desktop:

1. Download and install GitHub Desktop: https://desktop.github.com/
2. Open GitHub Desktop and log in with your GitHub account
3. Choose "Add an Existing Repository from your Hard Drive"
4. Navigate to your project folder
5. Follow the prompts to commit and push your code

## Essential Files to Include

Make sure you include these essential files in your repository:

1. `README.md` - The professional README we created
2. `simple-api-server.ps1` - The API server script
3. `task-management-frontend/` - The frontend code
4. `start-servers.bat` - Script to start both servers
5. `stop-servers.bat` - Script to stop both servers
6. `kill-servers.bat` - Script to forcefully stop servers
7. `screenshots/` - Directory with application screenshots

## After Uploading

After successfully uploading your project:

1. Go to your GitHub repository in a web browser
2. Verify that all files are present
3. Check that the README is displayed correctly with proper formatting
4. Ensure the screenshots are visible in the README

If you need to make any changes, simply commit and push again:

```
git add .
git commit -m "Update README and fix issues"
git push
``` 