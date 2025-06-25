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
    
    /// News API key từ multiple sources với priority
    static var newsAPIKey: String {
        // Priority 1: Environment variable (development). Config in Xcode scheme
        if let envKey = ProcessInfo.processInfo.environment["NEWS_API_KEY"],
           !envKey.isEmpty && !envKey.contains("$(") {
            return envKey
        }
        
        // Priority 2: Bundle configuration (production). Config in Info.plist
        if let bundleKey = Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String,
           !bundleKey.isEmpty && !bundleKey.contains("$(") {
            return bundleKey
        }
        
        // Configuration error with helpful message
        let errorMessage = """
        ❌ NEWS_API_KEY not configured properly!
        
        Please set it using one of these methods:
        1. Environment variable: export NEWS_API_KEY="your_key"
        2. Xcode scheme environment variables
        3. Add to ~/.zshrc: export NEWS_API_KEY="your_key"
        
        Get your API key from: https://newsapi.org/register
        """
        fatalError(errorMessage)
    }
    
    // MARK: - API Endpoints
    
    /// Base URL cho News API
    static var newsAPIBaseURL: String {
        guard let baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"],
              !baseURL.isEmpty else {
            fatalError("❌ API_BASE_URL not properly configured. Please check configuration files")
        }
        return baseURL
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
        do {
            let apiKey = newsAPIKey
            let baseURL = newsAPIBaseURL
            
            // Basic validation
            guard apiKey.count > 10 else {
                print("❌ API key quá ngắn")
                return false
            }
            
            print("✅ API Configuration validated successfully")
            return true
        } catch {
            print("❌ API Configuration validation failed: \(error)")
            return false
        }
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
