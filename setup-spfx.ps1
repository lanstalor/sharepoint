# SharePoint Framework (SPFx) Development Environment Setup Script
# Run this script as Administrator in PowerShell

Write-Host "SharePoint Framework (SPFx) Development Environment Setup" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green

# Check if running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires Administrator privileges. Please restart as Administrator." -ForegroundColor Red
    exit
}

# Function to check if a command exists
function Test-CommandExists {
    param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {
        if (Get-Command $command) { return $true }
    }
    catch { return $false }
    finally { $ErrorActionPreference = $oldPreference }
}

# Step 1: Check and set execution policy
Write-Host "1. Setting PowerShell execution policy..." -ForegroundColor Yellow
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "   Execution policy set to RemoteSigned." -ForegroundColor Green
}
catch {
    Write-Host "   Failed to set execution policy: $_" -ForegroundColor Red
}

# Step 2: Check for Node.js installation
Write-Host "2. Checking Node.js installation..." -ForegroundColor Yellow
if (Test-CommandExists node) {
    $nodeVersion = node -v
    Write-Host "   Node.js is installed. Version: $nodeVersion" -ForegroundColor Green
    
    # Check if version is compatible with SPFx
    $versionNumber = $nodeVersion.Substring(1)
    $majorVersion = [int]($versionNumber.Split('.')[0])
    
    if ($majorVersion -lt 16) {
        Write-Host "   Warning: SPFx works best with Node.js v16.x. Consider upgrading." -ForegroundColor Yellow
    }
    elseif ($majorVersion -gt 16) {
        Write-Host "   Warning: Some SPFx versions may not be compatible with Node.js $majorVersion.x. Consider using Node.js v16.x." -ForegroundColor Yellow
    }
    else {
        Write-Host "   Node.js version is compatible with SPFx." -ForegroundColor Green
    }
}
else {
    Write-Host "   Node.js is not installed. Please download and install from https://nodejs.org/" -ForegroundColor Red
    Write-Host "   After installing Node.js, please run this script again." -ForegroundColor Red
    exit
}

# Step 3: Check for npm installation
Write-Host "3. Checking npm installation..." -ForegroundColor Yellow
if (Test-CommandExists npm) {
    $npmVersion = npm -v
    Write-Host "   npm is installed. Version: $npmVersion" -ForegroundColor Green
}
else {
    Write-Host "   npm is not installed. It should come with Node.js installation." -ForegroundColor Red
    exit
}

# Step 4: Install Yeoman and SPFx generator
Write-Host "4. Installing Yeoman and SPFx generator..." -ForegroundColor Yellow
try {
    npm install -g yo @microsoft/generator-sharepoint
    Write-Host "   Yeoman and SPFx generator installed successfully." -ForegroundColor Green
}
catch {
    Write-Host "   Failed to install Yeoman and SPFx generator: $_" -ForegroundColor Red
}

# Step 5: Install Gulp CLI
Write-Host "5. Installing Gulp CLI..." -ForegroundColor Yellow
try {
    npm install -g gulp-cli
    Write-Host "   Gulp CLI installed successfully." -ForegroundColor Green
}
catch {
    Write-Host "   Failed to install Gulp CLI: $_" -ForegroundColor Red
}

# Step 6: Enable long paths in Git
Write-Host "6. Enabling long paths in Git..." -ForegroundColor Yellow
try {
    git config --system core.longpaths true
    Write-Host "   Long paths enabled in Git." -ForegroundColor Green
}
catch {
    Write-Host "   Failed to enable long paths in Git: $_" -ForegroundColor Red
}

# Step 7: Check VS Code installation
Write-Host "7. Checking if Visual Studio Code is installed..." -ForegroundColor Yellow
if (Test-Path "C:\Program Files\Microsoft VS Code\code.exe" -PathType Leaf) {
    Write-Host "   Visual Studio Code is installed." -ForegroundColor Green
    
    # Recommend extensions
    Write-Host "   Recommended VS Code extensions for SPFx development:" -ForegroundColor Yellow
    Write-Host "   - ESLint (dbaeumer.vscode-eslint)" -ForegroundColor Cyan
    Write-Host "   - Prettier (esbenp.prettier-vscode)" -ForegroundColor Cyan
    Write-Host "   - SharePoint Framework Snippets (or similar SPFx extension)" -ForegroundColor Cyan
}
else {
    Write-Host "   Visual Studio Code is not installed. Consider installing it for SPFx development." -ForegroundColor Yellow
    Write-Host "   Download from: https://code.visualstudio.com/" -ForegroundColor Cyan
}

# Step 8: Verify installations
Write-Host "8. Verifying installations..." -ForegroundColor Yellow
try {
    $nodeCheck = node -v
    $npmCheck = npm -v
    $yoCheck = yo --version
    $gulpCheck = gulp --version
    
    Write-Host "   Node.js version: $nodeCheck" -ForegroundColor Green
    Write-Host "   npm version: $npmCheck" -ForegroundColor Green
    Write-Host "   Yeoman version: $yoCheck" -ForegroundColor Green
    Write-Host "   Gulp version: $($gulpCheck -split "`n" | Select-Object -First 1)" -ForegroundColor Green
    
    Write-Host "`n✓ Environment setup complete!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Run 'yo @microsoft/sharepoint' to create a new SPFx project" -ForegroundColor Cyan
    Write-Host "2. Follow the prompts to configure your project" -ForegroundColor Cyan
    Write-Host "3. Run 'npm install' in your project directory" -ForegroundColor Cyan
    Write-Host "4. Run 'gulp trust-dev-cert' to trust the development certificate" -ForegroundColor Cyan
    Write-Host "5. Run 'gulp serve' to start the local development server" -ForegroundColor Cyan
}
catch {
    Write-Host "   Verification failed: $_" -ForegroundColor Red
} 