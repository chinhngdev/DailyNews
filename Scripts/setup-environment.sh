#!/bin/bash

# =====================================
# Environment Setup Script for DailyNews
# =====================================
# Automatically configures API keys using environment variables

set -e  # Exit on any error

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 DailyNews Environment Setup${NC}"
echo "===================================="

# Detect shell configuration file
detect_shell_config() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        if [ -f "$HOME/.bash_profile" ]; then
            echo "$HOME/.bash_profile"
        else
            echo "$HOME/.bashrc"
        fi
    else
        echo "$HOME/.profile"
    fi
}

SHELL_CONFIG=$(detect_shell_config)
echo -e "${BLUE}📁 Shell config: ${NC}$SHELL_CONFIG"

# Check if API key is already configured
check_existing_config() {
    if [ -n "${NEWS_API_KEY}" ]; then
        echo -e "${GREEN}✅ NEWS_API_KEY already configured in environment${NC}"
        return 0
    fi
    
    if grep -q "NEWS_API_KEY" "$SHELL_CONFIG" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  NEWS_API_KEY found in $SHELL_CONFIG but not loaded${NC}"
        echo -e "${BLUE}ℹ️  Please run: source $SHELL_CONFIG${NC}"
        return 1
    fi
    
    return 2
}

# Get API key from user
get_api_key() {
    echo
    echo -e "${PURPLE}🔑 API Key Setup${NC}"
    echo "You need a News API key from: https://newsapi.org/register"
    echo
    
    read -p "Do you have a News API key? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}📖 Please visit https://newsapi.org/register to get your free API key${NC}"
        echo -e "${YELLOW}⏳ Run this script again after getting your API key${NC}"
        exit 0
    fi
    
    echo
    read -p "Enter your News API key: " -s API_KEY
    echo
    
    if [ -z "$API_KEY" ] || [ ${#API_KEY} -lt 10 ]; then
        echo -e "${RED}❌ Invalid API key. Please try again.${NC}"
        exit 1
    fi
    
    echo "$API_KEY"
}

# Add environment variable to shell config
add_to_shell_config() {
    local api_key="$1"
    local config_file="$2"
    
    echo -e "${BLUE}📝 Adding environment variables to $config_file${NC}"
    
    # Create backup
    cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    
    # Add environment variables
    cat >> "$config_file" << EOF

# ===== DailyNews API Configuration =====
# Added by DailyNews setup script on $(date)
export NEWS_API_KEY="$api_key"
export NEWS_API_BASE_URL="https://newsapi.org/v2"
export API_REQUEST_TIMEOUT="30"
export ENABLE_API_LOGGING="YES"
# ======================================

EOF
    
    echo -e "${GREEN}✅ Environment variables added to $config_file${NC}"
}

# Setup Xcode environment variables
setup_xcode_environment() {
    echo -e "${BLUE}🔧 Xcode Scheme Configuration${NC}"
    echo "To add environment variables to Xcode:"
    echo "1. Open your project in Xcode"
    echo "2. Go to Product > Scheme > Edit Scheme..."
    echo "3. Select 'Run' on the left"
    echo "4. Go to 'Arguments' tab"
    echo "5. Add environment variables:"
    echo "   - NEWS_API_KEY = [your_api_key]"
    echo "   - NEWS_API_BASE_URL = https://newsapi.org/v2"
    echo
    echo -e "${YELLOW}💡 Tip: Environment variables in shell config will work automatically${NC}"
}

# Validate configuration
validate_setup() {
    echo -e "${BLUE}🔍 Validating setup...${NC}"
    
    # Source the config file to test
    if [ -f "$SHELL_CONFIG" ]; then
        # shellcheck source=/dev/null
        source "$SHELL_CONFIG"
    fi
    
    if [ -n "${NEWS_API_KEY}" ] && [ "${NEWS_API_KEY}" != "PLACEHOLDER_NEWS_API_KEY" ]; then
        echo -e "${GREEN}✅ NEWS_API_KEY configured successfully${NC}"
        echo -e "${GREEN}✅ API key length: ${#NEWS_API_KEY} characters${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Please restart your terminal or run: source $SHELL_CONFIG${NC}"
        return 1
    fi
}

# Main execution flow
main() {
    echo
    check_result=$(check_existing_config)
    case $? in
        0)
            echo -e "${GREEN}🎉 Environment already configured!${NC}"
            validate_setup
            ;;
        1)
            echo -e "${BLUE}ℹ️  Configuration found but not loaded${NC}"
            validate_setup
            ;;
        2)
            echo -e "${YELLOW}⚙️  Setting up new configuration${NC}"
            API_KEY=$(get_api_key)
            add_to_shell_config "$API_KEY" "$SHELL_CONFIG"
            setup_xcode_environment
            validate_setup
            ;;
    esac
    
    echo
    echo -e "${GREEN}🎉 Setup complete!${NC}"
    echo -e "${BLUE}📱 You can now build and run your DailyNews app${NC}"
    echo
    echo -e "${YELLOW}🔄 Next steps:${NC}"
    echo "1. Restart your terminal OR run: source $SHELL_CONFIG"
    echo "2. Build your project in Xcode"
    echo "3. Run the app - API keys should work automatically!"
    echo
    echo -e "${PURPLE}🔧 Advanced: You can also set environment variables in Xcode schemes${NC}"
}

# Run main function
main 