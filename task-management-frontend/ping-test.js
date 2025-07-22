// Simple ping test script
const API_URL = 'http://localhost:9000';

async function pingTest() {
    const resultDiv = document.getElementById('result');
    resultDiv.innerHTML = 'Testing connection to API...';
    
    try {
        console.log('Pinging API at:', `${API_URL}/api/test/ping`);
        const response = await fetch(`${API_URL}/api/test/ping`, {
            method: 'GET',
            mode: 'cors'
        });
        
        console.log('Ping response status:', response.status);
        
        if (response.ok) {
            const data = await response.json();
            console.log('Ping response data:', data);
            resultDiv.innerHTML = `
                <div style="color: green;">
                    <h3>✅ Connection successful!</h3>
                    <p>Status: ${data.status}</p>
                    <p>Message: ${data.message}</p>
                    <p>Timestamp: ${new Date(data.timestamp).toLocaleString()}</p>
                </div>
            `;
        } else {
            console.error('Ping failed with status:', response.status);
            const errorText = await response.text();
            console.error('Error text:', errorText);
            resultDiv.innerHTML = `
                <div style="color: red;">
                    <h3>❌ Connection failed!</h3>
                    <p>Status: ${response.status}</p>
                    <p>Error: ${errorText}</p>
                </div>
            `;
        }
    } catch (error) {
        console.error('Ping error:', error);
        resultDiv.innerHTML = `
            <div style="color: red;">
                <h3>❌ Connection error!</h3>
                <p>Error: ${error.message}</p>
                <p>This usually indicates that the server is not running or there is a network issue.</p>
            </div>
        `;
    }
}

// Execute the test when the page loads
window.onload = pingTest; 