// Simple API server for testing
const http = require('http');

const PORT = 9000;

const server = http.createServer((req, res) => {
    // Set CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Accept, Authorization');
    
    // Handle preflight requests
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }
    
    const url = req.url;
    const method = req.method;
    
    console.log(`${method} ${url}`);
    
    // Root endpoint
    if (url === '/' && method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ message: 'Welcome to Test API' }));
        return;
    }
    
    // Test ping endpoint
    if (url === '/api/test/ping' && method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            status: 'success',
            message: 'Server is running',
            timestamp: Date.now()
        }));
        return;
    }
    
    // Auth test endpoint
    if (url === '/api/auth/test' && method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ message: 'Authentication endpoint is working' }));
        return;
    }
    
    // Direct login test endpoint
    if (url === '/api/auth/test-direct-login' && method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ message: 'Direct login endpoint is available' }));
        return;
    }
    
    // Direct login endpoint
    if (url === '/api/auth/direct-login' && method === 'POST') {
        let body = '';
        
        req.on('data', chunk => {
            body += chunk.toString();
        });
        
        req.on('end', () => {
            try {
                const data = JSON.parse(body);
                console.log('Login attempt:', data);
                
                // Simple validation
                if (data.username && data.password) {
                    res.writeHead(200, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({
                        token: 'test-jwt-token-' + Date.now(),
                        refreshToken: 'test-refresh-token-' + Date.now(),
                        id: 1,
                        username: data.username,
                        email: data.username + '@example.com',
                        roles: ['ROLE_USER']
                    }));
                } else {
                    res.writeHead(400, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({ message: 'Username and password are required' }));
                }
            } catch (error) {
                console.error('Error parsing request body:', error);
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ message: 'Invalid request body' }));
            }
        });
        
        return;
    }
    
    // Not found
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ message: 'Endpoint not found' }));
});

server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
}); 