# SharePoint Framework (SPFx) Setup Guide

This guide will walk you through setting up your development environment for SharePoint Framework (SPFx) development.

## Prerequisites

1. **Node.js**: 
   - Install Node.js LTS version (currently v16.x)
   - Download from [nodejs.org](https://nodejs.org/)

2. **npm**:
   - npm comes with Node.js
   - Verify installation with `npm -v`

3. **Yeoman and SPFx Yeoman generator**:
   - Install with `npm install -g yo @microsoft/generator-sharepoint`

4. **Gulp**:
   - Install with `npm install -g gulp-cli`

## Project Setup

1. **Initialize SPFx Project**:
   ```bash
   yo @microsoft/sharepoint
   ```
   Follow the prompts to create your new project.

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Run Local Workbench**:
   ```bash
   gulp serve
   ```
   This will open a local workbench where you can test your webparts.

## Development Workflow

1. Create webparts or extensions using the Yeoman generator
2. Develop your components in the `/src` directory
3. Test locally using `gulp serve`
4. Build for production using `gulp bundle --ship` and `gulp package-solution --ship`
5. Deploy to SharePoint

## Useful Commands

- `gulp clean`: Clean the distribution folder
- `gulp build`: Build the solution
- `gulp bundle`: Bundle the solution
- `gulp package-solution`: Package the solution
- `gulp serve`: Run the local workbench

## Resources

- [Official SPFx Documentation](https://docs.microsoft.com/en-us/sharepoint/dev/spfx/sharepoint-framework-overview)
- [SharePoint Developer Community](https://pnp.github.io/) 