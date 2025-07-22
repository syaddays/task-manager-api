// Test script for authentication
const API_URL = 'http://localhost:9000';

// Register a new user
async function registerUser() {
    const userData = {
        username: "testuser2",
        email: "testuser2@example.com",
        password: "password123",
        firstName: "Test",
        lastName: "User"
    };
    
    try {
        console.log('Attempting to register user:', userData);
        const response = await fetch(`${API_URL}/api/auth/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(userData)
        });
        
        const data = await response.json();
        console.log('Registration response:', data);
        return data;
    } catch (error) {
        console.error('Registration error:', error);
    }
}

// Login with the registered user
async function loginUser() {
    const loginData = {
        username: "testuser2",
        password: "password123"
    };
    
    try {
        console.log('Attempting to login user:', loginData);
        const response = await fetch(`${API_URL}/api/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(loginData)
        });
        
        if (!response.ok) {
            const errorText = await response.text();
            console.error('Login failed:', response.status, errorText);
            return;
        }
        
        const data = await response.json();
        console.log('Login response:', data);
        return data;
    } catch (error) {
        console.error('Login error:', error);
    }
}

// Execute the tests
async function runTests() {
    console.log('Starting authentication tests...');
    
    // First register a user
    const registerResult = await registerUser();
    console.log('Register result:', registerResult);
    
    // Then login with the registered user
    const loginResult = await loginUser();
    console.log('Login result:', loginResult);
    
    console.log('Authentication tests completed.');
}

// Run the tests
runTests(); 