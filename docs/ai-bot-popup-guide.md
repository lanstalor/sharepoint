# AI Bot Popup Integration with SPFx

This guide walks you through creating a persistent AI bot popup for SharePoint using the SharePoint Framework (SPFx) Application Customizer.

## Overview

We'll create a chat bot interface that appears in the bottom-right corner of all SharePoint pages. The bot will:

1. Persist across page navigation
2. Integrate with an AI service (Azure Bot Framework, OpenAI API, etc.)
3. Provide context-aware assistance based on the current page
4. Maintain chat history for continued conversations

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
   - **Solution Name**: AIChatBot (or your preferred name)
   - **Baseline packages**: SharePoint Online only (latest)
   - **Target for component**: SharePoint Online only
   - **Place of files**: Use the current folder
   - **Allow telemetry**: Your preference (Y/N)
   - **Type of client-side component**: Extension
   - **Extension type**: Application Customizer
   - **Extension name**: AIChatBot
   - **Extension description**: AI Chat Bot for SharePoint

## Step 2: Set Up the Project Structure

1. **Install additional dependencies**:
   ```
   npm install @fluentui/react uuid axios --save
   ```

2. **Create the folder structure**:
   - `/src/extensions/aiChatBot/components/` - For React components
   - `/src/extensions/aiChatBot/services/` - For API services
   - `/src/extensions/aiChatBot/models/` - For data models

## Step 3: Create the Bot Service

1. **Create a bot service file** at `src/extensions/aiChatBot/services/BotService.ts`:

```typescript
import axios from 'axios';

export interface IChatMessage {
  id: string;
  sender: 'user' | 'bot';
  text: string;
  timestamp: Date;
}

export interface IChatSession {
  id: string;
  messages: IChatMessage[];
}

export class BotService {
  private apiEndpoint: string;
  private apiKey: string;

  constructor(apiEndpoint: string, apiKey: string) {
    this.apiEndpoint = apiEndpoint;
    this.apiKey = apiKey;
  }

  public async sendMessage(message: string, sessionId: string): Promise<string> {
    try {
      // This is a placeholder for actual API integration
      // For a production app, you would connect to Azure Bot Service, Azure OpenAI, etc.
      
      // Example using OpenAI-like API
      const response = await axios.post(
        this.apiEndpoint,
        {
          messages: [{ role: 'user', content: message }],
          model: 'gpt-3.5-turbo', // Or your preferred model
          max_tokens: 150
        },
        {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.apiKey}`
          }
        }
      );

      // For demo purposes, if no API is available yet
      if (!this.apiEndpoint || !this.apiKey) {
        // Simulate API response for testing
        return this._simulateResponse(message);
      }

      return response.data.choices[0].message.content;
    } catch (error) {
      console.error('Error sending message to bot service:', error);
      return 'Sorry, I encountered an error processing your request.';
    }
  }

  // Simulate bot responses for testing without an actual API
  private _simulateResponse(message: string): string {
    const lowerMessage = message.toLowerCase();
    
    if (lowerMessage.includes('hello') || lowerMessage.includes('hi')) {
      return 'Hello! How can I assist you with SharePoint today?';
    } else if (lowerMessage.includes('sharepoint')) {
      return 'SharePoint is a powerful platform for collaboration and document management. What specific aspect are you interested in?';
    } else if (lowerMessage.includes('document') || lowerMessage.includes('file')) {
      return 'You can upload, download, and share documents in SharePoint. Would you like to know how to perform a specific action?';
    } else if (lowerMessage.includes('help')) {
      return 'I can help you with SharePoint navigation, document management, permissions, and more. What do you need assistance with?';
    } else {
      return 'I understand you\'re asking about "' + message + '". Could you provide more details so I can help you better?';
    }
  }
}
```

## Step 4: Create React Components for the Chat Bot

1. **Create the Chat Interface Component** at `src/extensions/aiChatBot/components/ChatInterface.tsx`:

```typescript
import * as React from 'react';
import { useState, useEffect, useRef } from 'react';
import { v4 as uuidv4 } from 'uuid';
import {
  Stack,
  TextField,
  PrimaryButton,
  Text,
  IconButton,
  mergeStyleSets,
  FontIcon,
  IStackTokens
} from '@fluentui/react';
import { BotService, IChatMessage, IChatSession } from '../services/BotService';

// Styles
const styles = mergeStyleSets({
  chatContainer: {
    position: 'fixed',
    bottom: '20px',
    right: '20px',
    width: '350px',
    maxHeight: '500px',
    backgroundColor: 'white',
    boxShadow: '0 0 10px rgba(0,0,0,0.2)',
    borderRadius: '8px',
    overflow: 'hidden',
    zIndex: 1000,
    display: 'flex',
    flexDirection: 'column'
  },
  chatHeader: {
    backgroundColor: '#0078d4',
    color: 'white',
    padding: '12px 16px',
    fontWeight: 600,
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    cursor: 'pointer'
  },
  chatMessages: {
    padding: '16px',
    maxHeight: '300px',
    overflowY: 'auto',
    flex: 1
  },
  userMessage: {
    backgroundColor: '#e5f1fb',
    padding: '8px 12px',
    borderRadius: '18px',
    marginBottom: '8px',
    maxWidth: '80%',
    alignSelf: 'flex-end',
    marginLeft: 'auto'
  },
  botMessage: {
    backgroundColor: '#f3f2f1',
    padding: '8px 12px',
    borderRadius: '18px',
    marginBottom: '8px',
    maxWidth: '80%'
  },
  inputArea: {
    padding: '12px',
    borderTop: '1px solid #f3f2f1',
    display: 'flex'
  },
  messageText: {
    margin: 0,
    wordBreak: 'break-word'
  },
  timestamp: {
    fontSize: '10px',
    color: '#605e5c',
    marginTop: '4px'
  },
  minimizedChat: {
    position: 'fixed',
    bottom: '20px',
    right: '20px',
    width: '60px',
    height: '60px',
    backgroundColor: '#0078d4',
    borderRadius: '50%',
    boxShadow: '0 0 10px rgba(0,0,0,0.2)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    cursor: 'pointer',
    zIndex: 1000
  },
  botIcon: {
    color: 'white',
    fontSize: '24px'
  }
});

// Props interface
export interface IChatInterfaceProps {
  botService: BotService;
  currentPageUrl: string;
  currentPageTitle: string;
}

// Component
export const ChatInterface: React.FC<IChatInterfaceProps> = (props) => {
  const [isMinimized, setIsMinimized] = useState(true);
  const [message, setMessage] = useState('');
  const [session, setSession] = useState<IChatSession>(() => {
    // Try to load from localStorage
    const savedSession = localStorage.getItem('aiChatBotSession');
    if (savedSession) {
      try {
        const parsedSession = JSON.parse(savedSession);
        // Convert string dates back to Date objects
        parsedSession.messages.forEach((msg: any) => {
          msg.timestamp = new Date(msg.timestamp);
        });
        return parsedSession;
      } catch (e) {
        console.error('Error parsing saved chat session', e);
      }
    }
    
    // Create new session if none exists
    return {
      id: uuidv4(),
      messages: [
        {
          id: uuidv4(),
          sender: 'bot',
          text: `Hello! I'm your SharePoint assistant. How can I help you today?`,
          timestamp: new Date()
        }
      ]
    };
  });
  
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const { botService, currentPageUrl, currentPageTitle } = props;

  // Scroll to bottom of chat when messages change
  useEffect(() => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [session.messages]);

  // Save session to localStorage when it changes
  useEffect(() => {
    localStorage.setItem('aiChatBotSession', JSON.stringify(session));
  }, [session]);

  const toggleMinimize = (): void => {
    setIsMinimized(!isMinimized);
  };

  const handleSendMessage = async (): Promise<void> => {
    if (!message.trim()) return;

    // Add user message to chat
    const userMessage: IChatMessage = {
      id: uuidv4(),
      sender: 'user',
      text: message,
      timestamp: new Date()
    };

    setSession(prevSession => ({
      ...prevSession,
      messages: [...prevSession.messages, userMessage]
    }));

    setMessage('');

    // Send message to bot and get response
    try {
      // Include page context in the message to the bot
      const contextMessage = `User is on page: ${currentPageTitle} (${currentPageUrl}).\nUser message: ${message}`;
      const botResponse = await botService.sendMessage(contextMessage, session.id);

      // Add bot response to chat
      const botMessage: IChatMessage = {
        id: uuidv4(),
        sender: 'bot',
        text: botResponse,
        timestamp: new Date()
      };

      setSession(prevSession => ({
        ...prevSession,
        messages: [...prevSession.messages, botMessage]
      }));
    } catch (error) {
      console.error('Error getting bot response:', error);
      
      // Add error message
      const errorMessage: IChatMessage = {
        id: uuidv4(),
        sender: 'bot',
        text: 'Sorry, I encountered an error. Please try again later.',
        timestamp: new Date()
      };

      setSession(prevSession => ({
        ...prevSession,
        messages: [...prevSession.messages, errorMessage]
      }));
    }
  };

  // Format timestamp
  const formatTime = (date: Date): string => {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  // Render minimized chat button
  if (isMinimized) {
    return (
      <div className={styles.minimizedChat} onClick={toggleMinimize}>
        <FontIcon iconName="Robot" className={styles.botIcon} />
      </div>
    );
  }

  // Render open chat interface
  return (
    <div className={styles.chatContainer}>
      <div className={styles.chatHeader} onClick={toggleMinimize}>
        <Text>SharePoint Assistant</Text>
        <IconButton
          iconProps={{ iconName: 'ChevronDown' }}
          title="Minimize"
          ariaLabel="Minimize chat"
          onClick={toggleMinimize}
        />
      </div>
      <div className={styles.chatMessages}>
        {session.messages.map((msg) => (
          <Stack
            key={msg.id}
            horizontal={msg.sender === 'user'}
            horizontalAlign={msg.sender === 'user' ? 'end' : 'start'}
            style={{ marginBottom: '12px' }}
          >
            <div className={msg.sender === 'user' ? styles.userMessage : styles.botMessage}>
              <Text className={styles.messageText}>{msg.text}</Text>
              <div className={styles.timestamp}>{formatTime(msg.timestamp)}</div>
            </div>
          </Stack>
        ))}
        <div ref={messagesEndRef} />
      </div>
      <div className={styles.inputArea}>
        <TextField
          placeholder="Type a message..."
          value={message}
          onChange={(_, newValue) => setMessage(newValue || '')}
          onKeyPress={(e) => {
            if (e.key === 'Enter') {
              handleSendMessage();
            }
          }}
          styles={{ root: { flex: 1, marginRight: 8 } }}
        />
        <PrimaryButton
          text="Send"
          onClick={handleSendMessage}
          disabled={!message.trim()}
        />
      </div>
    </div>
  );
};
```

## Step 5: Create the Application Customizer

1. **Update the Application Customizer** at `src/extensions/aiChatBot/AIChatBotApplicationCustomizer.ts`:

```typescript
import { Log } from '@microsoft/sp-core-library';
import {
  BaseApplicationCustomizer
} from '@microsoft/sp-application-base';
import * as React from 'react';
import * as ReactDom from 'react-dom';

import { BotService } from './services/BotService';
import { ChatInterface, IChatInterfaceProps } from './components/ChatInterface';

const LOG_SOURCE: string = 'AIChatBotApplicationCustomizer';

export interface IAIChatBotApplicationCustomizerProperties {
  // Properties from the manifest
  botApiEndpoint?: string;
  botApiKey?: string;
}

export default class AIChatBotApplicationCustomizer
  extends BaseApplicationCustomizer<IAIChatBotApplicationCustomizerProperties> {

  private _botService: BotService;
  private _chatContainer: HTMLDivElement | null = null;

  public onInit(): Promise<void> {
    Log.info(LOG_SOURCE, `Initialized AIChatBotApplicationCustomizer`);

    // Get properties from manifest
    const { botApiEndpoint, botApiKey } = this.properties;
    
    // Initialize bot service
    this._botService = new BotService(
      botApiEndpoint || '', // Replace with your actual endpoint in production
      botApiKey || ''       // Replace with your actual API key in production
    );

    // Create container for the chat interface
    this._chatContainer = document.createElement('div');
    document.body.appendChild(this._chatContainer);

    // Render the chat interface
    this._renderChatInterface();

    return Promise.resolve();
  }

  private _renderChatInterface(): void {
    if (!this._chatContainer) return;

    // Get current page info for context
    const currentPageUrl = window.location.href;
    const currentPageTitle = document.title;

    // Create props for the component
    const element: React.ReactElement<IChatInterfaceProps> = React.createElement(
      ChatInterface,
      {
        botService: this._botService,
        currentPageUrl,
        currentPageTitle
      }
    );

    // Render the component
    ReactDom.render(element, this._chatContainer);
  }

  protected onDispose(): void {
    // Clean up when the extension is disposed
    if (this._chatContainer) {
      ReactDom.unmountComponentAtNode(this._chatContainer);
      this._chatContainer.remove();
      this._chatContainer = null;
    }
  }
}
```

## Step 6: Configure Extension for Deployment

1. **Update package-solution.json** in the config folder:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/spfx-build/package-solution.schema.json",
  "solution": {
    "name": "AI Chat Bot Solution",
    "id": "YOUR-SOLUTION-GUID", // Keep existing GUID
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
        "title": "AI Chat Bot Application Extension",
        "description": "Adds an AI chat bot to SharePoint pages",
        "id": "YOUR-FEATURE-GUID", // Keep existing GUID
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
    "zippedPackage": "solution/ai-chat-bot-solution.sppkg"
  }
}
```

2. **Create clientsideinstance.xml** in the `sharepoint` folder:

```xml
<?xml version="1.0" encoding="utf-8"?>
<Elements xmlns="http://schemas.microsoft.com/sharepoint/">
    <ClientSideComponentInstance
        Title="AIChatBot"
        Location="ClientSideExtension.ApplicationCustomizer"
        ComponentId="YOUR-COMPONENT-GUID" <!-- Use GUID from manifest file -->
        Properties="{&quot;botApiEndpoint&quot;:&quot;https://your-api-endpoint.com&quot;,&quot;botApiKey&quot;:&quot;your-api-key&quot;}">
    </ClientSideComponentInstance>
</Elements>
```

## Step 7: Test the Extension Locally

1. **Install dependencies**:
   ```
   npm install
   ```

2. **Build and run the solution**:
   ```
   gulp serve --nobrowser
   ```

3. **Navigate to your SharePoint site** with the debug query parameters:
   ```
   https://your-tenant.sharepoint.com/sites/your-site?loadSPFX=true&debugManifestsFile=https://localhost:4321/temp/manifests.js&customActions={"YOUR-COMPONENT-GUID":{"location":"ClientSideExtension.ApplicationCustomizer"}}
   ```

## Step 8: Deploy to SharePoint

1. **Bundle and package the solution**:
   ```
   gulp bundle --ship
   gulp package-solution --ship
   ```

2. **Upload the package** to your SharePoint App Catalog

3. **Approve API permissions** if your bot integration requires them

4. **Add the extension to your site**

## Step 9: Integrating with Real AI Services

For a production-ready bot, consider integrating with one of these services:

### Azure Bot Service

1. **Create an Azure Bot Service** in Azure Portal
2. **Register your bot** with Microsoft Bot Framework
3. **Implement DirectLine API** for web chat integration
4. **Update BotService.ts** to use the DirectLine API

### OpenAI API

1. **Sign up for OpenAI API access**
2. **Get your API key** from the OpenAI dashboard
3. **Update BotService.ts** to use the OpenAI Chat Completions API
4. **Add context about SharePoint** to your prompts

### Microsoft Copilot for Microsoft 365

1. **Check if your organization has access** to Copilot for Microsoft 365
2. **Use Copilot APIs** to leverage SharePoint-aware AI capabilities
3. **Configure appropriate permissions** for API access

## Step 10: Advanced Features

Consider these enhancements for a more powerful bot:

1. **User Personalization**:
   - Store user preferences
   - Remember conversation history across sessions
   - Adapt responses based on user role or department

2. **Document Awareness**:
   - Allow the bot to search documents
   - Provide document summaries
   - Answer questions about document content

3. **Multilingual Support**:
   - Detect user language
   - Translate responses
   - Support multilingual queries

4. **Integration with SharePoint Search**:
   - Help users find content
   - Surface relevant information based on queries
   - Provide quick access to frequently used resources

5. **Analytics Dashboard**:
   - Track bot usage
   - Identify common questions
   - Improve bot responses based on user feedback