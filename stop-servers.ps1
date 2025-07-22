# Script to stop any running servers on ports 3000 and 9000

function Stop-ServerOnPort {
    param (
        [int]$Port
    )
    
    Write-Host "Checking for processes using port $Port..."
    
    # Find process using the port
    $processInfo = netstat -ano | Select-String "LISTENING" | Select-String ":$Port " | ForEach-Object {
        $parts = $_ -split '\s+'
        $ipPort = $parts[1]
        $processPID = $parts[-1]
        
        # Return process info
        [PSCustomObject]@{
            IPPort = $ipPort
            PID = $processPID
        }
    }
    
    if ($processInfo) {
        foreach ($process in $processInfo) {
            try {
                # Skip system processes (PID 0, 4) and other protected processes
                if ($process.PID -eq 0 -or $process.PID -eq 4) {
                    Write-Host "Skipping system process with PID $($process.PID)"
                    continue
                }
                
                $processObj = Get-Process -Id $process.PID -ErrorAction SilentlyContinue
                if ($processObj) {
                    # Only try to stop user processes, not system ones
                    if ($processObj.ProcessName -notmatch "^(system|svchost|services|lsass|csrss|smss|wininit|winlogon)$") {
                        Write-Host "Stopping process $($processObj.ProcessName) (PID: $($process.PID)) using port $Port..."
                        Stop-Process -Id $process.PID -Force -ErrorAction SilentlyContinue
                        Write-Host "Process stopped successfully."
                    } else {
                        Write-Host "Skipping system process $($processObj.ProcessName) (PID: $($process.PID))"
                    }
                }
            } catch {
                Write-Host "Error stopping process with PID $($process.PID): $_"
            }
        }
    } else {
        Write-Host "No processes found using port $Port."
    }
}

# Stop servers on ports 3000 (frontend) and 9000 (backend)
Stop-ServerOnPort -Port 3000
Stop-ServerOnPort -Port 9000

Write-Host "All servers stopped. You can now start them again." 