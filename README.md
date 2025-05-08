# SharePoint Framework (SPFx) Development Project

This repository contains SharePoint Framework (SPFx) webparts and custom elements to enhance SharePoint Online for our team.

## Development Environment Setup for Windows 11

1. Install prerequisites:
   - Node.js LTS version (download from [nodejs.org](https://nodejs.org/))
   - npm (comes with Node.js)
   - Yeoman and SPFx Yeoman generator: `npm install -g yo @microsoft/generator-sharepoint`
   - Gulp: `npm install -g gulp-cli`

2. Windows-specific configuration:
   - Enable long paths in Git: `git config --system core.longpaths true`
   - Consider enabling long paths in Windows registry (see [windows-troubleshooting.md](./docs/windows-troubleshooting.md))
   - Run PowerShell as Administrator when installing global npm packages

3. Set up the project:
   - Clone this repository
   - Run `npm install`
   - Run `gulp trust-dev-cert` to trust the development certificate
   - Run `gulp serve` to test webparts locally

4. VS Code configuration:
   - Install recommended extensions (see .vscode/extensions.json)
   - Use the provided debugging configurations for local and SharePoint testing

## Project Structure

- `/src`: Source code for webparts and extensions
- `/docs`: Documentation files
- `/.chat`: AI conversation history for context
- `/config`: Configuration files for the project
- `/.vscode`: VS Code configurations for SPFx development

## Quick Start

Follow the instructions in the [Quick Start Guide](./docs/quick-start.md) to get started with development.

## Troubleshooting

If you encounter any issues during setup or development:
- Check the [general troubleshooting guide](./docs/troubleshooting.md)
- For Windows-specific issues, see the [Windows troubleshooting guide](./docs/windows-troubleshooting.md)

## Webpart Examples

See [webpart examples](./docs/webpart-examples.md) for ideas on what you can build with SPFx. 