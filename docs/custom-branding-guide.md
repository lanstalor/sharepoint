# Custom SharePoint Branding with SPFx

This guide walks you through creating a custom branding solution for SharePoint using the SharePoint Framework (SPFx) Application Customizer.

## What is an Application Customizer?

An SPFx Application Customizer lets you add JavaScript to SharePoint pages and access well-defined page placeholders. This is perfect for:

- Adding custom headers and footers
- Injecting custom CSS
- Adding persistent UI elements (like our AI bot)
- Customizing the overall look and feel

## Step 1: Create an SPFx Extension Project

1. **Open PowerShell as Administrator** and navigate to your project directory:
   ```
   cd "C:\Users\lance\OneDrive\Documents\_CODE\sharepoint"
   ```

2. **Create a new SPFx extension project** using Yeoman:
   ```
   yo @microsoft/sharepoint
   ```

3. **Answer the prompts** as follows:
   - **Solution Name**: BrandingExtension (or your preferred name)
   - **Baseline packages**: SharePoint Online only (latest)
   - **Target for component**: SharePoint Online only
   - **Place of files**: Use the current folder
   - **Allow telemetry**: Your preference (Y/N)
   - **Type of client-side component**: Extension
   - **Extension type**: Application Customizer
   - **Extension name**: CustomBranding
   - **Extension description**: Custom branding for SharePoint site

4. **Wait for the project to be created**.

## Step 2: Understand the Project Structure

Key files in your project:

- **src/extensions/customBranding/CustomBrandingApplicationCustomizer.ts**: Main entry point
- **config/package-solution.json**: Deployment settings
- **sharepoint/assets**: Where to store your CSS and image files

## Step 3: Modify the Application Customizer

1. **Open CustomBrandingApplicationCustomizer.ts** and update it to add custom CSS and modify headers/footers:

```typescript
import { Log } from '@microsoft/sp-core-library';
import {
  BaseApplicationCustomizer,
  PlaceholderContent,
  PlaceholderName
} from '@microsoft/sp-application-base';
import styles from './CustomBranding.module.scss';

const LOG_SOURCE: string = 'CustomBrandingApplicationCustomizer';

export interface ICustomBrandingApplicationCustomizerProperties {
  Top: string;
  Bottom: string;
}

export default class CustomBrandingApplicationCustomizer
  extends BaseApplicationCustomizer<ICustomBrandingApplicationCustomizerProperties> {

  private _topPlaceholder: PlaceholderContent | undefined;
  private _bottomPlaceholder: PlaceholderContent | undefined;

  public onInit(): Promise<void> {
    Log.info(LOG_SOURCE, `Initialized CustomBrandingApplicationCustomizer`);

    // Add custom CSS to the page
    this._injectCustomCSS();
    
    // Handle page placeholder changes
    this.context.placeholderProvider.changedEvent.add(this, this._renderPlaceHolders);
    
    // Call render method for first time page load
    this._renderPlaceHolders();

    return Promise.resolve();
  }

  private _injectCustomCSS(): void {
    // Create style element
    const customStyle = document.createElement('style');
    customStyle.innerHTML = `
      /* Global styles */
      .ms-compositeHeader {
        background-color: #2b579a !important;
      }
      
      /* Navigation customization */
      .ms-compositeHeader-topWrapper .ms-compositeHeader-topBarLeft .ms-compositeHeader-siteName {
        color: white !important;
      }
      
      /* Add more custom styles here */
    `;
    
    // Inject it into the head
    document.head.appendChild(customStyle);
  }

  private _renderPlaceHolders(): void {
    // Check if the header placeholder is already set
    if (!this._topPlaceholder) {
      this._topPlaceholder = this.context.placeholderProvider.tryCreateContent(
        PlaceholderName.Top,
        { onDispose: this._onDispose }
      );

      // If the placeholder exists, render the header
      if (this._topPlaceholder) {
        if (this.properties) {
          this._topPlaceholder.domElement.innerHTML = `
            <div class="${styles.customHeader}">
              <div class="${styles.customHeaderLogo}">
                <img src="${require('./assets/logo.png')}" alt="Company Logo" />
              </div>
              <div class="${styles.customHeaderTitle}">
                ${this.properties.Top || "Custom Header"}
              </div>
            </div>
          `;
        }
      }
    }

    // Check if the footer placeholder is already set
    if (!this._bottomPlaceholder) {
      this._bottomPlaceholder = this.context.placeholderProvider.tryCreateContent(
        PlaceholderName.Bottom,
        { onDispose: this._onDispose }
      );

      // If the placeholder exists, render the footer
      if (this._bottomPlaceholder) {
        if (this.properties) {
          this._bottomPlaceholder.domElement.innerHTML = `
            <div class="${styles.customFooter}">
              <div class="${styles.customFooterText}">
                ${this.properties.Bottom || "© " + new Date().getFullYear() + " Your Company. All rights reserved."}
              </div>
            </div>
          `;
        }
      }
    }
  }

  private _onDispose(): void {
    console.log('Disposed custom placeholders.');
  }
}
```

2. **Create a SCSS module file** for the customizer at `src/extensions/customBranding/CustomBranding.module.scss`:

```scss
.customHeader {
  background-color: #2b579a;
  color: white;
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  
  .customHeaderLogo {
    margin-right: 10px;
    
    img {
      height: 40px;
      width: auto;
    }
  }
  
  .customHeaderTitle {
    font-size: 18px;
    font-weight: 600;
  }
}

.customFooter {
  background-color: #f3f2f1;
  color: #323130;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 20px;
  
  .customFooterText {
    font-size: 12px;
  }
}
```

3. **Create an assets folder** and add your logo:
   - Create folder: `src/extensions/customBranding/assets/`
   - Add a logo image named `logo.png` to this folder

## Step 4: Configure the Extension for Deployment

1. **Open config/package-solution.json** and update it:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/spfx-build/package-solution.schema.json",
  "solution": {
    "name": "Custom Branding Solution",
    "id": "YOUR-SOLUTION-GUID", // Keep the existing GUID
    "version": "1.0.0.0",
    "includeClientSideAssets": true,
    "isDomainIsolated": false,
    "developer": {
      "name": "Your Name",
      "websiteUrl": "",
      "privacyUrl": "",
      "termsOfUseUrl": "",
      "mpnId": ""
    },
    "features": [
      {
        "title": "Custom Branding Application Extension",
        "description": "Adds custom branding elements to SharePoint sites",
        "id": "YOUR-FEATURE-GUID", // Keep the existing GUID
        "version": "1.0.0.0",
        "assets": {
          "elementManifests": [
            "elements.xml",
            "clientsideinstance.xml"
          ]
        }
      }
    ]
  },
  "paths": {
    "zippedPackage": "solution/custom-branding-solution.sppkg"
  }
}
```

2. **Create a clientsideinstance.xml file** in the `sharepoint` folder:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Elements xmlns="http://schemas.microsoft.com/sharepoint/">
    <ClientSideComponentInstance
        Title="CustomBranding"
        Location="ClientSideExtension.ApplicationCustomizer"
        ComponentId="YOUR-COMPONENT-GUID" <!-- Use the GUID from your CustomBrandingApplicationCustomizer.manifest.json -->
        Properties="{&quot;Top&quot;:&quot;Your Company Name&quot;,&quot;Bottom&quot;:&quot;© 2023 Your Company. All rights reserved.&quot;}">
    </ClientSideComponentInstance>
</Elements>
```

## Step 5: Test the Extension Locally

1. **Install dependencies**:
   ```
   npm install
   ```

2. **Trust the development certificate**:
   ```
   gulp trust-dev-cert
   ```

3. **Run the local workbench with a query parameter**:
   ```
   gulp serve --nobrowser
   ```

4. **Visit your SharePoint site** with the debug query parameters:
   ```
   https://your-tenant.sharepoint.com/sites/your-site?loadSPFX=true&debugManifestsFile=https://localhost:4321/temp/manifests.js&customActions={"YOUR-COMPONENT-GUID":{"location":"ClientSideExtension.ApplicationCustomizer","properties":{"Top":"Your Company Name","Bottom":"© 2023 Your Company. All rights reserved."}}}
   ```
   (Replace YOUR-COMPONENT-GUID with the actual GUID from the manifest file)

## Step 6: Deploy to SharePoint

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

4. **Activate the extension**:
   - Go to the site where you want to apply the branding
   - Navigate to "Site Settings" > "Site Collection Features"
   - Find your custom branding feature and activate it

## Step 7: Advanced Customization Ideas

1. **Theme Switcher**:
   - Add a theme switcher UI in the header
   - Store user preferences in local storage or user properties

2. **Responsive Design**:
   - Add media queries to handle different screen sizes
   - Create mobile-specific styles

3. **Site Collection Specific Branding**:
   - Read site properties to apply different branding to different sites
   - Use site URL patterns to determine which branding to apply

4. **User-specific Customization**:
   - Apply different styles based on user roles or groups
   - Allow users to personalize certain aspects of the UI

## Troubleshooting

- **Extension not showing up**: Verify the clientsideinstance.xml file and check browser console for errors
- **CSS not applying**: Check for conflicting styles and use !important for critical styles
- **Images not loading**: Ensure proper packaging of assets and verify file paths 