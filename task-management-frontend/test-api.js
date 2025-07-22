// Test script to check if the backend is accessible
const API_URL = 'http://localhost:9000';

async function testApiConnection() {
    console.log('Testing connection to API at:', API_URL);
    
    try {
        // Test root endpoint
        console.log('Testing root endpoint...');
        const rootResponse = await fetch(`${API_URL}/`, {
            method: 'GET',
            mode: 'cors'
        });
        console.log('Root endpoint response status:', rootResponse.status);
        if (rootResponse.ok) {
            const rootData = await rootResponse.json();
            console.log('Root endpoint response:', rootData);
        } else {
            console.error('Root endpoint error:', rootResponse.status);
        }
        
        // Test auth test endpoint
        console.log('Testing auth test endpoint...');
        const authTestResponse = await fetch(`${API_URL}/api/auth/test`, {
            method: 'GET',
            mode: 'cors'
        });
        console.log('Auth test endpoint response status:', authTestResponse.status);
        if (authTestResponse.ok) {
            const authTestData = await authTestResponse.json();
            console.log('Auth test endpoint response:', authTestData);
        } else {
            console.error('Auth test endpoint error:', authTestResponse.status);
        }
        
        // Test direct login test endpoint
        console.log('Testing direct login test endpoint...');
        const directLoginTestResponse = await fetch(`${API_URL}/api/auth/test-direct-login`, {
            method: 'GET',
            mode: 'cors'
        });
        console.log('Direct login test endpoint response status:', directLoginTestResponse.status);
        if (directLoginTestResponse.ok) {
            const directLoginTestData = await directLoginTestResponse.json();
            console.log('Direct login test endpoint response:', directLoginTestData);
        } else {
            console.error('Direct login test endpoint error:', directLoginTestResponse.status);
        }
    } catch (error) {
        console.error('API connection error:', error);
    }
}

// Execute the test
testApiConnection(); 