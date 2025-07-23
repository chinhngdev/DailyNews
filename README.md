# DailyNews
The daily news reader for your Apple devices.

## How to Build

### 1. Check out branch `main`

Clone or switch to the main branch of the repository:

```bash
git checkout main
```

### 2. Install SwiftGen via Homebrew

SwiftGen is required for code generation. Install it using Homebrew:

```bash
brew install swiftgen
```

### 3. Setup API Key

1. Get your API key from [NewsAPI.org](https://newsapi.org/register)

2. Create and configure the API keys file:
   
   Create `DailyNews/DailyNews/Data/Network/Base/APIKeys.swift` with the following content:
   ```swift
   import Foundation
   
   struct APIKeys {
       static let newsAPIKey = "your_actual_api_key_here"  // ← Replace this
       static let newsAPIBaseURL = "https://newsapi.org/v2"
   }
   ```
   
   **Note**: `APIKeys.swift` is excluded from git commits for security.

That's it! All other configurations (base URL, timeout, etc.) are already set in the xcconfig files.

## Prerequisites

- Xcode (latest version recommended)
- Homebrew package manager
- Active internet connection for API access
- NewsAPI.org account for API key

## Project Configuration

- **Debug build**: 30s timeout, logging enabled, staging endpoints
- **Release build**: 15s timeout, logging disabled, production endpoints
- **API key**: Configured in `APIKeys.swift` (not committed, secure)

## Next Steps

After completing the setup, you should be able to build and run the DailyNews app on your Apple devices or simulator.