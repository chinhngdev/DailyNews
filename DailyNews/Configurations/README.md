# 🔐 API Configuration Setup

Hướng dẫn thiết lập API keys một cách an toàn cho dự án DailyNews.


## 🚀 Quick Setup (Automated)

Chạy lệnh

```bash
./Scripts/setup-environment.sh
```

Script này sẽ tự động:
- Phát hiện shell của bạn (zsh/bash)
- Thêm environment variables vào shell config file  
- Hướng dẫn setup trong Xcode
- Validate configuration
- **Không cần copy file gì cả!**

## 📖 Sử dụng trong Code

```swift
import Foundation

// Truy cập API configuration
let apiKey = APIConfiguration.newsAPIKey
let baseURL = APIConfiguration.newsAPIBaseURL
let timeout = APIConfiguration.apiTimeout

// Validate configuration
APIConfiguration.validateConfiguration()

// Debug info (chỉ trong Debug build)
APIConfiguration.printConfigurationInfo()
```

## 🔒 Security Best Practices

### ✅ DO (Nên làm)
- Sử dụng environment variables cho API keys
- Sử dụng automated setup script
- Commit xcconfig files (chỉ chứa variable references)
- Validate API keys trong code
- Backup shell configuration files

### ❌ DON'T (Không nên)
- **KHÔNG** hardcode API keys trong source code
- **KHÔNG** share API keys qua chat/email  
- **KHÔNG** commit environment files chứa actual keys
- **KHÔNG** để API keys trong comments hoặc logs

## 🏗️ Cấu trúc File

```
DailyNews/Configurations/
├── Base.xcconfig              # Configuration chung
├── Debug.xcconfig             # Debug settings
├── Release.xcconfig           # Production settings  
├── APIKeys.xcconfig          # Environment variable mapping
└── README.md

Scripts/
└── setup-environment.sh      # Automated environment setup
```

## 🌍 Environment Variables

| Variable | Debug | Release | Description |
|----------|--------|---------|-------------|
| `NEWS_API_KEY` | From Environment | From Environment | API key cho NewsAPI |
| `NEWS_API_BASE_URL` | https://newsapi.org/v2 | https://newsapi.org/v2 | Base URL cho API |
| `API_REQUEST_TIMEOUT` | 30s | 15s | Request timeout |
| `ENABLE_API_LOGGING` | YES | NO | API request logging |
| `USE_STAGING_ENDPOINTS` | YES | NO | Sử dụng staging endpoints |

---

**🔐 Remember: API keys là tài sản quan trọng, hãy bảo vệ chúng như password!** 