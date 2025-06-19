#!/bin/bash

# generate.sh - SwiftGen Build Script for TCAssets Package (iOS Compatible)
# This script should be placed in the TCAssets root directory

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SWIFTGEN_CONFIG="$SCRIPT_DIR/swiftgen.yml"
GENERATED_DIR="$SCRIPT_DIR/Sources/TCAssets/Generated"

echo -e "${BLUE}🔨 TCAssets Generation Started${NC}"
echo "📁 Working directory: $SCRIPT_DIR"

# Check if SwiftGen is installed
if ! command -v swiftgen > /dev/null 2>&1; then
    echo -e "${RED}❌ SwiftGen is not installed${NC}"
    echo -e "${YELLOW}💡 Install with: brew install swiftgen${NC}"
    exit 1
fi

# Check if config file exists
if [ ! -f "$SWIFTGEN_CONFIG" ]; then
    echo -e "${RED}❌ SwiftGen config file not found: $SWIFTGEN_CONFIG${NC}"
    exit 1
fi

# Create generated directory if it doesn't exist
if [ ! -d "$GENERATED_DIR" ]; then
    echo -e "${YELLOW}📁 Creating generated directory: $GENERATED_DIR${NC}"
    mkdir -p "$GENERATED_DIR"
fi

# Check SwiftGen version
SWIFTGEN_VERSION=$(swiftgen --version)
echo -e "${BLUE}🔧 SwiftGen version: $SWIFTGEN_VERSION${NC}"

# Validate SwiftGen configuration
echo -e "${BLUE}🔍 Validating SwiftGen configuration...${NC}"
if swiftgen config lint --config "$SWIFTGEN_CONFIG"; then
    echo -e "${GREEN}✅ Configuration is valid${NC}"
else
    echo -e "${RED}❌ Configuration validation failed${NC}"
    exit 1
fi

# List input resources
echo -e "${BLUE}📋 Input resources:${NC}"
RESOURCES_DIR="$SCRIPT_DIR/Resources"
if [ -d "$RESOURCES_DIR" ]; then
    find "$RESOURCES_DIR" -type f \( -name "*.xcassets" -o -name "*.strings" -o -name "*.ttf" -o -name "*.otf" \) | while read -r file; do
        echo "   📄 $(basename "$file")"
    done
else
    echo -e "${YELLOW}⚠️  No Resources directory found${NC}"
fi

# Run SwiftGen
echo -e "${BLUE}🚀 Running SwiftGen...${NC}"
cd "$SCRIPT_DIR"

if swiftgen --config "$SWIFTGEN_CONFIG"; then
    echo -e "${GREEN}✅ SwiftGen completed successfully${NC}"
else
    echo -e "${RED}❌ SwiftGen failed${NC}"
    exit 1
fi

# List generated files
echo -e "${BLUE}📋 Generated files:${NC}"
if [ -d "$GENERATED_DIR" ]; then
    find "$GENERATED_DIR" -name "*.swift" | while read -r file; do
        file_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "unknown")
        echo "   📄 $(basename "$file") (${file_size} bytes)"
    done
else
    echo -e "${YELLOW}⚠️  No generated files found${NC}"
fi

# Validate generated Swift files (platform-aware)
echo -e "${BLUE}🔍 Validating generated Swift files...${NC}"
VALIDATION_PASSED=true

# Function to test Swift compilation
test_swift_compilation() {
    local file="$1"
    local platform="$2"
    local sdk_flag="$3"
    
    if [ -n "$sdk_flag" ]; then
        if xcrun -sdk "$sdk_flag" swift -frontend -parse "$file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $(basename "$file") - syntax valid ($platform)${NC}"
            return 0
        else
            echo -e "${RED}❌ $(basename "$file") - syntax error ($platform)${NC}"
            return 1
        fi
    else
        if swift -frontend -parse "$file" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $(basename "$file") - syntax valid ($platform)${NC}"
            return 0
        else
            echo -e "${RED}❌ $(basename "$file") - syntax error ($platform)${NC}"
            return 1
        fi
    fi
}

# Test compilation for different platforms
for swift_file in "$GENERATED_DIR"/*.swift; do
    if [ -f "$swift_file" ]; then
        # Test for iOS (primary target)
        if command -v xcrun > /dev/null 2>&1; then
            if ! test_swift_compilation "$swift_file" "iOS" "iphonesimulator"; then
                VALIDATION_PASSED=false
            fi
        else
            # Fallback to default Swift compiler
            if ! test_swift_compilation "$swift_file" "Default" ""; then
                VALIDATION_PASSED=false
            fi
        fi
    fi
done

if [ "$VALIDATION_PASSED" = false ]; then
    echo -e "${RED}❌ Some generated files have syntax errors${NC}"
    exit 1
fi

# Optional: Test package compilation
echo -e "${BLUE}🧪 Testing package compilation...${NC}"
if command -v xcrun > /dev/null 2>&1; then
    echo -e "${BLUE}   Testing iOS build...${NC}"
    if xcrun -sdk iphonesimulator swift build > /dev/null 2>&1; then
        echo -e "${GREEN}✅ iOS package build successful${NC}"
    else
        echo -e "${YELLOW}⚠️  iOS package build failed (may be normal if dependencies missing)${NC}"
    fi
    
    echo -e "${BLUE}   Testing macOS build...${NC}"
    if swift build > /dev/null 2>&1; then
        echo -e "${GREEN}✅ macOS package build successful${NC}"
    else
        echo -e "${YELLOW}⚠️  macOS package build failed (may be normal if UIKit dependencies)${NC}"
    fi
else
    echo -e "${BLUE}   Testing default build...${NC}"
    if swift build > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Package build successful${NC}"
    else
        echo -e "${YELLOW}⚠️  Package build failed (check dependencies)${NC}"
    fi
fi

# Success message
echo -e "${GREEN}🎉 TCAssets generation completed successfully!${NC}"
echo -e "${BLUE}📦 Package is ready to be used${NC}"

# Platform-specific usage examples
echo -e "${BLUE}💡 Usage examples:${NC}"
echo "   import TCAssets"
echo "   let image = Asset.Images.appIcon.image"
echo "   let color = Asset.Colors.primary.color"
echo "   let text = L10n.welcomeMessage"

echo -e "${BLUE}🏗️  Build commands:${NC}"
echo "   iOS:   xcrun -sdk iphonesimulator swift build"
echo "   macOS: swift build"
echo "   Xcode: Build through Xcode (recommended)"

exit 0
