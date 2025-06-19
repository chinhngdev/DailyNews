// TCAssets.swift
// Main module file for TCAssets package

import Foundation

// Platform-specific imports
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/// TCAssets provides type-safe access to all application resources
/// including images, colors, strings, fonts, and other assets.
///
/// Usage:
/// ```swift
/// import TCAssets
///
/// // Access images
/// let icon = Asset.Images.appIcon.image
///
/// // Access colors
/// let primaryColor = Asset.Colors.primary.color
///
/// // Access localized strings
/// let welcomeText = L10n.welcomeMessage
///
/// // Access fonts
/// let customFont = FontFamily.roboto.regular.font(size: 16)
/// ```
public enum TCAssets {
    
    /// Current version of TCAssets package
    public static let version = "1.0.0"
    
    /// Bundle containing all TCAssets resources
    public static let bundle: Bundle = {
        // Use BundleToken to locate the correct bundle
        let candidateBundle = Bundle(for: BundleToken.self)
        
        #if SWIFT_PACKAGE
        // Try to find the bundle containing resources
        if let bundleURL = candidateBundle.url(forResource: "TCAssets_TCAssets", withExtension: "bundle") {
            return Bundle(url: bundleURL) ?? candidateBundle
        }
        
        if let bundleURL = candidateBundle.url(forResource: "TCAssets", withExtension: "bundle") {
            return Bundle(url: bundleURL) ?? candidateBundle
        }
        #endif
        
        return candidateBundle
    }()
}

// MARK: - Bundle Token
private final class BundleToken {
    // This class is used to locate the bundle containing TCAssets resources
}

// MARK: - Cross-Platform Type Aliases
#if canImport(UIKit)
public typealias PlatformColor = UIColor
public typealias PlatformImage = UIImage
public typealias PlatformFont = UIFont
#elseif canImport(AppKit)
public typealias PlatformColor = NSColor
public typealias PlatformImage = NSImage
public typealias PlatformFont = NSFont
#endif

// MARK: - Resource Loading Helpers
public extension TCAssets {
    
    /// Load an image from the TCAssets bundle
    /// - Parameter name: The name of the image
    /// - Returns: Platform-specific image if found, nil otherwise
    #if canImport(UIKit)
    static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    #elseif canImport(AppKit)
    static func image(named name: String) -> NSImage? {
        return bundle.image(forResource: name)
    }
    #endif
    
    /// Load a color from the TCAssets bundle
    /// - Parameter name: The name of the color
    /// - Returns: Platform-specific color if found, nil otherwise
    #if canImport(UIKit)
    static func color(named name: String) -> UIColor? {
        return UIColor(named: name, in: bundle, compatibleWith: nil)
    }
    #elseif canImport(AppKit)
    static func color(named name: String) -> NSColor? {
        return NSColor(named: name, bundle: bundle)
    }
    #endif
    
    /// Load localized string from the TCAssets bundle
    /// - Parameters:
    ///   - key: The localization key
    ///   - tableName: The table name (default: "Localizable")
    ///   - comment: Comment for translators
    /// - Returns: Localized string
    static func localizedString(
        key: String,
        tableName: String = "Localizable",
        comment: String = ""
    ) -> String {
        return NSLocalizedString(
            key,
            tableName: tableName,
            bundle: bundle,
            comment: comment
        )
    }
}

// MARK: - Alternative Bundle Access (if needed)
public extension TCAssets {
    
    /// Alternative method to get bundle - useful for debugging
    static var alternativeBundle: Bundle {
        let currentBundle = Bundle(for: BundleToken.self)
        
        if let bundleIdentifier = currentBundle.bundleIdentifier,
           let foundBundle = Bundle(identifier: bundleIdentifier) {
            return foundBundle
        }
        
        return Bundle.main
    }
    
    /// Debug method to print all available bundles
    static func printAvailableBundles() {
        print("🔍 Available Bundles:")
        print("   Current Bundle: \(Bundle(for: BundleToken.self))")
        print("   Main Bundle: \(Bundle.main)")
        
        let currentBundle = Bundle(for: BundleToken.self)
        let bundlePath = currentBundle.bundlePath.components(separatedBy: "/").dropLast().joined(separator: "/")
        if !bundlePath.isEmpty {
            let fileManager = FileManager.default
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: bundlePath)
                let bundles = contents.filter { $0.hasSuffix(".bundle") }
                print("   Found bundles: \(bundles)")
            } catch {
                print("   Error reading bundle directory: \(error)")
            }
        }
    }
}

// MARK: - Debug Helpers
#if DEBUG
public extension TCAssets {
    
    /// Print information about the TCAssets bundle for debugging
    static func debugInfo() {
        print("📦 TCAssets Debug Info:")
        print("   Version: \(version)")
        print("   Bundle: \(bundle)")
        print("   Bundle Path: \(bundle.bundlePath)")
        print("   Bundle Identifier: \(bundle.bundleIdentifier ?? "nil")")
        
        #if canImport(UIKit)
        print("   Platform: iOS/tvOS/watchOS (UIKit)")
        #elseif canImport(AppKit)
        print("   Platform: macOS (AppKit)")
        #else
        print("   Platform: Unknown")
        #endif
        
        print("   Bundle Info:")
        print("     - Bundle URL: \(bundle.bundleURL)")
        print("     - Resource Path: \(bundle.resourcePath ?? "nil")")
        print("     - Executable Path: \(bundle.executablePath ?? "nil")")
        
        if let resourcePath = bundle.resourcePath {
            let fileManager = FileManager.default
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: resourcePath)
                print("   Resources: \(contents.count) items")
                for item in contents.prefix(10) {
                    print("     - \(item)")
                }
                if contents.count > 10 {
                    print("     ... and \(contents.count - 10) more")
                }
            } catch {
                print("   Error reading resources: \(error)")
            }
        }
        
        printAvailableBundles()
    }
}
#endif
