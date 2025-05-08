# Windows-Specific SPFx Troubleshooting Guide

This guide addresses common issues specifically encountered when developing SPFx solutions on Windows 11.

## Path Length Limitations

**Problem**: Error messages about path length limitations.

**Solution**:
- Enable long paths in Git:
  ```
  git config --system core.longpaths true
  ```
- Enable long paths in Windows 11:
  1. Press Win + R, type "regedit" and press Enter
  2. Navigate to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
  3. Find "LongPathsEnabled" (DWORD) and set it to 1
  4. Restart your computer

## Permission Issues

**Problem**: Access denied errors when installing global npm packages.

**Solution**:
- Run PowerShell as Administrator when installing global packages
- Use the following command to fix npm permissions:
  ```
  npm config set prefix C:\Users\<YourUsername>\AppData\Roaming\npm
  ```

## Node.js Version Management

**Problem**: Need to switch between Node.js versions for different projects.

**Solution**:
- Install nvm-windows:
  1. Download from [https://github.com/coreybutler/nvm-windows/releases](https://github.com/coreybutler/nvm-windows/releases)
  2. Run the installer
  3. Use the following commands:
     ```
     nvm install 16.18.0
     nvm use 16.18.0
     ```

## Certificate Issues

**Problem**: SSL certificate errors when running `gulp serve`.

**Solution**:
- Run the following command to generate a new developer certificate:
  ```
  gulp trust-dev-cert
  ```
- If that doesn't work, try:
  ```
  npm uninstall -g gulp
  npm install -g gulp@4.0.2
  gulp trust-dev-cert
  ```

## Visual Studio Code Integration

**Problem**: TypeScript or ESLint not working correctly in VS Code.

**Solution**:
- Install recommended extensions:
  - ESLint
  - Prettier
  - SharePoint Framework Snippets
- Set up workspace settings (.vscode/settings.json):
  ```json
  {
    "typescript.tsdk": "node_modules\\typescript\\lib",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  }
  ```

## Building and Packaging Issues

**Problem**: Errors when running `gulp bundle --ship` or `gulp package-solution --ship`.

**Solution**:
- Make sure to clear the cache and build files first:
  ```
  gulp clean
  gulp build
  gulp bundle --ship
  gulp package-solution --ship
  ```
- If you encounter memory issues, increase Node.js memory limit:
  ```
  SET NODE_OPTIONS=--max_old_space_size=8192
  ```

## WSL Integration (Optional)

**Problem**: Prefer using Linux-like environment for development.

**Solution**:
- Enable WSL 2 in Windows 11
- Install Ubuntu from Microsoft Store
- Set up Node.js in WSL environment
- Use VS Code's Remote - WSL extension to develop in WSL environment

## Antivirus Interference

**Problem**: Slow build times or random file access errors.

**Solution**:
- Add exclusions in your antivirus for:
  - Your project folder
  - `C:\Users\<username>\AppData\Roaming\npm`
  - `C:\Users\<username>\.node-gyp`

## PowerShell Execution Policy

**Problem**: Unable to run scripts in PowerShell.

**Solution**:
- Run PowerShell as Administrator and execute:
  ```
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ``` 