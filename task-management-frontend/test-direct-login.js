// Test script for direct login
const API_URL = 'http://localhost:9000';

// Add a delay function to wait between API calls
function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function testDirectLogin() {
    const loginData = {
        username: "testuser",
        password: "password123"
    };
    
    console.log('Testing direct login with:', loginData);
    console.log('API URL:', API_URL);
    
    // First check if the API is accessible
    try {
        console.log('Checking API root endpoint...');
        try {
            const rootResponse = await fetch(`${API_URL}/`, {
                method: 'GET',
                mode: 'cors'
            });
            console.log('Root endpoint response status:', rootResponse.status);
        } catch (error) {
            console.error('Root endpoint error:', error);
        }
        
        await delay(1000);
        
        console.log('Checking API auth test endpoint...');
        try {
            const authTestResponse = await fetch(`${API_URL}/api/auth/test`, {
                method: 'GET',
                mode: 'cors'
            });
            console.log('Auth test endpoint response status:', authTestResponse.status);
        } catch (error) {
            console.error('Auth test endpoint error:', error);
        }
        
        await delay(1000);
        
        console.log('Checking API direct login test endpoint...');
        try {
            const directLoginTestResponse = await fetch(`${API_URL}/api/auth/test-direct-login`, {
                method: 'GET',
                mode: 'cors'
            });
            console.log('Direct login test endpoint response status:', directLoginTestResponse.status);
        } catch (error) {
            console.error('Direct login test endpoint error:', error);
            console.log('Will still attempt direct login...');
        }
        
        await delay(1000);
        
        // Now try the direct login with XMLHttpRequest instead of fetch
        console.log('Sending request to:', `${API_URL}/api/auth/direct-login`);
        const xhr = new XMLHttpRequest();
        xhr.open('POST', `${API_URL}/api/auth/direct-login`, true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.withCredentials = false;
        
        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 300) {
                console.log('Direct login successful!');
                console.log('Response:', xhr.responseText);
                try {
                    const data = JSON.parse(xhr.responseText);
                    console.log('Parsed response:', data);
                    document.getElementById('result').innerHTML = 'Login successful! Token: ' + data.token;
                } catch (e) {
                    console.error('Error parsing response:', e);
                    document.getElementById('result').innerHTML = 'Login successful but error parsing response';
                }
            } else {
                console.error('Direct login failed with status:', xhr.status);
                console.error('Response:', xhr.responseText);
                document.getElementById('result').innerHTML = 'Login failed: ' + xhr.status + ' ' + xhr.responseText;
            }
        };
        
        xhr.onerror = function() {
            console.error('Direct login request failed');
            document.getElementById('result').innerHTML = 'Login failed: Network error';
        };
        
        xhr.send(JSON.stringify(loginData));
        
        // Also try with fetch as a backup
        try {
            console.log('Also trying with fetch API...');
            const response = await fetch(`${API_URL}/api/auth/direct-login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(loginData),
                credentials: 'omit',
                mode: 'cors'
            });
            
            console.log('Fetch response status:', response.status);
            if (response.ok) {
                const data = await response.json();
                console.log('Fetch response data:', data);
            } else {
                console.error('Fetch response error:', response.status);
                const errorText = await response.text();
                console.error('Error text:', errorText);
            }
        } catch (error) {
            console.error('Fetch API error:', error);
        }
    } catch (error) {
        console.error('Direct login error:', error);
        document.getElementById('result').innerHTML = 'Login failed: ' + error.message;
    }
}

// Execute the test
window.onload = testDirectLogin; 