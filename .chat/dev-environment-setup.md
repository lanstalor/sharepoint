# SharePoint Framework (SPFx) Development Environment Setup

**User**: Great this is awesome let's continue now to set up the dev environment. I'm operating in Windows 11.

**AI**: Let's set up your SPFx development environment on Windows 11. Here's the step-by-step process:

## 1. Install Node.js LTS

1. Download Node.js LTS version from [nodejs.org](https://nodejs.org/)
2. Run the installer and follow the installation wizard
3. Verify installation by opening PowerShell and running:
   ```
   node -v
   npm -v
   ```

## 2. Install Yeoman and SPFx Generator

Run these commands in PowerShell:
```
npm install -g yo
npm install -g @microsoft/generator-sharepoint
```

Verify installation:
```
yo --version
```

## 3. Install Gulp CLI

Run this command:
```
npm install -g gulp-cli
```

Verify installation:
```
gulp --version
```

## 4. Configure Windows for Development

1. Enable long paths in Git:
   ```
   git config --system core.longpaths true
   ```

2. If using Visual Studio Code, install these extensions:
   - ESLint
   - Prettier
   - SharePoint Framework Snippets

3. Set up your GitHub repository:
   ```
   git init
   git remote add origin https://github.com/yourusername/your-repo-name.git
   git add .
   git commit -m "Initial project setup"
   git push -u origin main
   ```

## 5. Initialize Your SPFx Project

```
yo @microsoft/sharepoint
```

Follow the prompts:
- Solution name: [Your project name]
- Baseline packages: SharePoint Online only (latest)
- Target for component: SharePoint Online only
- Place of files: Use the current folder
- Allow telemetry: [Y/N based on your preference]
- Type of client-side component: WebPart
- WebPart name: [Your webpart name]
- WebPart description: [Your description]
- Framework: React

## 6. Test Your Environment

```
npm install
gulp serve
```

This will build your project and open the SharePoint Workbench in your browser. 