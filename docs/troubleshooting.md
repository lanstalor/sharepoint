# SPFx Development Troubleshooting Guide

This guide provides solutions to common issues encountered during SharePoint Framework development.

## Node.js Version Issues

**Problem**: Error messages about incompatible Node.js versions.

**Solution**:
- SPFx requires specific Node.js versions for each SPFx version
- For SPFx v1.15.x: Use Node.js v16.x
- For SPFx v1.14.x: Use Node.js v14.x
- Use Node Version Manager (nvm) to switch between versions

```bash
# Install nvm (if not already installed)
# Windows: https://github.com/coreybutler/nvm-windows
# macOS/Linux: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install and use a specific Node.js version
nvm install 16
nvm use 16
```

## Build Errors

**Problem**: Errors when running `gulp build` or `gulp bundle`.

**Solution**:
- Ensure all dependencies are installed: `npm install`
- Clear the cache: `npm cache clean --force`
- Delete node_modules folder and reinstall: `rm -rf node_modules && npm install`
- Check for TypeScript errors in your code

## Workbench Issues

**Problem**: Local workbench doesn't load or doesn't show webparts.

**Solution**:
- Ensure you're running `gulp serve` from the project root
- Check browser console for errors
- Verify the webpart is properly registered in the manifest
- Try clearing browser cache or using incognito mode

## Package Deployment Issues

**Problem**: Unable to deploy .sppkg file to app catalog.

**Solution**:
- Ensure you have permissions to the app catalog
- Verify the package was built with `--ship` parameter
- Check for validation errors in the app catalog
- Verify the SharePoint tenant is the same one specified during development

## API Permissions Issues

**Problem**: Webpart cannot access SharePoint or Microsoft Graph APIs.

**Solution**:
- Verify API permissions are correctly defined in package-solution.json
- Ensure permissions are approved in the SharePoint admin center
- Check your code is using the correct API endpoints
- Verify authentication is properly implemented

## TypeScript/React Errors

**Problem**: TypeScript compilation errors or React rendering issues.

**Solution**:
- Check for missing imports or components
- Verify React component lifecycle methods are properly implemented
- Ensure props and state are correctly defined
- Use TypeScript interfaces for all data structures

## Performance Issues

**Problem**: Webpart loads slowly or causes browser performance problems.

**Solution**:
- Optimize API calls and reduce unnecessary requests
- Implement proper caching strategies
- Split large components into smaller ones
- Use React.memo or PureComponent for complex components
- Bundle size optimization (code splitting, tree shaking)

## Common Error Messages and Solutions

### "The attempted operation is prohibited because it exceeds the list view threshold"
- Implement paging in your API calls
- Use indexed columns for filtering
- Create appropriate views in SharePoint

### "Failed to load component with ID [GUID]"
- Verify component IDs in manifest files
- Check bundle has been properly built
- Ensure component is properly registered

### "Failed to load URL [URL] returned [HTTP Status]"
- Check network connectivity
- Verify authentication tokens are valid
- Ensure API endpoints are correct
- Check CORS settings if applicable 