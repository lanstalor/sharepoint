# Simple SharePoint Framework Setup Script
# Run this in PowerShell with admin rights

Write-Host "Setting up SPFx development environment..." -ForegroundColor Green

# Set execution policy
Write-Host "Setting execution policy..." -ForegroundColor Yellow
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Check Node.js
Write-Host "Checking Node.js installation..." -ForegroundColor Yellow
$nodeVersion = node -v
Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green

# Check npm
Write-Host "Checking npm installation..." -ForegroundColor Yellow
$npmVersion = npm -v
Write-Host "npm version: $npmVersion" -ForegroundColor Green

# Install Yeoman and SPFx generator
Write-Host "Installing Yeoman and SPFx generator..." -ForegroundColor Yellow
npm install -g yo @microsoft/generator-sharepoint

# Install Gulp CLI
Write-Host "Installing Gulp CLI..." -ForegroundColor Yellow
npm install -g gulp-cli

# Enable long paths in Git
Write-Host "Enabling long paths in Git..." -ForegroundColor Yellow
git config --system core.longpaths true

# Verify installations
Write-Host "Verifying installations..." -ForegroundColor Yellow
Write-Host "Node.js: $(node -v)" -ForegroundColor Green
Write-Host "npm: $(npm -v)" -ForegroundColor Green
Write-Host "Yeoman: $(yo --version)" -ForegroundColor Green
Write-Host "Gulp: $(gulp --version)" -ForegroundColor Green

Write-Host "`nSetup complete! Next steps:" -ForegroundColor Green
Write-Host "1. Run 'yo @microsoft/sharepoint' to create a new SPFx project" -ForegroundColor Cyan
Write-Host "2. Run 'npm install' in your project directory" -ForegroundColor Cyan
Write-Host "3. Run 'gulp trust-dev-cert' to trust the development certificate" -ForegroundColor Cyan
Write-Host "4. Run 'gulp serve' to start the local workbench" -ForegroundColor Cyan 