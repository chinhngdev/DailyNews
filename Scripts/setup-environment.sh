#!/bin/bash

# =====================================
# DailyNews Auto Environment Setup
# =====================================

# Default API key (replace with your actual key)
DEFAULT_API_KEY="your_default_news_api_key_here"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get project root directory
get_project_root() {
    # Get the directory where this script is located
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # Go up one level to project root
    echo "$(dirname "$script_dir")"
}

# Get API key automatically or prompt user
get_api_key() {
    # Priority 1: AUTO_API_KEY environment variable (only way to skip prompt)
    if [ -n "$AUTO_API_KEY" ]; then
        echo "$AUTO_API_KEY"
        return 0
    fi
    
    # Priority 2: DEFAULT_API_KEY if explicitly set in script
    if [ "$DEFAULT_API_KEY" != "your_default_news_api_key_here" ]; then
        echo "$DEFAULT_API_KEY"
        return 0
    fi
    
    # Always prompt user for input (output messages to stderr)
    echo -e "${BLUE}📰 DailyNews API Configuration${NC}" >&2
    echo -e "${YELLOW}To use DailyNews app, you need a NewsAPI key from https://newsapi.org${NC}" >&2
    
    # Check if there's existing .env file and show current key
    local env_file="$1"
    if [ -f "$env_file" ]; then
        local existing=$(grep "^NEWS_API_KEY=" "$env_file" 2>/dev/null | cut -d'=' -f2 | tr -d '"')
        if [ -n "$existing" ] && [ "$existing" != "your_actual_api_key_here_replace_this" ]; then
            echo -e "${BLUE}📍 Current API key: ${existing:0:8}...${NC}" >&2
        fi
    fi
    
    echo "" >&2
    echo -e "${BLUE}Please enter your NewsAPI key (or press Enter to skip):${NC}" >&2
    read -p "API Key: " api_key
    
    # Check if user entered something
    if [ -z "$api_key" ]; then
        echo -e "${YELLOW}⚠️  No API key provided. Skipping configuration.${NC}" >&2
        return 1
    fi
    
    # Validate API key format (basic check)
    if [[ ${#api_key} -lt 10 ]]; then
        echo -e "${RED}❌ API key seems too short. Please enter a valid API key.${NC}" >&2
        return 1
    else
        echo -e "${GREEN}✅ API key accepted${NC}" >&2
        echo "$api_key"
        return 0
    fi
}

# Configure .env file
setup_env_file() {
    local api_key="$1"
    local env_file="$2"
    
    # Create or update .env file
    cat > "$env_file" << EOF
# =====================================
# DailyNews API Configuration
# =====================================

# NewsAPI Configuration
NEWS_API_KEY="$api_key"
NEWS_API_BASE_URL="https://newsapi.org/v2"
API_REQUEST_TIMEOUT="30"
ENABLE_API_LOGGING="YES"

# Generated on: $(date)
EOF
}

# Update .gitignore to exclude .env file
update_gitignore() {
    local project_root="$1"
    local gitignore_file="$project_root/.gitignore"
    
    # Check if .env is already in .gitignore
    if [ -f "$gitignore_file" ]; then
        if ! grep -q "^\.env$" "$gitignore_file" 2>/dev/null; then
            echo "" >> "$gitignore_file"
            echo "# Environment variables" >> "$gitignore_file"
            echo ".env" >> "$gitignore_file"
            echo -e "${GREEN}✅ Added .env to .gitignore${NC}"
        fi
    else
        # Create .gitignore if it doesn't exist
        cat > "$gitignore_file" << EOF
# Environment variables
.env

# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/*.xcscheme
*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata

# Build generated
build/
DerivedData/

# Various settings
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/

# Other
.DS_Store
EOF
        echo -e "${GREEN}✅ Created .gitignore with .env excluded${NC}"
    fi
}

# Main
main() {
    echo -e "${GREEN}🚀 Setting up DailyNews environment...${NC}"
    echo ""
    
    local project_root=$(get_project_root)
    local env_file="$project_root/.env"
    local api_key
    
    # Get API key with error handling
    if api_key=$(get_api_key "$env_file"); then
        # API key obtained successfully
        setup_env_file "$api_key" "$env_file"
        update_gitignore "$project_root"
        
        echo ""
        echo -e "${GREEN}✅ DailyNews environment configured successfully!${NC}"
        echo -e "${BLUE}📍 Configuration saved to: $env_file${NC}"
        echo -e "${GREEN}✅ Using your NewsAPI key${NC}"
        
        echo ""
        echo -e "${BLUE}💡 To use the API key in your iOS app:${NC}"
        echo -e "${BLUE}   1. Read from .env file in your Swift code${NC}"
        echo -e "${BLUE}   2. Or use a library like SwiftDotEnv${NC}"
    else
        # No API key provided
        echo ""
        echo -e "${YELLOW}⚠️  Configuration skipped - no API key provided${NC}"
        echo -e "${BLUE}💡 To configure later, you can:${NC}"
        echo -e "${BLUE}   1. Get your API key from: https://newsapi.org${NC}"
        echo -e "${BLUE}   2. Set it as environment variable: export AUTO_API_KEY=\"your_key\"${NC}"
        echo -e "${BLUE}   3. Run this script again${NC}"
        echo ""
        echo -e "${RED}❌ DailyNews app will not work without a valid API key${NC}"
    fi
}

main "$@" 