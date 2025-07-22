// API Base URL
const API_URL = 'http://localhost:9000';

// DOM Elements
const loginForm = document.getElementById('login');
const registerForm = document.getElementById('register');
const showLoginBtn = document.getElementById('show-login');
const showRegisterBtn = document.getElementById('show-register');
const loginFormContainer = document.getElementById('login-form');
const registerFormContainer = document.getElementById('register-form');
const loginRegisterContainer = document.getElementById('login-register-container');
const userInfoContainer = document.getElementById('user-info-container');
const usernameDisplay = document.getElementById('username-display');
const logoutBtn = document.getElementById('logout-btn');
const dashboard = document.getElementById('dashboard');
const categoriesList = document.getElementById('categories-list');
const tasksList = document.getElementById('tasks-list');
const addCategoryBtn = document.getElementById('add-category-btn');
const addTaskBtn = document.getElementById('add-task-btn');
const statusFilter = document.getElementById('status-filter');
const priorityFilter = document.getElementById('priority-filter');
const modal = document.getElementById('modal');
const modalContent = document.getElementById('modal-content-container');
const closeModal = document.querySelector('.close');

// State
let currentUser = null;
let authToken = null;
let refreshToken = null;
let categories = [];
let tasks = [];
let currentCategoryId = null;
let currentStatusFilter = 'ALL';
let currentPriorityFilter = 'ALL';

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    // Check if user is logged in (token in localStorage)
    const storedToken = localStorage.getItem('authToken');
    const storedUser = localStorage.getItem('user');
    
    if (storedToken && storedUser) {
        authToken = storedToken;
        refreshToken = localStorage.getItem('refreshToken');
        currentUser = JSON.parse(storedUser);
        showDashboard();
    }
});

showLoginBtn.addEventListener('click', () => {
    loginFormContainer.style.display = 'block';
    registerFormContainer.style.display = 'none';
});

showRegisterBtn.addEventListener('click', () => {
    registerFormContainer.style.display = 'block';
    loginFormContainer.style.display = 'none';
});

loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = document.getElementById('login-username').value;
    const password = document.getElementById('login-password').value;
    
    try {
        console.log('Attempting login with:', { username, password });
        
        const response = await fetch(`${API_URL}/api/auth/direct-login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ username, password }),
            credentials: 'omit',
            mode: 'cors'
        });
        
        console.log('Login response status:', response.status);
        
        if (!response.ok) {
            const errorText = await response.text();
            console.error('Login error:', errorText);
            throw new Error(`Login failed: ${response.status} ${errorText}`);
        }
        
        const data = await response.json();
        console.log('Login successful, received data:', data);
        
        authToken = data.token;
        refreshToken = data.refreshToken;
        currentUser = {
            id: data.id,
            username: data.username,
            email: data.email
        };
        
        // Store in localStorage
        localStorage.setItem('authToken', authToken);
        localStorage.setItem('refreshToken', refreshToken);
        localStorage.setItem('user', JSON.stringify(currentUser));
        
        showDashboard();
    } catch (error) {
        console.error('Login error:', error);
        alert('Login failed: ' + error.message);
    }
});

registerForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = document.getElementById('register-username').value;
    const email = document.getElementById('register-email').value;
    const password = document.getElementById('register-password').value;
    const firstName = document.getElementById('register-firstname').value;
    const lastName = document.getElementById('register-lastname').value;
    
    try {
        const response = await fetch(`${API_URL}/api/auth/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                username,
                email,
                password,
                firstName,
                lastName
            })
        });
        
        if (!response.ok) {
            throw new Error('Registration failed');
        }
        
        const data = await response.json();
        alert(data.message);
        
        // Show login form after successful registration
        loginFormContainer.style.display = 'block';
        registerFormContainer.style.display = 'none';
    } catch (error) {
        alert('Registration failed: ' + error.message);
    }
});

logoutBtn.addEventListener('click', () => {
    // Clear state and localStorage
    authToken = null;
    refreshToken = null;
    currentUser = null;
    localStorage.removeItem('authToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('user');
    
    // Hide dashboard and show login/register
    dashboard.style.display = 'none';
    loginRegisterContainer.style.display = 'block';
    userInfoContainer.style.display = 'none';
});

addCategoryBtn.addEventListener('click', showAddCategoryModal);
addTaskBtn.addEventListener('click', showAddTaskModal);

statusFilter.addEventListener('change', () => {
    currentStatusFilter = statusFilter.value;
    renderTasks();
});

priorityFilter.addEventListener('change', () => {
    currentPriorityFilter = priorityFilter.value;
    renderTasks();
});

closeModal.addEventListener('click', () => {
    modal.style.display = 'none';
});

window.addEventListener('click', (e) => {
    if (e.target === modal) {
        modal.style.display = 'none';
    }
});

// Functions
function showDashboard() {
    loginFormContainer.style.display = 'none';
    registerFormContainer.style.display = 'none';
    loginRegisterContainer.style.display = 'none';
    userInfoContainer.style.display = 'flex';
    dashboard.style.display = 'flex';
    
    usernameDisplay.textContent = currentUser.username;
    
    // Load categories and tasks
    fetchCategories();
    fetchTasks();
}

async function fetchCategories() {
    try {
        const response = await fetch(`${API_URL}/api/categories`, {
            headers: {
                'Authorization': authToken
            }
        });
        
        if (!response.ok) {
            throw new Error('Failed to fetch categories');
        }
        
        const data = await response.json();
        // Ensure categories is always an array
        categories = Array.isArray(data) ? data : [];
        renderCategories();
    } catch (error) {
        console.error('Error fetching categories:', error);
    }
}

async function fetchTasks() {
    try {
        const url = currentCategoryId 
            ? `${API_URL}/api/tasks?categoryId=${currentCategoryId}` 
            : `${API_URL}/api/tasks`;
        
        const response = await fetch(url, {
            headers: {
                'Authorization': authToken
            }
        });
        
        if (!response.ok) {
            throw new Error('Failed to fetch tasks');
        }
        
        const data = await response.json();
        // Ensure tasks is always an array
        tasks = Array.isArray(data) ? data : [];
        renderTasks();
    } catch (error) {
        console.error('Error fetching tasks:', error);
    }
}

function renderCategories() {
    categoriesList.innerHTML = '';
    
    // Ensure categories is an array
    if (!Array.isArray(categories)) {
        console.error('Categories is not an array:', categories);
        categoriesList.innerHTML = '<li class="error">Error loading categories</li>';
        return;
    }
    
    // Add "All Categories" option
    const allCategoriesItem = document.createElement('li');
    allCategoriesItem.textContent = 'All Categories';
    allCategoriesItem.className = currentCategoryId === null ? 'active' : '';
    allCategoriesItem.addEventListener('click', () => {
        currentCategoryId = null;
        document.querySelectorAll('#categories-list li').forEach(li => li.classList.remove('active'));
        allCategoriesItem.classList.add('active');
        fetchTasks();
    });
    categoriesList.appendChild(allCategoriesItem);
    
    // Add each category
    categories.forEach(category => {
        if (!category) return; // Skip null/undefined categories
        
        const li = document.createElement('li');
        li.textContent = category.name || 'Unnamed Category';
        li.className = currentCategoryId === category.id ? 'active' : '';
        li.style.borderLeft = `4px solid ${category.color || '#3498db'}`;
        li.addEventListener('click', () => {
            currentCategoryId = category.id;
            document.querySelectorAll('#categories-list li').forEach(li => li.classList.remove('active'));
            li.classList.add('active');
            fetchTasks();
        });
        categoriesList.appendChild(li);
    });
}

function renderTasks() {
    tasksList.innerHTML = '';
    
    // Ensure tasks is an array
    if (!Array.isArray(tasks)) {
        console.error('Tasks is not an array:', tasks);
        tasksList.innerHTML = '<p class="no-tasks">Error: Invalid tasks data.</p>';
        return;
    }
    
    // Filter tasks
    const filteredTasks = tasks.filter(task => {
        const statusMatch = currentStatusFilter === 'ALL' || task.status === currentStatusFilter;
        const priorityMatch = currentPriorityFilter === 'ALL' || task.priority === currentPriorityFilter;
        return statusMatch && priorityMatch;
    });
    
    if (filteredTasks.length === 0) {
        tasksList.innerHTML = '<p class="no-tasks">No tasks found.</p>';
        return;
    }
    
    filteredTasks.forEach(task => {
        const taskCard = document.createElement('div');
        taskCard.className = `task-card priority-${task.priority.toLowerCase()}`;
        
        // Safely find category
        let categoryName = 'No Category';
        if (Array.isArray(categories)) {
            const category = categories.find(cat => cat && cat.id === task.categoryId);
            if (category) categoryName = category.name;
        }
        
        taskCard.innerHTML = `
            <h3>${task.title}</h3>
            <p>${task.description || 'No description'}</p>
            <div class="task-meta">
                <span class="task-category">${categoryName}</span>
                <span class="task-status status-${task.status.toLowerCase().replace('_', '-')}">${formatStatus(task.status)}</span>
            </div>
            <div class="task-actions">
                <button class="edit-task" data-id="${task.id}">Edit</button>
                <button class="delete-task" data-id="${task.id}">Delete</button>
            </div>
        `;
        
        // Add event listeners for edit and delete
        taskCard.querySelector('.edit-task').addEventListener('click', () => {
            showEditTaskModal(task);
        });
        
        taskCard.querySelector('.delete-task').addEventListener('click', () => {
            if (confirm('Are you sure you want to delete this task?')) {
                deleteTask(task.id);
            }
        });
        
        tasksList.appendChild(taskCard);
    });
}

function showAddCategoryModal() {
    modalContent.innerHTML = `
        <h2>Add Category</h2>
        <form id="add-category-form">
            <div class="form-group">
                <label for="category-name">Name</label>
                <input type="text" id="category-name" required>
            </div>
            <div class="form-group">
                <label for="category-description">Description</label>
                <input type="text" id="category-description">
            </div>
            <div class="form-group">
                <label for="category-color">Color</label>
                <input type="color" id="category-color" value="#3498db">
            </div>
            <button type="submit">Add Category</button>
        </form>
    `;
    
    document.getElementById('add-category-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const name = document.getElementById('category-name').value;
        const description = document.getElementById('category-description').value;
        const color = document.getElementById('category-color').value;
        
        try {
            const response = await fetch(`${API_URL}/api/categories`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': authToken
                },
                body: JSON.stringify({
                    name,
                    description,
                    color
                })
            });
            
            if (!response.ok) {
                throw new Error('Failed to create category');
            }
            
            modal.style.display = 'none';
            fetchCategories();
        } catch (error) {
            alert('Error creating category: ' + error.message);
        }
    });
    
    modal.style.display = 'block';
}

function showAddTaskModal() {
    // Ensure categories is an array before using map
    const categoriesOptions = Array.isArray(categories) 
        ? categories
            .filter(category => category) // Filter out null/undefined
            .map(category => `<option value="${category.id}">${category.name || 'Unnamed Category'}</option>`)
            .join('') 
        : '';
    
    modalContent.innerHTML = `
        <h2>Add Task</h2>
        <form id="add-task-form">
            <div class="form-group">
                <label for="task-title">Title</label>
                <input type="text" id="task-title" required>
            </div>
            <div class="form-group">
                <label for="task-description">Description</label>
                <textarea id="task-description" rows="3"></textarea>
            </div>
            <div class="form-group">
                <label for="task-category">Category</label>
                <select id="task-category">
                    <option value="">No Category</option>
                    ${categoriesOptions}
                </select>
            </div>
            <div class="form-group">
                <label for="task-priority">Priority</label>
                <select id="task-priority">
                    <option value="LOW">Low</option>
                    <option value="MEDIUM" selected>Medium</option>
                    <option value="HIGH">High</option>
                    <option value="URGENT">Urgent</option>
                </select>
            </div>
            <div class="form-group">
                <label for="task-due-date">Due Date</label>
                <input type="datetime-local" id="task-due-date">
            </div>
            <button type="submit">Add Task</button>
        </form>
    `;
    
    document.getElementById('add-task-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const title = document.getElementById('task-title').value;
        const description = document.getElementById('task-description').value;
        const categoryId = document.getElementById('task-category').value || null;
        const priority = document.getElementById('task-priority').value;
        const dueDate = document.getElementById('task-due-date').value || null;
        
        try {
            const response = await fetch(`${API_URL}/api/tasks`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': authToken
                },
                body: JSON.stringify({
                    title,
                    description,
                    categoryId,
                    priority,
                    dueDate,
                    status: 'PENDING'
                })
            });
            
            if (!response.ok) {
                throw new Error('Failed to create task');
            }
            
            modal.style.display = 'none';
            fetchTasks();
        } catch (error) {
            alert('Error creating task: ' + error.message);
        }
    });
    
    modal.style.display = 'block';
}

function showEditTaskModal(task) {
    let category = null;
    if (Array.isArray(categories)) {
        category = categories.find(cat => cat && cat.id === task.categoryId);
    }
    
    // Ensure categories is an array before using map
    const categoriesOptions = Array.isArray(categories) 
        ? categories
            .filter(category => category) // Filter out null/undefined
            .map(category => `
                <option value="${category.id}" ${task.categoryId === category.id ? 'selected' : ''}>
                    ${category.name || 'Unnamed Category'}
                </option>
            `).join('') 
        : '';
    
    modalContent.innerHTML = `
        <h2>Edit Task</h2>
        <form id="edit-task-form">
            <div class="form-group">
                <label for="edit-task-title">Title</label>
                <input type="text" id="edit-task-title" value="${task.title || ''}" required>
            </div>
            <div class="form-group">
                <label for="edit-task-description">Description</label>
                <textarea id="edit-task-description" rows="3">${task.description || ''}</textarea>
            </div>
            <div class="form-group">
                <label for="edit-task-category">Category</label>
                <select id="edit-task-category">
                    <option value="">No Category</option>
                    ${categoriesOptions}
                </select>
            </div>
            <div class="form-group">
                <label for="edit-task-status">Status</label>
                <select id="edit-task-status">
                    <option value="PENDING" ${task.status === 'PENDING' ? 'selected' : ''}>Pending</option>
                    <option value="IN_PROGRESS" ${task.status === 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                    <option value="COMPLETED" ${task.status === 'COMPLETED' ? 'selected' : ''}>Completed</option>
                    <option value="CANCELLED" ${task.status === 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                </select>
            </div>
            <div class="form-group">
                <label for="edit-task-priority">Priority</label>
                <select id="edit-task-priority">
                    <option value="LOW" ${task.priority === 'LOW' ? 'selected' : ''}>Low</option>
                    <option value="MEDIUM" ${task.priority === 'MEDIUM' ? 'selected' : ''}>Medium</option>
                    <option value="HIGH" ${task.priority === 'HIGH' ? 'selected' : ''}>High</option>
                    <option value="URGENT" ${task.priority === 'URGENT' ? 'selected' : ''}>Urgent</option>
                </select>
            </div>
            <div class="form-group">
                <label for="edit-task-due-date">Due Date</label>
                <input type="datetime-local" id="edit-task-due-date" value="${formatDateForInput(task.dueDate)}">
            </div>
            <button type="submit">Update Task</button>
        </form>
    `;
    
    document.getElementById('edit-task-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const title = document.getElementById('edit-task-title').value;
        const description = document.getElementById('edit-task-description').value;
        const categoryId = document.getElementById('edit-task-category').value || null;
        const status = document.getElementById('edit-task-status').value;
        const priority = document.getElementById('edit-task-priority').value;
        const dueDate = document.getElementById('edit-task-due-date').value || null;
        
        try {
            const response = await fetch(`${API_URL}/api/tasks/${task.id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': authToken
                },
                body: JSON.stringify({
                    title,
                    description,
                    categoryId,
                    status,
                    priority,
                    dueDate
                })
            });
            
            if (!response.ok) {
                throw new Error('Failed to update task');
            }
            
            modal.style.display = 'none';
            fetchTasks();
        } catch (error) {
            alert('Error updating task: ' + error.message);
        }
    });
    
    modal.style.display = 'block';
}

async function deleteTask(taskId) {
    try {
        const response = await fetch(`${API_URL}/api/tasks/${taskId}`, {
            method: 'DELETE',
            headers: {
                'Authorization': authToken
            }
        });
        
        if (!response.ok) {
            throw new Error('Failed to delete task');
        }
        
        fetchTasks();
    } catch (error) {
        alert('Error deleting task: ' + error.message);
    }
}

// Helper Functions
function formatStatus(status) {
    return status.replace('_', ' ').toLowerCase().replace(/\b\w/g, char => char.toUpperCase());
}

function formatDateForInput(dateString) {
    if (!dateString) return '';
    
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    
    return `${year}-${month}-${day}T${hours}:${minutes}`;
} 