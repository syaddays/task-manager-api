$port = 3000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")

# Check if the port is already in use
try {
    $listener.Start()
    Write-Host "Server is running on http://localhost:$port/"
    Write-Host "Press Ctrl+C to stop the server"
} catch {
    Write-Host "Error starting server: $_"
    Write-Host "The port $port may already be in use. Try stopping any existing servers or using a different port."
    exit 1
}

$webRoot = $PSScriptRoot

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $localPath = $request.Url.LocalPath
        $localPath = $localPath -replace "/", "\"
        
        if ($localPath -eq "\") {
            $localPath = "\index.html"
        }

        $filePath = Join-Path $webRoot $localPath.Substring(1)
        
        if (Test-Path $filePath -PathType Leaf) {
            $content = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $content.Length
            
            $ext = [System.IO.Path]::GetExtension($filePath)
            switch ($ext) {
                ".html" { $response.ContentType = "text/html" }
                ".css" { $response.ContentType = "text/css" }
                ".js" { $response.ContentType = "application/javascript" }
                ".json" { $response.ContentType = "application/json" }
                ".png" { $response.ContentType = "image/png" }
                ".jpg" { $response.ContentType = "image/jpeg" }
                ".gif" { $response.ContentType = "image/gif" }
                default { $response.ContentType = "application/octet-stream" }
            }
            
            $output = $response.OutputStream
            $output.Write($content, 0, $content.Length)
            $output.Close()
        } else {
            $response.StatusCode = 404
            $response.Close()
        }
        
        Write-Host "$($request.HttpMethod) $($request.Url.LocalPath) $($response.StatusCode)"
    }
} finally {
    try {
        if ($listener -ne $null -and $listener.IsListening) {
            $listener.Stop()
        }
    } catch {
        Write-Host "Error stopping server: $_"
    }
} 