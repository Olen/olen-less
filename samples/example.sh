#!/usr/bin/env bash
#
# Sample shell script for olen-less demonstration
#

set -euo pipefail

# Configuration
TOOL_NAME="olen-less"
VERSION="1.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if a command exists
has_cmd() {
    command -v "$1" &>/dev/null
}

# Print a colored message
print_status() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# Check for available tools
check_tools() {
    local tools=("glow" "jq" "bat" "yq" "xmllint")

    echo "Checking for optional tools..."
    echo "=============================="

    for tool in "${tools[@]}"; do
        if has_cmd "$tool"; then
            print_status "$GREEN" "✓ $tool is installed"
        else
            print_status "$YELLOW" "○ $tool is not installed (optional)"
        fi
    done
}

# Main function
main() {
    echo "$TOOL_NAME v$VERSION"
    echo ""
    check_tools
}

main "$@"
