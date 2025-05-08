# SPFx Development Quick Start Guide

This guide provides step-by-step commands to set up your SPFx development environment.

## Step 1: Install Prerequisites

```bash
# Install Node.js LTS version (if not already installed)
# Download from https://nodejs.org/

# Verify Node.js installation
node -v

# Verify npm installation
npm -v

# Install Yeoman and SPFx generator globally
npm install -g yo @microsoft/generator-sharepoint

# Install Gulp CLI globally
npm install -g gulp-cli

# Verify installations
yo --version
gulp --version
```

## Step 2: Set Up GitHub Repository

```bash
# Initialize git (if not already done)
git init

# Add remote repository (replace URL with your GitHub repo URL)
git remote add origin https://github.com/yourusername/your-repo-name.git

# Add files
git add .

# Commit
git commit -m "Initial project setup"

# Push to GitHub
git push -u origin main
```

## Step 3: Create SPFx Project

```bash
# Make sure you're in the root directory of your project
# Run the Yeoman generator
yo @microsoft/sharepoint

# Follow the prompts:
# - Solution name: [Your project name]
# - Baseline packages: SharePoint Online only (latest)
# - Target for component: SharePoint Online only
# - Place of files: Use the current folder
# - Allow access: [Y]
# - Type of client-side component: WebPart
# - WebPart name: [Your webpart name]
# - WebPart description: [Your description]
# - Framework: React

# Install dependencies
npm install

# Test the webpart in the local workbench
gulp serve
```

## Step 4: Build and Package

```bash
# Build the solution
gulp build

# Bundle the solution
gulp bundle --ship

# Package the solution
gulp package-solution --ship
```

The packaged solution will be available in the `./sharepoint/solution` folder as a `.sppkg` file. This file can be uploaded to the SharePoint App Catalog for deployment. 