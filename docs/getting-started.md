# Getting Started with SPFx Development

This guide walks you through creating your first SPFx webpart and deploying it to SharePoint.

## Creating Your First SPFx Project

1. **Open PowerShell as Administrator** and navigate to your project directory:
   ```
   cd "C:\Users\lance\OneDrive\Documents\_CODE\sharepoint"
   ```

2. **Create a new SPFx project** using Yeoman:
   ```
   yo @microsoft/sharepoint
   ```

3. **Answer the prompts** as follows:
   - **Solution Name**: DemoSolution (or your preferred name)
   - **Baseline packages**: SharePoint Online only (latest)
   - **Target for component**: SharePoint Online only
   - **Place of files**: Use the current folder
   - **Allow telemetry**: Your preference (Y/N)
   - **Type of client-side component**: WebPart
   - **WebPart name**: HelloWorld
   - **WebPart description**: My first SPFx webpart
   - **Framework**: React

4. **Wait for the project to be created**. This may take a few minutes.

## Running Your First SPFx Webpart Locally

1. **Install dependencies**:
   ```
   npm install
   ```

2. **Trust the development certificate**:
   ```
   gulp trust-dev-cert
   ```

3. **Run the local workbench**:
   ```
   gulp serve
   ```

4. **Test your webpart**:
   - When the workbench opens in your browser, click the "+" button
   - Select your HelloWorld webpart from the list
   - Verify that the webpart renders correctly

## Customizing Your Webpart

1. **Open the project in VS Code**:
   ```
   code .
   ```

2. **Locate the main React component** at `src/webparts/helloWorld/components/HelloWorld.tsx`

3. **Modify the component** to make some changes:
   - Update the text
   - Add your own components
   - Change styles

4. **Save your changes** and see them automatically reflected in the browser (hot reload)

## Deploying Your Webpart

1. **Bundle and package the solution**:
   ```
   gulp bundle --ship
   gulp package-solution --ship
   ```

2. **Find your package** in the `sharepoint/solution` folder (it will have a `.sppkg` extension)

3. **Upload to your SharePoint App Catalog**:
   - Navigate to your SharePoint App Catalog site
   - Upload the `.sppkg` file to the "Apps for SharePoint" library
   - Check "Make this solution available to all sites in the organization" if desired
   - Click "Deploy"

4. **Add to a SharePoint site**:
   - Go to the site where you want to use the webpart
   - Click "New" > "App"
   - Find your webpart in the list and add it
   - Create a new page or edit an existing page
   - Add your webpart to the page

## Next Steps

Once you've verified your environment is working correctly with this simple webpart, you can move on to creating the components outlined in our project ideas:

1. **Custom SharePoint Branding** - Create an Application Customizer
2. **OpenProject Dashboard** - Create a webpart with API integration
3. **AI Bot Popup** - Create an Application Customizer with bot integration
4. **Teams Channel Embedding** - Create a webpart with Microsoft Graph API
5. **Synergis Adept Integration** - Create a webpart for document management 