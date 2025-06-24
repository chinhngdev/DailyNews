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

2. In Xcode, configure the API key:
   - **Product** → **Scheme** → **Edit Scheme**
   - Select **Run** → **Arguments** tab
   - Under **Environment Variables**, click **+**
   - Add: `NEWS_API_KEY` = `your_api_key_here`
   - **❌ Uncheck "Shared"** (keep API key private)
   - Click **Close**

That's it! All other configurations (base URL, timeout, etc.) are already set in the xcconfig files.

## Prerequisites

- Xcode (latest version recommended)
- Homebrew package manager
- Active internet connection for API access
- NewsAPI.org account for API key

## Project Configuration

- **Debug build**: 30s timeout, logging enabled, staging endpoints
- **Release build**: 15s timeout, logging disabled, production endpoints
- **API key**: Set via Xcode scheme environment variables (private)

## Next Steps

After completing the setup, you should be able to build and run the DailyNews app on your Apple devices or simulator.