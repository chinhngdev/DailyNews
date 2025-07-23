//
//  APIConfiguration.swift
//  DailyNews
//
//  Created for secure API configuration management
//

import Foundation

/// Centralized API configuration management
/// Safely retrieves API keys and configuration from build settings
struct APIConfiguration {
    
    // MARK: - API Keys
    
    /// News API key from APIKeys.swift file
    static var newsAPIKey: String {
        // Check if API key is properly configured
        if !APIKeys.newsAPIKey.isEmpty && !APIKeys.newsAPIKey.contains("YOUR_ACTUAL_API_KEY_HERE") {
            return APIKeys.newsAPIKey
        }
        
        // Return empty string with helpful message
        print("⚠️ NEWS_API_KEY not configured. Please update APIKeys.swift with your real API key.")
        return ""
    }
    
    // MARK: - API Endpoints
    
    /// Base URL cho News API
    static var newsAPIBaseURL: String {
        return APIKeys.newsAPIBaseURL
    }
    
    // MARK: - Configuration Settings
    
    /// API request timeout (giây)
    static var apiTimeout: TimeInterval {
        guard let timeoutString = Bundle.main.object(forInfoDictionaryKey: "API_TIMEOUT") as? String,
              let timeout = TimeInterval(timeoutString) else {
            return 30.0 // Default timeout
        }
        return timeout
    }
    
    /// Có enable API logging không
    static var isAPILoggingEnabled: Bool {
        guard let loggingString = Bundle.main.object(forInfoDictionaryKey: "ENABLE_LOGGING") as? String else {
            return false
        }
        return loggingString.lowercased() == "yes" || loggingString == "1"
    }
    
    // MARK: - Validation
    
    /// Kiểm tra tất cả API configuration có hợp lệ không
    static func validateConfiguration() -> Bool {
        let apiKey = newsAPIKey
        let baseURL = newsAPIBaseURL
        
        // Basic validation
        guard apiKey.count > 10 else {
            print("❌ API key is too short")
            return false
        }

        guard let _ = URL(string: baseURL) else {
            print("❌ Base URL is invalid")
            return false
        }
        
        print("✅ API Configuration validated successfully")
        return true
    }
    
    // MARK: - Debug Helper
    
    /// In thông tin configuration (chỉ dành cho debug, không expose API keys)
    static func printConfigurationInfo() {
        #if DEBUG
        print("📋 API Configuration:")
        print("   - Base URL: \(newsAPIBaseURL)")
        print("   - Timeout: \(apiTimeout)s")
        print("   - Logging: \(isAPILoggingEnabled)")
        print("   - API Key configured: \(!newsAPIKey.isEmpty)")
        #endif
    }
} 
